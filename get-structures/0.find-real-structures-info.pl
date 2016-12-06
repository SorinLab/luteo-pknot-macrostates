#!/usr/bin/perl -w

# ==============================================================================
# AUTHOR  : KHAI NGUYEN
# DATE    : July 2016
# ==============================================================================

$usage = "perl script.pl -s [0]  -a [1]  -n [2]  -o [3]
    [0]    a file containing all data points for a macrostate
    [1]    a file containing information of the average structure
    [2]    number of top results (real structures) to return
    [3]    output file name
    ";

#-----------------------GET ARGUMENTS-------------------------------------------
    $macrostateDataFile   = "";
    $averageStructureFile = "";
    $numberOfTopResults   = "";
    $outputFile           = "";

    for (my $i = 0; $i <= $#ARGV; $i++)
    {
        $flag = $ARGV[$i];

        if ($flag eq "-s") { $i++; $macrostateDataFile = $ARGV[$i]; next; }
        if ($flag eq "-a") { $i++; $averageStructureFile = $ARGV[$i]; next; }
        if ($flag eq "-n") { $i++; $numberOfTopResults = $ARGV[$i]; next; }
        if ($flag eq "-o") { $i++; $outputFile = $ARGV[$i]; next; }
    }

    if ($ARGV[0] eq "-h") { print "$usage\n"; exit; }
    if (scalar @ARGV == 0) 
    { 
        print "ERROR: Missing one or more arguments.\n$usage\n";
        exit;
    }


#--------------- Parse average structure information ---------------------------
my $averageS1 = 428.61;
my $averageS2 = 188.08;
my $averageL1 = 8.23;
my $averageL2 = 107.25;
my $averageT  = 369.61;
my $averageNC = 1101.77;
my $maxNNC    = 1930;

# stores <rmsd>, <rg>, <stem1>, <stem2>, <loop2>, <tertiary>, max(NNC)
my @averageStructure = (); 

open (AVERAGE_STRUCTURE_FILE, "<", $averageStructureFile) 
    or die "Cannot open average structure file $averageStructureFile. $!.\n";

while (my $line = <AVERAGE_STRUCTURE_FILE>)
{
    chomp($line);
    foreach($line) { s/^\s+//; s/\s+$//; s/\s+/ /g; }
    my @items = split(' ', $line);

    push @averageStructure, $items[1]; # <rmsd>
    push @averageStructure, $items[3]; # <rg>
    push @averageStructure, $items[5] * $averageS1; # <stem1>
    push @averageStructure, $items[7] * $averageS2; # <stem2>
    push @averageStructure, $items[11] * $averageL2; # <loop2>
    push @averageStructure, $items[13] * $averageT; # <tert>
    push @averageStructure, $items[17] * $maxNNC; # max(NNC)
}

close AVERAGE_STRUCTURE_FILE;

# debug/log
foreach my $value (@averageStructure)
{ print "$value\n"; }


#------------------ Parse info from macrostate data points 
# each data point will also have a distance to the average structure calculated
    
@macrostateData = (); # store the original data points and distance to average structure

open (MACROSTATE_DATA_FILE, "<$macrostateDataFile")
    or die "Cannot open input file $macrostateDataFile. $!.\n";

while (my $line = <MACROSTATE_DATA_FILE>)
{
    chomp($line);
    my $originalLine = $line;
    foreach($line) { s/^\s+//; s/\s+$//; s/\s+/ /g; }
    my @items = split(' ', $line);

    # converting to percentage
    my $rmsd  = $items[5];
    my $rg    = $items[6];
    my $stem1 = $items[7];
    my $stem2 = $items[8];
    my $loop2 = $items[10];
    my $tert  = $items[11];
    my $nnc   = $items[13];

    my $distance = (($rmsd - $averageStructure[0]) ** 2 +
                    ($rg - $averageStructure[1]) ** 2 +
                    ($stem1 - $averageStructure[2]) ** 2 +
                    ($stem2 - $averageStructure[3]) ** 2 +
                    ($loop2 - $averageStructure[4]) ** 2 +
                    ($tert - $averageStructure[5]) ** 2 +
                    ($nnc - $averageStructure[6]) ** 2) ** (1/2);

    print "$distance\n";
    my @tuple = ($originalLine, $distance);
    push @macrostateData, \@tuple;
}

close MACROSTATE_DATA_FILE;


#-------------- Sort the data by ascending distances ---------------------------
@sortedMacrostateData = sort { $a->[1] <=> $b->[1] } @macrostateData;


#-------------- Output ---------------------------------------------------------
open (OUTPUT, ">", $outputFile) or die "Cannot write to output $outputFile. $!.\n";
for (my $i = 0; $i < $numberOfTopResults; $i++)
{
    printf OUTPUT "%s\n", 
                  $sortedMacrostateData[$i][0];
}

# Normalize the results to make life easier
print OUTPUT "\n# To make life easier, the results above are normalized:\n";
for (my $i = 0; $i < $numberOfTopResults; $i++)
{
    my $line = $sortedMacrostateData[$i][0];
    foreach($line) { s/^\s+//; s/\s+$//; s/\s+/ /g; }
    my @items = split(' ', $line);
    printf OUTPUT "# ";
    printf OUTPUT "%d\t", $items[0]; # cluster number
    printf OUTPUT "%d\t", $items[1]; # project
    printf OUTPUT "%d\t", $items[2]; # run
    printf OUTPUT "%d\t", $items[3]; # clone
    printf OUTPUT "%d\t", $items[4]; # time
    printf OUTPUT "%6.3f\t", $items[5]; # rmsd
    printf OUTPUT "%6.3f\t", $items[6]; # rg
    printf OUTPUT "%5.3f\t", $items[7]/$averageS1; # stem1
    printf OUTPUT "%5.3f\t", $items[8]/$averageS2; # stem2
    printf OUTPUT "%5.3f\t", $items[9]/$averageL1; # loop1
    printf OUTPUT "%5.3f\t", $items[10]/$averageL2; # loop2
    printf OUTPUT "%5.3f\t", $items[11]/$averageT; # tert
    printf OUTPUT "%5.3f\t", $items[12]/$averageNC; # nc
    printf OUTPUT "%5.3f\n", $items[13]/$maxNNC; # nnc
}

# Print out top 10 (for debug purposes) 
print OUTPUT "\n# TOP 10 STRUCTURES (Euclidean distance is the last column):\n";
for (my $i = 0; $i < 10; $i++)
{
    printf OUTPUT "#\t%s\t%8.6f\n", 
                  $sortedMacrostateData[$i][0], $sortedMacrostateData[$i][1];
}

close OUTPUT;
