#!/bin/sh

# $averageFilesDir    = $ARGV[0]; # dir with files, each contain average struture for a macrostate
# $macrostateDir      = $ARGV[1]; # dir with files, each contain data points for a given macrostate
# $numberOfTopResults = $ARGV[2]; # number of top structures to return/output
# $outputFileName     = $ARGV[3];

./1.find-real-structures-info-all-states.pl ../stats ../ 1 ./top1.txt