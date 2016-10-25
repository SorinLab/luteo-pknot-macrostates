#!/usr/bin/perl -w

# ============================================================================ #
#  Counting the number of non-native contacts between a pair of residues.      #
#  Adapted from ~/PKNOT/1-NativeContacts/03.summarize-all-contact-data.pl      #
#  Original by Arad & Khai 1/13/14                                             #
#                                                                              #
#  Modified and refactored by Khai Nguyen July 2015                            #
# ---------------------------------------------------------------------------- #


# ------------------------------------------------------------------------------
#               Get arguments
# ------------------------------------------------------------------------------
    $Usage = "$0 [all contacts] [output]";
    if (scalar @ARGV == 0) { print STDOUT "$Usage\n"; exit; }

    $AllContactsFile   = $ARGV[0] or die "$Usage\n";
    $OutputFile        = $ARGV[1] or die "$Usage\n";

    PrintCLIArgs(@ARGV);

# ------------------------------------------------------------------------------
#               Get arguments
# ------------------------------------------------------------------------------
    %ContactMatrix    = ();
    $NumberOfResidues = 26;

    for (my $i = 1; $i <= $NumberOfResidues; $i++)
    {
        for (my $j = 1; $j <= $NumberOfResidues; $j++)
        {
            $ContactMatrix{"$i:$j"} = 0;
        }
    }

# ------------------------------------------------------------------------------
#        Counting residue-residue contacts
# ------------------------------------------------------------------------------
    open(INPUT,  '<', $AllContactsFile) or die "ERROR - $AllContactsFile: $!.\n";

    print STDOUT "Processing $AllContactsFile....";
    while (my $line = <INPUT>)
    {
        my $OriginalLine = $line;
        foreach($line) { s/^\s+//;s/\s+$//; s/\s+/ /g; }        
        my @items     = split(/ /, $line);

        my $residue1     = $items[3];
        my $residue2     = $items[7];
        my $ResiduesPair = "$residue1:$residue2";
        
        $ContactMatrix{$ResiduesPair} += 1;
    }
    
    close INPUT;
    print STDOUT "DONE\n";

# ------------------------------------------------------------------------------
#       Output
# ------------------------------------------------------------------------------
    open(OUTPUT, '>', $OutputFile) or die "ERROR - $OutputFile: $!.\n";

    for (my $i = 1; $i <= $NumberOfResidues; $i++)
    {
        for (my $j = 1; $j <= $NumberOfResidues; $j++)
        {
            print OUTPUT $ContactMatrix{"$i:$j"}, "\t";
        }
        print OUTPUT "\n";
    }

    close OUTPUT;

# ------------------------------------------------------------------------------
#            Subroutines
# ------------------------------------------------------------------------------
sub PrintCLIArgs
{
    my @arguments = @_;
    print STDOUT "$0 ";
    foreach my $argument (@arguments) {  print STDOUT "$argument ";  }
    print "\n";
}