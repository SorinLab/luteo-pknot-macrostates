#!/bin/sh
INPUT="/home/fahdata/PKNOT/2-Clustering/clustering-result/final_LUTEO_kmeans_with_new_native_contacts_correctClusterNumbers.txt"
OUTPUT="final-luteo-kmeans-new-nc-macrostates"
CUTOFF=6000
./assign-macrostates.pl $INPUT $OUTPUT $CUTOFF