BASE_DIR          = $(PWD)
ENV               ?= dev
PELICAN           = pelican
PELICAN_CONF_FILE = $(BASE_DIR)/publishconf.py
TERRAFORM         = terraform -chdir="./terraform/env/$(ENV)"

.PHONY: all

all: publish deploy invalidate

publish:
	$(PELICAN) -s $(PELICAN_CONF_FILE)

html:
	$(PELICAN)

init:
	$(TERRAFORM) init

plan:
	$(TERRAFORM) plan

apply:
	$(TERRAFORM) apply -auto-approve

deploy: init plan apply

destroy:
	$(TERRAFORM) apply -destroy -auto-approve

invalidate:
	distribution_id="$$($(TERRAFORM) output -raw cloudfront_distribution_id)"; \
	aws cloudfront create-invalidation \
		--distribution-id $$distribution_id \
		--paths "/*" \
		--query "Invalidation.Id" \
		--output text
