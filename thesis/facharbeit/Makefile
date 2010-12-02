#
# TransFig makefile
#
pics=skizze1.tex\
     skizze2.tex

all: facharbeit.pdf

facharbeit.pdf: facharbeit.tex $(pics)
	pdflatex facharbeit.tex
	pdflatex facharbeit.tex
	pdflatex facharbeit.tex

# translation into epic

$(pics): %.tex: %.fig
	fig2dev -L epic $< $@

clean:
	rm -f facharbeit.pdf $(pics)

