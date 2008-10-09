#
# TransFig makefile
#

all: *.tex 

# translation into epic

*.tex: *.fig Makefile
	fig2dev -L epic *.fig *.tex
clean:
	delete *.tex

