#!/usr/bin/perl

# ==============================================================================
# AUTHOR  : KHAI NGUYEN
# DATE    : July 2016
# ==============================================================================


#--------------- Parse average structure information ---------------------------

@macrostateLabels = 
("A", "B", "C", "E", "G", "H", "I", "J", "K", "L", "U");

foreach $macrostate (@macrostateLabels)
{
    chdir($macrostate);
    my $infile = "top1.txt";
    my $output_prefix = $macrostate;

    `../2.get-real-center-structures.pl $infile $output_prefix`;

    chdir("..");
}