#!/usr/bin/perl
use warnings;

# Author  : Khai Nguyen
# Date    : September 2016
# Purpose : A macrostate is identified by four dimensions: RMSD, Rg, native 
#           contacts, and non-native contacts. These boundaries for each 
#           macrostate are specified in the argument input file. Each data 
#           point in the input file is label with its corresponding macrostate.

my $maxRMSD = 32.660;
my $maxRg   = 34.398;
my $maxNC   = 1101.77;
my $maxNNC  = 1930;

my $inputFilename = $ARGV[0];     # big log file with all data points
my $outputPrefix  = $ARGV[1];
my $cutOffTime    = int $ARGV[2]; # in ps

# -------------------------------- INITIALIZATION ------------------------------
open (INPUT,  "<", $inputFilename)  or die "Cannot open $inputFilename. $!\n";

my $outputFilename = $outputPrefix . "-" . $cutOffTime/1000 . "ns.mcr";
open (OUTPUT, ">", $outputFilename) or die "Cannot open $outputFilename. $!\n";

my $logFile  = $outputPrefix . "-" . $cutOffTime/1000 . "ns.log";
open (LOG,    ">", $logFile)        or die "Cannot open $logFile. $!\n";

my %macrostateLabels = (
    "X"  =>  0, # Non-state label, i.e. state that is not the other states
    "F1" =>  1, 
    "F2" =>  2, 
    "I1" =>  3, 
    "I2" =>  4, 
    "M1" =>  5, 
    "M2" =>  6, 
    "M3" =>  7, 
    "M4" =>  8, 
    "U1" =>  9, 
    "U2" => 10, 
    "U3" => 11
);

my %MacrostatePopulations = ();
$MacrostatePopulations{"X"}  = 0;
$MacrostatePopulations{"F1"} = 0;
$MacrostatePopulations{"F2"} = 0;
$MacrostatePopulations{"I1"} = 0;
$MacrostatePopulations{"I2"} = 0;
$MacrostatePopulations{"M1"} = 0;
$MacrostatePopulations{"M2"} = 0;
$MacrostatePopulations{"M3"} = 0;
$MacrostatePopulations{"M4"} = 0;
$MacrostatePopulations{"U1"} = 0;
$MacrostatePopulations{"U2"} = 0;
$MacrostatePopulations{"U3"} = 0;


# -------- EXTRACTING DATA POINTS FOR EACH MACROSTATE --------------------------
while (my $line = <INPUT>) 
{
    my $originalLine = $line;

    foreach ($line) { s/^\s+//; s/\s+$//; s/\s+/ /g; }
    my @items = split(' ', $line);
    my $time  = $items[4];

    if ($time < $cutOffTime) { next; }
    
    my $rmsd = $items[5];  # RMSD
    my $rg   = $items[6];  # Rg
    my $nc   = $items[12]; # Native contacts
    my $nnc  = $items[13]; # Non-native contacts
    
    # Extract State A/F1    SAME
    if (IsBetweenMinMax($rmsd, 0.0, 3.0))
    {   
        printf OUTPUT "%2s\t%2d\t%s", "F1", $macrostateLabels{"F1"}, $originalLine;
        $MacrostatePopulations{"F1"} += 1;
    }

    # Extract State B/F2    CHANGED 7/13/16
    elsif (IsBetweenMinMax($rmsd, 3.0, 6.0) &&
           IsBetweenMinMax($nc, 0.775*$maxNC, $maxNC))
    {
        printf OUTPUT "%2s\t%2d\t%s", "F2", $macrostateLabels{"F2"}, $originalLine;
        $MacrostatePopulations{"F2"} += 1;
    }

    # Extract State C/I1    CHANGED 7/13/16
    elsif (IsBetweenMinMax($rmsd, 3.5, 6.5) &&
           IsBetweenMinMax($nc, 0.55*$maxNC, 0.775*$maxNC))
    {
        printf OUTPUT "%2s\t%2d\t%s", "I1", $macrostateLabels{"I1"}, $originalLine;
        $MacrostatePopulations{"I1"} += 1;
    }

    # Extract State E/I2    CHANGED 7/13/16
    elsif (IsBetweenMinMax($rmsd, 6.5, 11.0) &&
           IsBetweenMinMax($nc, 0.375*$maxNC, 0.70*$maxNC))
    {
        printf OUTPUT "%2s\t%2d\t%s", "I2", $macrostateLabels{"I2"}, $originalLine;
        $MacrostatePopulations{"I2"} += 1;
    }

    # Extract State G/M4    CHANGED 7/13/16
    elsif (IsBetweenMinMax($rmsd, 10.0, 24.0) &&
           IsBetweenMinMax($nc, 0.25*$maxNC, 0.45*$maxNC))
    {
        printf OUTPUT "%2s\t%2d\t%s", "M4", $macrostateLabels{"M4"}, $originalLine;
        $MacrostatePopulations{"M4"} += 1;
    }

    # Extract State H/M1    CHANGED 7/13/16 
    elsif (IsBetweenMinMax($rmsd, 6.5, 10.0) &&
           IsBetweenMinMax($nc, 0.125*$maxNC, 0.30*$maxNC))
    {
        printf OUTPUT "%2s\t%2d\t%s", "M1", $macrostateLabels{"M1"}, $originalLine;
        $MacrostatePopulations{"M1"} += 1;   
    }

    # Extract State I/U1    CHANGED 7/13/16
    elsif (IsBetweenMinMax($rmsd, 10.0, 17.0) &&
           IsBetweenMinMax($nc, 0.125*$maxNC, 0.25*$maxNC))
    {
        printf OUTPUT "%2s\t%2d\t%s", "U1", $macrostateLabels{"U1"}, $originalLine;
        $MacrostatePopulations{"U1"} += 1;
    }

    # Extract State J/U2    CHANGED 7/13/16
    elsif (IsBetweenMinMax($rmsd, 7.0, 26.5) &&
           IsBetweenMinMax($rg, 13.0, $maxRg) &&
           IsBetweenMinMax($nc, 0.03*$maxNC, 0.125*$maxNC) &&
           IsBetweenMinMax($nnc, 0.0, 0.475*$maxNNC))
    {
        printf OUTPUT "%2s\t%2d\t%s", "U2", $macrostateLabels{"U2"}, $originalLine;
        $MacrostatePopulations{"U2"} += 1;
    }

    # Extract State K/M2    CHANGED 7/13/16
    elsif (IsBetweenMinMax($rmsd, 7.0, 26.5) &&
           IsBetweenMinMax($rg, 0.0, 13.0) &&
           IsBetweenMinMax($nc, 0.03*$maxNC, 0.125*$maxNC) &&
           IsBetweenMinMax($nnc, 0.475*$maxNNC, $maxNNC))
    {
        printf OUTPUT "%2s\t%2d\t%s", "M2", $macrostateLabels{"M2"}, $originalLine;
        $MacrostatePopulations{"M2"} += 1;
    }

    # Extract State L/M3    CHANGED 7/13/16
    elsif (IsBetweenMinMax($rmsd, 0.0, 17.0) &&
           IsBetweenMinMax($nc, 0.0, 0.03*$maxNC))
    {
        printf OUTPUT "%2s\t%2d\t%s", "M3", $macrostateLabels{"M3"}, $originalLine;
        $MacrostatePopulations{"M3"} += 1;
    }

    # Extract State U/U3    CHANGED 7/13/16
    elsif (IsBetweenMinMax($rmsd, 17.0, $maxRMSD) &&
           IsBetweenMinMax($nc, 0.0, 0.03*$maxNC))
    {
        printf OUTPUT "%2s\t%2d\t%s", "U3", $macrostateLabels{"U3"}, $originalLine;
        $MacrostatePopulations{"U3"} += 1;
    }

    # Keep track of which datum not assigned to a macrostate
    else
    {
        printf OUTPUT "%2s\t%2d\t%s", "X", $macrostateLabels{"X"}, $originalLine;
        $MacrostatePopulations{"X"} += 1;
    }    
}

my $MacrostatePopulationsLog = "# Macrostate populations:\n";
my $TotalMacrostatePopulation = 0;
foreach my $macrostateKey (sort keys %MacrostatePopulations)
{
    $MacrostatePopulationsLog .= "# Macrostate $macrostateKey: \t$MacrostatePopulations{$macrostateKey}\n";
    $TotalMacrostatePopulation += $MacrostatePopulations{$macrostateKey}
}

print LOG $MacrostatePopulationsLog;
print LOG "# TOTAL: $TotalMacrostatePopulation\n";
print LOG "\n# Number of unassigned data points: " . $MacrostatePopulations{"X"} . "\n";

close INPUT;
close OUTPUT;
close LOG;

sub IsBetweenMinMax
{
    local($number, $min, $max) = @_;
    my $numberIsBetweenMinMax = 0;
    if ($number >= $min && $number < $max) { $numberIsBetweenMinMax = 1; }
    return $numberIsBetweenMinMax;
}