#
# TransFig makefile
#
pics=skizze1.tex\
     skizze2.tex
all: *.tex 

# translation into epic

$(pics): %.tex: %.fig
	fig2dev -L epic $< $@

clean:
	rm -f *.tex

