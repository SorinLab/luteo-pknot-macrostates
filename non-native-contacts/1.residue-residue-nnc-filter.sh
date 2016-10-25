#!/usr/bin/env sh

for i in M1 M2 M3 M4 M5 U1 U2;
do
    cd $i
    if [ ! -d "1.IOs" ]; then
        mkdir "1.IOs"
    fi
    ./1.residue-residue-nnc-filter.sh &
    cd ..
done