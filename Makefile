clear:
	rm -f iso-rice-en.xml
	rm -f iso-rice-en.adoc
	latexmk -c iso-rice-en.tex

clobber: clear
	rm -f iso-rice-en.adoc
	rm -f iso-rice-en.pdf
	latexmk -C iso-rice-en.tex

iso-rice-en.xml: iso-rice-en.tex
	latexml \
		iso-rice-en.tex \
		--output=iso-rice-en.xml \
		--nocomments

iso-rice-en.adoc: iso-rice-en.xml
	latexmlpost \
		iso-rice-en.xml \
		--nocrossref \
		--stylesheet=tex2mn/Metanorma.xsl \
		--destination=iso-rice-en.adoc \
		--nodefaultresources

iso-rice-en.html:
	docker run -v "$(pwd)":/metanorma/ -w /metanorma ribose/metanorma "metanorma -t iso -x html iso-rice-en.adoc"

# iso-rice-en.pdf: iso-rice-en.tex
# 	latexmk -pdf iso-rice-en.tex
