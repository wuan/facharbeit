#!/bin/bash

apk add fig2dev --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing/

fig2dev -L epic skizze1.fig skizze1.tex
fig2dev -L epic skizze2.fig skizze2.tex
