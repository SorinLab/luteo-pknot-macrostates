#!/bin/sh

INPUT="/home/fahdata/PKNOT/3-Kinetics/MacrostatesByBoundaries/assign-macrostates-20160912/final-luteo-kmeans-new-nc-macrostates-6ns.mcr"
CUTOFF=6000
OUTPUT_PREFIX="luteo"

./transition-matrix-generator.pl $INPUT $CUTOFF $OUTPUT_PREFIX
