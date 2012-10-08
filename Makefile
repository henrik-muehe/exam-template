FILES:=$(wildcard */*.tex) metadata.tex
SVGS:=
PLOTS:=
PDFS:=
IMAGES:=$(SVGS:.svg=.pdf) $(PLOTS:.gnuplot=.pdf) $(PDFS)

# $(patsubst %.tex,%.pdf,$(wildcard *.tex))
all: exam.pdf examB.pdf solution.pdf 

%.pdf: %.tex $(FILES) $(IMAGES)
	latexmk -pdf $<

clean:
	rm $(wildcard *.aux *.snm *.log *.nav *.toc *.out *.pdf *.bbl *.blg *.aux.cpy *.synctex.gz *.fdb_latexmk *.pdfsync)

%.pdf: %.svg
	inkscape $< -D --export-pdf=$@

%.pdf: %.gnuplot
	cd $(dir $<) && gnuplot $(notdir $<)
	ps2pdf $(<:.gnuplot=.eps) $@

%.uncropped.pdf: %.eps
	ps2pdf $< $@

%.pdf: %.uncropped.pdf
	pdfcrop $< $@
