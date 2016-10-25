#!/usr/bin/perl
use warnings;

# DJ Khai's Remix
# Sep 2016

# DEFINITIONS
# ---------------------------------------------------
# T = Transition matrix
# R = Rate transition matrix
# P = Probability transition matrix
# M = Micro Second matrix (timescale of a transition)
# Transition is from one state to another.
# ---------------------------------------------------

# INPUT FILE SAMPLE
# Macrostate label, Macrostate ID, Cluster ID, Project, Run, Clone, Time, RMSD, RG, S1, S2, L1, L2, T, NC, NNC
# --------------------------------------------------------------------------------------------------------------------
#  0     1  2       3       4       5       6       7        8     9        10      11      12      13      14      15
# --------------------------------------------------------------------------------------------------------------------
# F1     1  0    1796       0       0    6000   1.891   12.420   391       178       5     153     330    1057       0
# F1     1  0    1796       0       0    6100   1.869   12.561   442       165       7     156     345    1115       0
# F1     1  0    1796       0       0    6200   2.044   12.594   449       182       5     153     341    1130       0
# F1     1  0    1796       0       0    6300   1.927   12.724   448       194       7     149     330    1128       0
# F1     1  0    1796       0       0    6400   1.867   12.444   442       192       9     132     333    1108       0
# F1     1  1    1796       0       0    6500   1.902   12.488   422       170       9     160     322    1083       0
# F1     1  0    1796       0       0    6600   1.996   12.461   393       167      10     157     330    1057       0
# F1     1  0    1796       0       0    6700   2.198   12.421   398       167       6     126     264     961       0
# F1     1  0    1796       0       0    6800   2.159   12.615   384       148       8     155     257     952       0
# F1     1  0    1796       0       0    6900   2.356   12.893   389       155       5     144     254     947       0
# --------------------------------------------------------------------------------------------------------------------

# GLOBAL VARIABLES
# ------------------------------------------------------------------------------
$usage = "Usage: $0 {macrostate log file} {cutoff time (in ps)} {output filename prefix}";

my $inputFilename = $ARGV[0] or die "\$inputFilename\n$usage\n";
my $cutoffTime    = $ARGV[1] or die "\$cutoffTime\n$usage\n"; 
$cutoffTime = int $cutoffTime;
my $outputPrefix  = $ARGV[2] or die "\$outputPrefix\n$usage\n";

# INITIALIZATION
# ------------------------------------------------------------------------------
my %macrostates = (
        0 => "X",
        1 => "F1",
        2 => "F2",
        3 => "I1",
        4 => "I2",
        5 => "M1",
        6 => "M2",
        7 => "M3",
        8 => "M4",
        9 => "U1",
        10 => "U2",
        11 => "U3"
    );
my $numberOfMacrostates = scalar(keys %macrostates);
my %transitionsFromMacrostate = (); # Transitions from a macrostate
my %transitionsBetweenMacrostates = (); # Transitions from macrostate i to macrostate j

for (my $i = 0; $i < $numberOfMacrostates; $i++) {
    $transitionsFromMacrostate{$i} = 0;
    for (my $j = 0; $j < $numberOfMacrostates; $j++) {
        $transitionsBetweenMacrostates{"$i,$j"} = 0;
    }
}

# PROCESSING
# ------------------------------------------------------------------------------
open (INPUT, "<", $inputFilename) or die "Cannot open $inputFilename: $!.\n";
my $previousClone      = "";
my $previousTime       = "";
my $previousMacrostateId = "";

while ($line = <INPUT>) {
    if ($. % 20000 == 0) {
        print STDOUT "Input line $. processed: ";
        print STDOUT "macrostate: $previousMacrostateId, clone: $previousClone, time: $previousTime\n";
    }

    if ($line =~ m/^#/) { next; } # skip comments

    foreach ($line) { s/^\s+//; s/\s+$//; s/\s+/ /g; }
    my @items = split(/ /,$line);    
    my $currentMacrostateId = $items[1];
    my $currentClone        = $items[5];
    my $currentTime         = $items[6];

    if ($. == 1 or $currentTime < $cutoffTime) { 
        $previousClone        = $currentClone;
        $previousTime         = $currentTime;
        $previousMacrostateId = $currentMacrostateId;
        next; 
    }
    
    if (($currentClone == $previousClone) # Only count transitions that are not from the last frame in a given simulation
        && ($currentTime - 100 == $previousTime) # Do not count if there are missing frames
        && ($previousTime != 0)) # Do not count jumps from frame at $cutoffTime to frame at $currentTime
    {
        $transitionsBetweenMacrostates{"$previousMacrostateId,$currentMacrostateId"} += 1;
        $transitionsFromMacrostate{$previousMacrostateId} += 1;
    }
    
    $previousClone        = $currentClone;
    $previousTime         = $currentTime;
    $previousMacrostateId = $currentMacrostateId;
}
close INPUT;        

# PRINT RESULTS
# ------------------------------------------------------------------------------
$outputFilename = "$outputPrefix.$cutoffTime.Tmatrix.txt";
open(TOUT,">", $outputFilename) or die "Cannot write to $outputFilename: $!.\n";

printf TOUT "%s", "# Transitions Between Macrostates\n";
printf TOUT "%7s ", " ";

for (my $i = -1; $i < $numberOfMacrostates; $i++) { #Rows
    for (my $j = -1; $j < $numberOfMacrostates; $j++) { #Columns
        if    ($i == -1 && $j != -1) { printf TOUT "%7s ", $macrostates{$j}; }
        elsif ($i != -1 && $j == -1) { printf TOUT "%7s ", $macrostates{$i}; }
        elsif ($i != -1 && $j != -1) { printf TOUT "%7d ", $transitionsBetweenMacrostates{"$i,$j"}; }                
    }
    if ($i != -1) {printf TOUT "%7s", $transitionsFromMacrostate{$i}}
    print TOUT "\n";
}

close(TOUT);
