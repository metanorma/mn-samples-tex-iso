#!make
SHELL ?= /bin/bash
METANORMA_PREFIX ?= docker run -v $(shell pwd):/metanorma metanorma/metanorma

TEX  := $(wildcard *.tex)
LXML := $(patsubst %.tex,%.lxml,$(TEX))
ADOC := $(patsubst %.tex,%.adoc,$(TEX))
HTML := $(patsubst %.tex,%.html,$(TEX))
PDF  := $(patsubst %.tex,%.pdf,$(TEX))

MNXSL := tex2mn/Metanorma.xsl

all: $(ADOC) $(HTML)

clear:
	rm -f $(LXML) $(ADOC) *.err *.presentation.xml
	latexmk -c $(TEX)

clobber: clear
	rm -f $(HTML)
	latexmk -C $(TEX)

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
	${METANORMA_PREFIX} metanorma -t iso -x html $<

# iso-rice-en.pdf: iso-rice-en.tex
# 	latexmk -pdf iso-rice-en.tex
