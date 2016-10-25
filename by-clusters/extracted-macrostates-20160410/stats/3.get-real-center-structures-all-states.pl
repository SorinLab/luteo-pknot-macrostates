#!/usr/bin/perl -w

# ==============================================================================
# AUTHOR  : KHAI NGUYEN
# DATE    : 04 2015
# INPUT   : A list of data points; average structure
# OUTPUT  : A 
# PURPOSE :
# ==============================================================================


#--------------- Parse average structure information ---------------------------

	@macrostateLabels = 
    ("A", "B", "C", "E", "G", "H", "I", "J", "K", "L", "U");

	foreach $macrostate (@macrostateLabels)
	{
		chdir($macrostate);
		my $infile = "top1.txt";
		my $output_prefix = $macrostate;

        print STDOUT "Working on macrostate $macrostate....";
        `../2.get-real-center-structures.pl $infile $output_prefix`;
        print STDOUT "DONE\n";

		chdir("..");
	}
