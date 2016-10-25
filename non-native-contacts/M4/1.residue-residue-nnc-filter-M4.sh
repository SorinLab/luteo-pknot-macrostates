#!/usr/bin/env sh

HOME="/home/fahdata/PKNOT"
NATIVE_CONTACTS=$HOME"/1-NativeContacts/01.outputs/01.c.p1796-7Ang-2res-native-sims-cons-stats.txt"
ALL_CONTACT="./0.IOs/0.output.P1796_7Ang_2Res.txt"
CUTOFF_PERCENT=0.0
CONTACT_DISTANCE=4.5
NC_DISTANCE=6.0
OUTPUT="./1.IOs/1.output.P1796_7Ang_2Res.NNC.txt"
OUTPUT_EXCLUDED="./1.IOs/1.output.P1796_7Ang_2Res.excluded-contacts.txt"
OUTPUT_INCLUDED="./1.IOs/1.output.P1796_7Ang_2Res.included-contacts.txt"

../1.residue-residue-nnc-filter.pl $NATIVE_CONTACTS $ALL_CONTACT $CUTOFF_PERCENT $CONTACT_DISTANCE $NC_DISTANCE $OUTPUT $OUTPUT_EXCLUDED $OUTPUT_INCLUDED &