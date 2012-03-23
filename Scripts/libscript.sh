#!/bin/bash

packages=$(pacman -Qm | awk '{print $1}' | xargs);
for package in $packages; do
result=$(pacman -Qi $package | grep -i “libpng\|libjpeg”);
if [ -n "$result" ]; then
echo $package;
fi
done
