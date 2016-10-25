#!/bin/sh

INPUT="/home/fahdata/PKNOT/3-Kinetics/MacrostatesByBoundaries/assign-macrostates-20160912/final-luteo-kmeans-new-nc-macrostates-0ns.mcr"
CUTOFF="0.0"
OUTPUT_PREFIX="luteo"

./transition-matrix-generator.pl $INPUT $CUTOFF $OUTPUT_PREFIX
