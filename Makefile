# Makefile for retazosmatematicas.tex
#
# Copyright (C) 2022--2026 José A. Navarro Ramón <janr.devel@gmail.com>
# Licencia del código GPLv2
# Licencia Creative Commons Recognition Non-Commercial Share-alike.
# (CC-BY-NC-SA)

IMGSTATICDIR=img/static

FILES =	retazosmatematicas.pkg.sty\
	retazosmatematicas.defs.sty\
	portada/portada.tex\
	tablacontenidos/tablacontenidos.tex\
	prefacio/prefacio.tex\
	texto/coord_R2.tex\
	$(IMGSTATICDIR)/Cc-by-nc-sa_icon.pdf

retazosmatematicas.pdf: retazosmatematicas.tex $(FILES)

%.pdf:	%.tex
	lualatex --enable-write18 $<
	lualatex --enable-write18 $<

$(IMGSTATICDIR)/%.pdf: $(IMGSTATICDIR)/%.svg
	inkscape $< -o $@ --export-ignore-filters --export-ps-level=3

all: retazosmatematicas.pdf

.PHONY: clean

clean:
	rm -rf *.pdf *.ps *.dvi *.aux *.log *.toc *~ *.dat *.script
	rm -rf texto/*.aux texto/*~
	rm -rf portada/*.aux portada/*~
	rm -rf tablacontenidos/*.aux tablacontenidos/*~
	rm -rf prefacio/*.aux prefacio/*~
	rm -rf apendices/*.aux apendices/*~


