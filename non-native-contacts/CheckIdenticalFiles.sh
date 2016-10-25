#!/usr/bin/env sh

for i in M1 M2 M3 M4 M5 U1 U2;
do
    diff 2.output.residues-matrix-$i.txt $i/2.IOs/2.output.residues-matrix.txt
    echo "=================================================================\n"
done