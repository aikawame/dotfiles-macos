DOTPATH    := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
CANDIDATES := $(wildcard .??*) bin
EXCLUSIONS := .DS_Store .git .idea
DOTFILES   := $(filter-out $(EXCLUSIONS), $(CANDIDATES))

all: install

install: update deploy
	@exec $$SHELL

list:
	@$(foreach val, $(DOTFILES), /bin/ls -dF $(val);)

update:
	git pull origin master

deploy:
	@echo 'dotfiles をホームディレクトリーに展開します...'
	@$(foreach val, $(DOTFILES), ln -sfnv $(abspath $(val)) $(HOME)/$(val);)

clean:
	@echo 'dotfiles をホームディレクトリーから削除します...'
	@-$(foreach val, $(DOTFILES), rm -rfv $(HOME)/$(val);)
	-rm -rf $(DOTPATH)
