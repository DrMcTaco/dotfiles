SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules
.DEFAULT_GOAL := help
HOMEDIR=$(HOME)
THINGS_TO_LINK=.zshrc .dircolors

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

link: ## Create links from config files to $HOME
	@for filename in $(THINGS_TO_LINK) ; do \
		if [ -e "$(HOMEDIR)/$$filename" ]; \
		then \
			echo "$$filename already exists"; \
		else \
			echo ln -s "$(shell pwd)/config/$$filename" "$(HOMEDIR)/$$filename"; \
			ln -s "$(shell pwd)/config/$$filename" "$(HOMEDIR)/$$filename"; \
		fi; \
	done

# Safe for re-running 
install: link install-packages scm-breeze powerlevel10k## Install all packages and link all files

# Contains stuff that cannot be safely re-run as well, and for now should only be ran the first time we're installing
fresh-install: $(HOMEDIR)/.config/dotfiles-installed ## Run all one time installs and safe to re-run installs.
$(HOMEDIR)/.config/dotfiles-installed: install

install-packages:
ifeq ($(UNAME),Darwin)
	@echo "Darwin detected"
	brew install \
		git \
		zsh \
		curl \
		wget \
		htop \
		nano
else
	@echo "Linux detected. Assuming there's an apt binary though."	
	sudo apt install -y \
		git \
		zsh \
		curl \
		wget \
		htop \
		nano
endif

powerlevel10k: $(HOMEDIR)/powerlevel10k
$(HOMEDIR)/powerlevel10k:
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $(HOMEDIR)/powerlevel10k
	echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>! ~/.zshrc

scm-breeze: $(HOMEDIR)/.scm_breeze
$(HOMEDIR)/.scm_breeze:
	git clone git://github.com/scmbreeze/scm_breeze.git $(HOMEDIR)/.scm_breeze
	~/.scm_breeze/install.sh