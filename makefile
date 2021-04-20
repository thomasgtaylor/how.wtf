BASE_DIR=$(PWD)
BUCKET=how.wtf
OUTPUT_DIR=$(BASE_DIR)/output
PELICAN = pelican
PELICAN_CONF_FILE=$(BASE_DIR)/publishconf.py
STACK=how-wtf

.PHONY: all

all: lint deploy publish sync invalidate

lint:
	@echo " ✨ Running black code formatter... ✨ "
	black $(BASE_DIR)

deploy:
	@echo " 🏗️ Deploying infrastructure changes... 🏗️ "
	cdk deploy $(STACK) --require-approval never

publish:
	@echo " 💻 Generating website... 💻 "
	$(PELICAN) -s $(PELICAN_CONF_FILE)

sync:
	@echo " 📁 Pushing website files into S3... 📁 "
	aws s3 sync $(OUTPUT_DIR)/ s3://$(BUCKET) \
        --metadata-directive REPLACE \
        --cache-control max-age=172800 \
        --delete

invalidate:
	@echo " 📤 Invaliding cloudfront cache... 📤 "
	distribution_id=$$(aws cloudformation describe-stacks \
		--stack-name $(STACK) \
		--query "Stacks[0].Outputs[?Outputkey==\"distributionid\"].OutputValue" \
		--output text); \
	aws cloudfront create-invalidation \
		--distribution-id $$distribution_id \
		--paths "/*.html" \
		--query "Invalidation.Id" \
		--output text