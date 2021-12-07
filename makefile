BASE_DIR          = $(PWD)
BUCKET            = how.wtf
OUTPUT_DIR        = $(BASE_DIR)/output
PELICAN           = pelican
PELICAN_CONF_FILE = $(BASE_DIR)/publishconf.py
ENV               ?= dev
TERRAFORM_DIR     = -chdir="./terraform/env/$(ENV)"

.PHONY: all

all: format publish deploy invalidate

format:
	@echo " ✨ Running black code formatter... ✨ "
	black $(BASE_DIR)

publish:
	@echo " 💻 Generating website... 💻 "
	$(PELICAN) -s $(PELICAN_CONF_FILE)

deploy:
	@echo " 🏗️ Deploying infrastructure changes... 🏗️ "
	terraform $(TERRAFORM_DIR) plan
	terraform $(TERRAFORM_DIR) apply -auto-approve

invalidate:
	@echo " 📤 Invaliding cloudfront cache... 📤 "
	distribution_id=$$(terraform $(TERRAFORM_DIR) output \
		-raw cloudfront_distribution_id \
	); \
	aws cloudfront create-invalidation \
		--distribution-id $$distribution_id \
		--paths "/*" \
		--query "Invalidation.Id" \
		--output text

html:
	@echo " 🔣 Generating local website using Pelican... 🔣 "
	$(PELICAN)

clean:
	@echo " 🔥 Destroying infrastructure... 🔥 "
	terraform $(TERRAFORM_DIR) apply -destroy -auto-approve
