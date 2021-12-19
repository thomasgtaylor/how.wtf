ENV          ?= dev
HUGO         = hugo
MAX_JPG_SIZE = 250
MAX_WIDTH    = 1400
PNG_LEVEL    = 4
SHELL        := /bin/bash
TERRAFORM    = terraform -chdir="./terraform/env/$(ENV)"

REQUIRED_BINS := hugo terraform aws exiftool jpegoptim optipng mogrify
$(foreach bin,$(REQUIRED_BINS),\
    $(if $(shell command -v $(bin) 2> /dev/null),,$(error Please install `$(bin)`)))

all: build optimize deploy invalidate

build:
	$(HUGO) --gc --minify

optimize: exif compress

exif:
	exiftool -all= public/images* -overwrite_original

compress:
	for i in public/images/*; do \
		mogrify -resize '$(MAX_WIDTH)>' "$$i" ; \
		if [[ "$$i" == *png ]]; then \
			optipng -f4 -clobber -strip all -o $(PNG_LEVEL) -quiet "$$i" ; \
		fi ; \
		if [[ "$$i" == *jp ]]; then \
			jpegoptim --strip-all --size=$(MAX_JPG_SIZE) -quiet "$$i" ; \
		fi ; \
	done

serve:
	$(HUGO) server -D

init:
	$(TERRAFORM) init

validate:
	$(TERRAFORM) validate

plan:
	$(TERRAFORM) plan

apply:
	$(TERRAFORM) apply -auto-approve

deploy: init validate plan apply

destroy:
	$(TERRAFORM) apply -destroy -auto-approve

invalidate:
	distribution_id=$$($(TERRAFORM) output -raw cloudfront_distribution_id); \
	aws cloudfront create-invalidation \
		--distribution-id $$distribution_id \
		--paths "/*" \
		--query "Invalidation.Id" \
		--output text
