BUCKET       ?= dev.how.wtf
ENV          ?= dev
HUGO         = hugo
MAX_JPG_SIZE = 250
MAX_WIDTH    = 1400
PNG_LEVEL    = 4
SHELL        := /bin/bash
TERRAFORM    = terraform -chdir="./terraform/env/$(ENV)"

tools := hugo terraform aws exiftool jpegoptim optipng mogrify
$(tools):
	@which $@ > /dev/null

.PHONY: publish
publish: website upload invalidate

.PHONY: upload
upload: aws
	aws s3 sync public/. s3://$(BUCKET) --cache-control max-age=604800 --delete

.PHONY: website
website: build optimize

.PHONY: build
build: hugo
	$(HUGO) --gc --minify

.PHONY: optimize
optimize: exif compress

.PHONY: exif
exif: exiftool
	exiftool -all= public/images* -overwrite_original

.PHONY: compress
compress: mogrify optipng jpegoptim
	for i in public/images/*; do \
		mogrify -resize '$(MAX_WIDTH)>' "$$i" ; \
		if [[ "$$i" == *png ]]; then \
			optipng -f4 -clobber -strip all -o $(PNG_LEVEL) -quiet "$$i" ; \
		fi ; \
		if [[ "$$i" == *jp ]]; then \
			jpegoptim --strip-all --size=$(MAX_JPG_SIZE) -quiet "$$i" ; \
		fi ; \
	done

.PHONY: serve
serve: hugo
	$(HUGO) server -D

.PHONY: init
init: terraform
	$(TERRAFORM) init

.PHONY: validate
validate: terraform
	$(TERRAFORM) validate

.PHONY: plan
plan: terraform
	$(TERRAFORM) plan

.PHONY: apply
apply: terraform
	$(TERRAFORM) apply -auto-approve

.PHONY: deploy
deploy: init validate plan apply

.PHONY: destroy
destroy: terraform
	$(TERRAFORM) apply -destroy -auto-approve

.PHONY: invalidate
invalidate: aws
	distribution_id=$$(aws cloudfront list-distributions --query "DistributionList.Items[?starts_with(Origins.Items[0].DomainName, '$(BUCKET)')].Id" --output text); \
	aws cloudfront create-invalidation \
		--distribution-id $$distribution_id \
		--paths "/*" \
		--query "Invalidation.Id" \
		--output text
