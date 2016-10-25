#!/usr/bin/env sh

INPUT="../../MacrostatesByClusters/extracted-macrostates-20150720/macrostateJ.txt"
HOME=/home/fahdata/PKNOT

INPUT_1=$HOME"/all-contacts-P1796_7Ang_2Res.txt"
OUTPUT_1="./0.IOs/0.output.P1796_7Ang_2Res.txt"
../0.contacts-filter.pl $INPUT $INPUT_1 $OUTPUT_1 &>0.stdout-P1796.log

INPUT_2=$HOME"/all-contacts-P1798_7Ang_2Res.txt"
OUTPUT_2="./0.IOs/0.output.P1798_7ANG_2Res.txt"
../0.contacts-filter.pl $INPUT $INPUT_2 $OUTPUT_2 &>0.stdout-P1798.log