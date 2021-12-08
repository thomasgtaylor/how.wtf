ROOT_DIR = os.path.dirname(__file__)
ENV               ?= dev
PELICAN           = pelican
PELICAN_CONF_FILE = $(BASE_DIR)/publishconf.py
TERRAFORM         = terraform -chdir="./terraform/env/$(ENV)"
