#!/usr/bin/env sh
INPUT=../../../2-Clustering/clustering-result/final_LUTEO_kmeans_with_new_native_contacts_correctClusterNumbers_normalized_20160410_114857.txt
OUTPUT="macrostate"
./macrostates-extractor.pl $INPUT $OUTPUT
