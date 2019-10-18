
DOTFILES := $(HOME)/.dotfiles
SRC := $(shell find $(DOTFILES) -type d -name '.git' -prune -o -type f -print)
DST := $(HOME)

TARGETS := $(patsubst $(DOTFILES)/%, $(DST)/%, $(abspath $(SRC)))

sync: $(TARGETS)

$(DST)/%: $(DOTFILES)/%
	mkdir -p $(dir $@)
	ln -s $(realpath $<) $@
