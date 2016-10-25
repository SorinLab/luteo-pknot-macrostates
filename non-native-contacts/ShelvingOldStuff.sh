#!/usr/bin/env sh

for i in M1 M2 M3 M4 M5 U1 U2;
do
    cp $i/2.IOs/2.output.residues-matrix.txt 2.output.residues-matrix-$i.txt
done