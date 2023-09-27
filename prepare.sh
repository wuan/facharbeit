#!/bin/bash

apk add gnuplot
apk add fig2dev --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing/

fig2dev -L latex skizze1.fig skizze1.tex
fig2dev -L latex skizze2.fig skizze2.tex
gnuplot funktion1.gnu
