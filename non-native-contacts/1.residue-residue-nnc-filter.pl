#!/usr/bin/perl -w

# ============================================================================ #
#  Counting the number of non-native contacts between a pair of residues.      #
#  Adapted from ~/PKNOT/1-NativeContacts/03.summarize-all-contact-data.pl      #
#  Original by Arad & Khai 1/13/14                                             #
#                                                                              #
#  Modified and refactored by Khai Nguyen July 2015                            #
# ---------------------------------------------------------------------------- #


# ------------------------------------------------------------------------------
#       Get arguments
# ------------------------------------------------------------------------------
    $Usage = 
    "$0 [nat-con-file] ".
    "[all-contact-file] ".
    "[percent] ".
    "[Distance] ".
    "[DistanceNC] ".
    "[output-file] ".
    "[exclude-list-output-file] ".
    "[native-contacts-list-output-file]\n";
    if (scalar @ARGV == 0) { print STDOUT "$Usage\n"; exit; }

    $NativeContactFile = $ARGV[0] or die "$Usage\n";
    $AllContactsFile   = $ARGV[1] or die "$Usage\n";
    $CutOffPercent     = $ARGV[2] or die "$Usage\n";
    $Distance          = $ARGV[3] or die "$Usage\n";
    $DistanceNC        = $ARGV[4] or die "$Usage\n";
    $OutputFile        = $ARGV[5] or die "$Usage\n";
    $ExcludeListFile   = $ARGV[6] or die "$Usage\n";
    $NativeConList     = $ARGV[7] or die "$Usage\n";

    PrintCLIArgs(@ARGV);
    
# ------------------------------------------------------------------------------
#        initialize hash tables
# ------------------------------------------------------------------------------
    print STDOUT "Initializing hash tables....";
    
    # number of atoms there are for the molecule, 
    # must be changed for every new molecule
    $numAtom = 839; 
    for (my $i = 1; $i <= $numAtom; $i++)
    {
        for (my $j = 1; $j <= $numAtom; $j++)
        {
            $NativeSimulationContacts{"$i:$j"} = 0;
            $ExcludedContacts{"$i:$j"}         = 0;
        }
    }
    
    print STDOUT "DONE\n";

# ------------------------------------------------------------------------------
#        store native simulation 
#        contacts info into hash tables for later comparisons
# ------------------------------------------------------------------------------
    open (outNAT,   '>', $NativeConList)     or die "ERROR - $NativeConList: $!.\n";
    open (outEXL,   '>', $ExcludeListFile)   or die "ERROR - $ExcludeListFile: $!.\n";
    open (inNCLIST, '<', $NativeContactFile) or die "ERROR - $NativeContactFile: $!.\n";
    
    print STDOUT "Loading native simlation contact information to memory....";
    while (my $line = <inNCLIST>)
    {
        my $OriginalLine = $line;
        foreach ($line) { s/^\s+//; s/\s+$//; s/\s+/ /g; }
        my @items     = split(/ /, $line);
        
        my $atom1     = $items[0];
        my $atom2     = $items[4];
        my $AtomsPair = "$atom1:$atom2";
        
        $NativeSimulationContacts{$AtomsPair} = 1;

        # Printing out ExcludedContactsded contacts for reference
        # if the percent is small, print line to exclusion list
        if ($items[9] < $CutOffPercent or $items[12] > $DistanceNC)
        {
            $ExcludedContacts{$AtomsPair} = 1;
            print outEXL "$OriginalLine";
        }
        else
        {
            print outNAT "$OriginalLine";
        }
    }

    close(inNCLIST);
    close(outNAT);
    close(outEXL);
    print STDOUT "DONE\n";

# ------------------------------------------------------------------------------
#        find non-native contacts and print to output file
# ------------------------------------------------------------------------------
    open(OUT,   '>', $OutputFile)      or die "ERROR - $OutputFile: $!.\n";
    open(inCON, '<', $AllContactsFile) or die "ERROR - $AllContactsFile: $!.\n";

    print STDOUT "Processing $AllContactsFile....";
    while (my $line = <inCON>)
    {
        my $OriginalLine = $line;
        foreach($line) { s/^\s+//;s/\s+$//; s/\s+/ /g; }        
        my @items     = split(/ /, $line);

        my $atom1     = $items[0];
        my $atom2     = $items[4];
        my $AtomsPair = "$atom1:$atom2";
        my $dist      = $items[9];

        if ($dist <= $Distance and
            !$NativeSimulationContacts{$AtomsPair} and 
            !$ExcludedContacts{$AtomsPair})
        {
            print OUT "$OriginalLine";
        }
    }

    close OUT;
    close inCON;
    print STDOUT "DONE\n";

# ------------------------------------------------------------------------------
#            Subroutines
# ------------------------------------------------------------------------------
sub PrintCLIArgs
{
    my @arguments = @_;
    print STDOUT "$0 ";
    foreach my $argument (@arguments) 
    { 
        print STDOUT "$argument "; 
    }
    print "\n";
}