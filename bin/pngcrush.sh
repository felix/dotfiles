#!/bin/sh

for png in *.png; do
    pngcrush -rem gAMA -rem cHRM -rem iCCP -rem sRGB -brute -bail -reduce -ow $png
done
