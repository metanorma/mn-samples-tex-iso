#!make
SHELL := /bin/bash

TEX  := $(wildcard *.tex)
LXML := $(patsubst %.tex,%.lxml,$(TEX))
ADOC := $(patsubst %.tex,%.adoc,$(TEX))
HTML := $(patsubst %.tex,%.html,$(TEX))
PDF  := $(patsubst %.tex,%.pdf,$(TEX))

MNXSL := tex2mn/Metanorma.xsl

all: $(HTML)

clear:
	rm -f $(LSXML) $(ADOC)
	latexmk -c $(TEX)

clobber: clear
	rm -f $(HTML)
	latexmk -C iso-rice-en.tex

%.lxml: %.tex
	latexml \
		$< \
		--output=$@ \
		--nocomments

%.adoc: %.lxml
	latexmlpost \
		$< \
		--nocrossref \
		--stylesheet=$(MNXSL) \
		--destination=$@ \
		--nodefaultresources

%.html: %.adoc
	docker run -v $(shell pwd):/metanorma metanorma/metanorma metanorma -t iso -x html $<

# iso-rice-en.pdf: iso-rice-en.tex
# 	latexmk -pdf iso-rice-en.tex
