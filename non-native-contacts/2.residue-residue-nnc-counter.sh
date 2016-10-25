#!/usr/bin/env sh

for i in M1 M2 M3 M4 M5 U1 U2;
do
    cd $i
    if [ ! -d "2.IOs" ]; then
        mkdir "2.IOs"
    fi
    ./2.residue-residue-nnc-counter.sh &
    cd ..
done