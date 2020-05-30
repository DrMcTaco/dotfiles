SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules
.DEFAULT_GOAL := help
HOMEDIR=$(HOME)
UNAME=$(shell uname)

THINGS_TO_LINK=.zshrc .dircolors .p10k.zsh .fzf.zsh
PYTHON_VERSIONS=3.7.7
GLOBAL_PYTHON=3.7.7

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

install-pythons: pyenv
	@export PATH="~/.pyenv/bin:$(PATH)"; \
	for version in $(PYTHON_VERSIONS) ; do \
		if [ ! -d "$(HOMEDIR)/.pyenv/versions/$$version" ]; \
		then \
			pyenv install $$version; \
		fi; \
	done

global-pyhton: $(HOMEDIR)/.pyenv/version pyenv install-pythons
$(HOMEDIR)/.pyenv/version:
	pyenv global $(GLOBAL_PYTHON)

# Safe for re-running 
install: link install-packages scm-breeze powerlevel10k fzf ls_colors zsh_completetions global-pyhton poetry## Install all packages and link all files

# Contains stuff that cannot be safely re-run as well, and for now should only be ran the first time we're installing
fresh-install: $(HOMEDIR)/.config/dotfiles-installed ## Run all one time installs and safe to re-run installs.
$(HOMEDIR)/.config/dotfiles-installed: install

install-packages:
ifeq ($(UNAME),Darwin)
	@echo "Darwin detected"
	if [[ $$(command -v brew) == "" ]]; then \
		/usr/bin/ruby -e "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" \
	else \
	 		brew update; \
	fi;
	brew install \
		git \
		zsh \
		curl \
		wget \
		htop \
		nano \
		python3 \
		openssl \
		readline \
		sqlite3 \
		xz \
		zlib \
		readline \
		xz \
		pyenv
else
	@echo "Linux detected. Assuming there's an apt binary though."	
	sudo apt-get update
	sudo apt install -y --no-install-recommends \
		git \
		zsh \
		curl \
		wget \
		htop \
		nano \
		python3 \
		make \
		build-essential \
		libssl-dev \
		zlib1g-dev \
		libbz2-dev \
		libreadline-dev \
		libsqlite3-dev \
		wget \
		curl \
		llvm \
		libncurses5-dev \
		xz-utils \
		tk-dev \
		libxml2-dev \
		libxmlsec1-dev \
		libffi-dev \
		liblzma-dev 
endif

powerlevel10k: $(HOMEDIR)/powerlevel10k
$(HOMEDIR)/powerlevel10k:
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $(HOMEDIR)/powerlevel10k

scm-breeze: $(HOMEDIR)/.scm_breeze
$(HOMEDIR)/.scm_breeze:
	git clone git://github.com/scmbreeze/scm_breeze.git $(HOMEDIR)/.scm_breeze
	~/.scm_breeze/install.sh

fzf:  $(HOMEDIR)/.fzf
$(HOMEDIR)/.fzf:
	git clone --depth 1 https://github.com/junegunn/fzf.git $(HOMEDIR)/.fzf
	$(HOMEDIR)/.fzf/install

ls_colors: $(HOMEDIR)/.local/share/lscolors.sh
$(HOMEDIR)/.local/share/lscolors.sh:
ifeq ($(UNAME),Darwin)
else
	mkdir -p $(HOMEDIR)/.local/share || true
	mkdir /tmp/LS_COLORS && curl -L https://api.github.com/repos/trapd00r/LS_COLORS/tarball/master | tar xzf - --directory=/tmp/LS_COLORS --strip=1
	cd /tmp/LS_COLORS && sh install.sh
endif 

zsh_completetions: $(HOMEDIR)/.zsh/zsh-autosuggestions
$(HOMEDIR)/.zsh/zsh-autosuggestions:
	git clone https://github.com/zsh-users/zsh-autosuggestions $(HOMEDIR)/.zsh/zsh-autosuggestions

pyenv: $(HOMEDIR)/.pyenv
$(HOMEDIR)/.pyenv:
ifeq ($(UNAME),Darwin)
else  
	curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
endif

poetry: $(HOMEDIR)/.poetry/bin
$(HOMEDIR)/.poetry/bin:
	curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python
