#
# TransFig makefile
#
pics=skizze1.tex\
     skizze2.tex

gnuplot=funktion1.tex

all: facharbeit.pdf

facharbeit.pdf: facharbeit.tex $(pics) $(gnuplot)
	pdflatex facharbeit.tex
	pdflatex facharbeit.tex
	pdflatex facharbeit.tex

# translation into epic

$(pics): %.tex: %.fig
	fig2dev -L latex $< $@

$(gnuplot): %.tex: %.gnu
	gnuplot $< 

clean:
	rm -f facharbeit.pdf $(pics) $(gnuplot)

