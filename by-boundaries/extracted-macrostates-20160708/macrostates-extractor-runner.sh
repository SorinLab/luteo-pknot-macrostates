#!/bin/sh
INPUT="/home/fahdata/PKNOT/2-Clustering/clustering-result/final_LUTEO_kmeans_with_new_native_contacts_correctClusterNumbers.txt"
OUTPUT="macrostate"
./macrostates-extractor.pl $INPUT $OUTPUT
