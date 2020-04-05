# Makefile
NAME        := pathific
VERSION     := $(shell grep -m 1 -o '[0-9][0-9.]\+' README.md)

# Paths
PREFIX      ?= /usr/local
MANPREFIX   ?= $(PREFIX)/share/man
DOCDIR      ?= $(PREFIX)/share/doc/pathific

INSTALLDIR  := $(DESTDIR)$(PREFIX)
MANPREFIX   := $(DESTDIR)$(MANPREFIX)
DOCDIR      := $(DESTDIR)$(DOCDIR)

USERCONFDIR := $(HOME)/.config/pathific

# Operatios
default: help

help:
	@echo 'Help message'
	@echo ''
	@echo 'make                    Do nothing and show help message.'
	@echo 'make options            Show some options for installation.'
	@echo 'make copy-config        Copy default configuration to $(USERCONFDIR).'
	@echo 'make copy-local-config  Copy local configuration template to $(USERCONFDIR).'
	@echo 'make man                Compile the manpage with "pod2man".'

options:
	@echo 'Options'
	@echo
	@echo 'INSTALLDIR  = $(INSTALLDIR)'
	@echo 'MANPREFIX   = $(MANPREFIX)'
	@echo 'DOCDIR      = $(DOCDIR)'
	@echo 'USERCONFDIR = $(USERCONFDIR)'

copy-config:
	@echo 'Copy the default configuration files to user config directory.'
	@echo
	install -d $(USERCONFDIR)
	cp -i examples/pathificrc --target-directory=$(USERCONFDIR)

copy-local-config:
	@echo 'Copy the default local configuration files to user config directory.'
	@echo
	install -d $(USERCONFDIR)
	cp -i examples/pathificrc.local examples/Pathfile.local --target-directory=$(USERCONFDIR)

man:
	pod2man --stderr -center='pathific manual' --date='$(NAME)-$(VERSION)' \
	    --release=$(shell date +%x) doc/pathific.pod doc/pathific.1

.PHONY: default help options copy-config copy-local-config man
