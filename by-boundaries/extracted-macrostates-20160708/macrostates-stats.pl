#!/usr/bin/perl -w
use lib '/home/fahdata/perl5/lib/perl5';
use Statistics::Descriptive;

# Author: Khai Nguyen
# Date:   Jul 2016
# Purpose: This scripts calculate the average and standard deviation of the
#          following metrics: RMSD, Rg, number of native contacts, and number
#          of non-native contacts.


# ---------------- input & output filenames ------------------------------------
    $input    = $ARGV[0]; # file with data points, including rmsd, rg, nc, nnc
    $output   = $ARGV[1]; # output filename

    $averageNcS1 = 428.61;
    $averageNcS2 = 188.08;
    $averageNcL1 = 8.23;
    $averageNcL2 = 107.25;
    $averageNcT  = 369.61;
    $averageNC   = 1101.77;
    $averageNNC  = 1930.00;

    $statRMSD = Statistics::Descriptive::Full->new();
    $statRg   = Statistics::Descriptive::Full->new();
    $statS1   = Statistics::Descriptive::Full->new();
    $statS2   = Statistics::Descriptive::Full->new();
    $statL1   = Statistics::Descriptive::Full->new();
    $statL2   = Statistics::Descriptive::Full->new();
    $statT    = Statistics::Descriptive::Full->new();
    $statNC   = Statistics::Descriptive::Full->new();
    $statNNC  = Statistics::Descriptive::Full->new();

# -------- parsing data --------------------------------------------------------
    open (INPUT, "<", $input) or die "$input. $!.\n";
    while (my $line = <INPUT>)
    {
        chomp($line);
        my $OriginalLine = $line;

        foreach ($line) { s/^\s+//; s/\s+$//; s/\s+/ /g; }

        my @items = split(' ', $line);

        my $rmsd = $items[5];  # RMSD
        my $rg   = $items[6];  # Rg
        my $s1   = $items[7];  # stem 1 native contacts
        my $s2   = $items[8];  # stem 2 native contacts
        my $l1   = $items[9];  # loop 1 native contacts
        my $l2   = $items[10]; # loop 2 native contacts
        my $t    = $items[11]; # tertiary native contacts
        my $nc   = $items[12]; # Native contacts
        my $nnc  = $items[13]; # Non-native contacts

        $statRMSD->add_data($rmsd);
        $statRg->add_data($rg);
        $statS1->add_data($s1/$averageNcS1);
        $statS2->add_data($s2/$averageNcS2);
        $statL1->add_data($l1/$averageNcL1);
        $statL2->add_data($l2/$averageNcL2);
        $statT->add_data($t/$averageNcT);
        $statNC->add_data($nc/$averageNC);
        $statNNC->add_data($nnc/$averageNNC);
    }
    close INPUT;

# -------------- statistics calculations ---------------------------------------
    $meanRMSD   = $statRMSD->mean();
    $stdDevRMSD = $statRMSD->standard_deviation();

    $meanRg     = $statRg->mean();
    $stdDevRg   = $statRg->standard_deviation();

    $meanS1 = $statS1->mean();
    $stdDevS1 = $statS1->standard_deviation();

    $meanS2 = $statS2->mean();
    $stdDevS2 = $statS2->standard_deviation();

    $meanL1 = $statL1->mean();
    $stdDevL1 = $statL1->standard_deviation();

    $meanL2 = $statL2->mean();
    $stdDevL2 = $statL2->standard_deviation();

    $meanT = $statT->mean();
    $stdDevT = $statT->standard_deviation();

    $meanNC     = $statNC->mean();
    $stdDevNC   = $statNC->standard_deviation();

    $meanNNC    = $statNNC->mean();
    $stdDevNNC  = $statNNC->standard_deviation();

# -------------- output result to file -----------------------------------------
    open (OUTPUT, ">", $output) or die "$output. $!.\n";

    $state = $input;
    $state =~ s/^macrostate//; # remove the word "macrostate" at the beginning
    $state =~ s/....$//; # remove the extention (".txt")

    printf OUTPUT "%-2s\t". "%4.1f\t". "%3.1f\t".   "%4.1f\t". "%3.1f\t",
                  $state,   $meanRMSD, $stdDevRMSD, $meanRg,   $stdDevRg;

    printf OUTPUT "%5.3f\t". "%5.3f\t". "%5.3f\t". "%5.3f\t",
                  $meanS1,   $stdDevS1, $meanS2,   $stdDevS2;

    printf OUTPUT "%5.3f\t". "%5.3f\t". "%5.3f\t". "%5.3f\t",
                  $meanL1,   $stdDevL1, $meanL2,   $stdDevL2;

    printf OUTPUT "%5.3f\t". "%5.3f\t",
                  $meanT,    $stdDevT;

    printf OUTPUT "%5.3f\t". "%5.3f\t". "%5.3f\t". "%5.3f\n",
                  $meanNC,   $stdDevNC, $meanNNC,  $stdDevNNC;

    close OUTPUT;
