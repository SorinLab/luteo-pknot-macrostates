#!/usr/bin/env perl
use warnings;

# Author: Khai Nguyen
# Date:   July, 2015
# Purpose: 

$Input        = $ARGV[0]; # big log file with all data points
$OutputPrefix = $ARGV[1];


# ==============================================================================
#            Microstate to Macrostate Mapping
# ------------------------------------------------------------------------------
    %MicroToMacroStateMap =
    (
        0   => "A",

        1   => "B",

        2   => "C",

        3   => "H",
        5   => "H",

        4   => "E",
        6   => "E",

        7   => "K",
        9   => "K",
        10  => "K",

        16  => "J",
        17  => "J",
        19  => "J",
        20  => "J",
        21  => "J",
        22  => "J",
         
        8   => "I",
        11  => "I",
        12  => "I",

        13  => "L",
        14  => "L",
        15  => "L",

        18  => "G",

        23  => "U",
        24  => "U",
        25  => "U",
        26  => "U"
    );

    @states = uniq(values %MicroToMacroStateMap);

# ==============================================================================
#            Create File Handles for Output Files The Cool Way
# ------------------------------------------------------------------------------
    %OutputFileHandles = ();
    
    for (my $state = 0; $state < scalar(@states); $state++)
    {
        local *FILE;
        my $outputFileName = $OutputPrefix.$states[$state].".txt";
        open (FILE, ">$outputFileName") or die "$outputFileName: $!\n";
        $OutputFileHandles{$states[$state]} = *FILE;
    }

# ==============================================================================
#             Extracting data points for each macrostate
# ------------------------------------------------------------------------------
    open (INPUT, "<", $Input) or die "$Input: $!\n";
    $CutOffTime = 6000;

    while (my $line = <INPUT>) 
    {
        my $OriginalLine = $line;
        
        foreach ($line) { s/^\s+//; s/\s+$//; s/\s+/ /g; }
        my @items   = split(' ', $line);
        my $cluster = $items[0];
        my $time    = $items[4];

        if ($time >= $CutOffTime) 
        {
            my $file = $OutputFileHandles{$MicroToMacroStateMap{$cluster}};
            print $file $OriginalLine;
        }
    }

    close INPUT;    
    foreach my $file (@OutputFileHandles)  {  close $file;  }

# not sure how this works, but it does work
# copied from: http://perlmaven.com/unique-values-in-an-array-in-perl
sub uniq
{
    my %seen;
    return grep { !$seen{$_}++ } @_;
}
