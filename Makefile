#
# TransFig makefile
#
pics=skizze1.tex\
     skizze2.tex

gnuplot=funktion1.tex

all: facharbeit.pdf

facharbeit.pdf: facharbeit.tex pics
	latexmk -pdf facharbeit.tex

pics: $(pics) $(gnuplot)

$(pics): %.tex: %.fig
	fig2dev -L latex $< $@

$(gnuplot): %.tex: %.gnu
	gnuplot $< 

clean:
	rm -f facharbeit.pdf $(pics) $(gnuplot) *.aux *.log *.toc *.fls *.fdb_*

