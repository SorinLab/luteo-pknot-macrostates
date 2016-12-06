#!/usr/bin/perl

# ==============================================================================
# AUTHOR  : KHAI NGUYEN
# DATE    : July 2016
# ==============================================================================

$usage = "$0 avgDir  macrostateDir  numTopResults  outputFileName";

#-----------------------GET ARGUMENTS-------------------------------------------
	$averageFilesDir    = $ARGV[0]; # dir with files, each contain average struture for a macrostate
	$macrostateDir      = $ARGV[1]; # dir with files, each contain data points for a given macrostate
	$numberOfTopResults = $ARGV[2]; # number of top structures to return/output
	$outputFileName     = $ARGV[3];


#--------------- Parse average structure information ---------------------------

	@averageFiles = `ls $averageFilesDir | grep macrostate`;

	foreach $averageFile (@averageFiles)
	{
		chomp($averageFile);

		# get the macrostate label
		my $state = $averageFile; 
		$state =~ s/^macrostate//;
		$state =~ s/stats.txt$//;

		print $state, "\n";

		mkdir($state);

		`./0.find-real-structures-info.pl -s $macrostateDir/macrostate$state.txt -a $averageFilesDir/$averageFile -n $numberOfTopResults -o $state/$outputFileName`;
	}
