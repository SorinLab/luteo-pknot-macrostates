#!/usr/bin/perl

# ==============================================================================
# AUTHOR  : KHAI NGUYEN
# DATE    : 04 2015
# INPUT   : A list of data points; average structure
# OUTPUT  : A 
# PURPOSE :
# ==============================================================================


#--------------- Parse average structure information ---------------------------

	@macrostateLabels = 
	("A", "B", "C", "E", "G", "H", "I", "J", "K", "L1", "L2", "L3");

	foreach $macrostate (@macrostateLabels)
	{
		chdir($macrostate);
		my $infile = "top10";
		my $output_prefix = $macrostate;

		`../2.get-real-center-structures.pl $infile $output_prefix`;

		chdir("..");
	}