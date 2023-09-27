#!/bin/bash

apk add fig2dev --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community

fig2dev -L epic skizze1.fig skizze1.tex
fig2dev -L epic skizze2.fig skizze2.tex
