#!/usr/bin/perl -w

# ==============================================================================
#
#   Collecting all contacts from simulations that were determined to be native       
#   Original By ARAD 10/1/13
#   Modified and refactored by KHAI NGUYEN 08/01/15
#
# ==============================================================================


# ------------------------------------------------------------------------------
#       usage & getting input information into appropriate variables
# ------------------------------------------------------------------------------
    $usage = "$0  [data points]  [concatenated contacts]  [output]\n";
    if (scalar @ARGV == 0) { print $usage; exit(); }

    $DataPointsFile           = $ARGV[0] or die "$usage\n";
    $ConcatenatedContactsFile = $ARGV[1] or die "$usage\n";
    $OutputFile               = $ARGV[2] or die "$usage\n";

    PrintCLIArgs(@ARGV);

# ------------------------------------------------------------------------------
#       loads data points into memory @DataPoints
# ------------------------------------------------------------------------------
    open(NSFILE, '<', $DataPointsFile) or die "ERROR - $DataPointsFile: $!.\n";
    print STDOUT "Reading $DataPointsFile....";
    
    %DataPoints = ();
    
    while(my $line = <NSFILE>)
    {
        if ($line =~ m/#/) { next; } #ignore comments/header in file
        
        # remove leading & trailing whitespace, 
        # replace any whitespace between words by a single whitespace
        foreach($line) { s/^\s+//; s/\s+$//; s/\s+/ /g; }
            
        # the array below should contain: 
        # (0) project, (1) run, (2) clone, (3) total time in ps
        my @items = split(/ /, $line);
            
        # creating reference time stamp
        my $project     = $items[1];
        my $run         = $items[2];
        my $clone       = $items[3];
        my $frame       = $items[4]/100;
        my $DataPointId = "p${project}_r${run}_c${clone}_f${frame}.con";
        print STDOUT "Imported $DataPointId\n";
            
        # storing reference data into a 1D array for accessment later
        $DataPoints{$DataPointId} = 1;
    }
    
    close(NSFILE);
    print STDOUT "DONE\n";

# ------------------------------------------------------------------------------
#       process lines from the all contacts data file
# ------------------------------------------------------------------------------
    open (OUTPUT, '>', $OutputFile) or die "ERROR - $OutputFile: $!.\n";
    open (CONFILE, '<', $ConcatenatedContactsFile) or die "ERROR - $ConcatenatedContactsFile: $!.\n";

    $CurrentLineShouldBePrinted = 0;
    
    print STDOUT "Reading $ConcatenatedContactsFile....";
    LBL: while (my $line = <CONFILE>)
    {
        chomp($line);
        $OriginalLine = $line;

        my $CurrentLineIsDataPointId = 0;
        if ($line =~ m/p/) { $CurrentLineIsDataPointId = 1; }
        
        if ($CurrentLineIsDataPointId) 
        {
            print STDOUT "Examine $line...\n";
            if (defined $DataPoints{$line} and $DataPoints{$line} == 1)
            { 
                $CurrentLineShouldBePrinted = 1;
                print STDOUT "MATCHED: \$ConcatenatedContactsFile::$line == \%DataPoints: $DataPoints{$line}\n"; 
                next LBL;
            }
            else 
            { 
                $CurrentLineShouldBePrinted = 0;
            }
        }

        if (!$CurrentLineIsDataPointId and $CurrentLineShouldBePrinted)
        { 
            print OUTPUT "$OriginalLine\n";
        }
    }
    close CONFILE;
    close OUTPUT;
    print STDOUT "DONE\n";

# ------------------------------------------------------------------------------
#       subroutines
# ------------------------------------------------------------------------------
sub PrintCLIArgs
{
    my @arguments = @_;
    print "$0 ";
    foreach my $item (@arguments) { print "$item "; }
    print "\n";
}