#!/usr/bin/perl

# ==============================================================================
# AUTHOR  : KHAI NGUYEN
# DATE    : 04 2015
# INPUT   : A list of data points; average structure
# OUTPUT  : A 
# PURPOSE :
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
	$minRMSD          = 0.043; 
	$maxRMSD          = 32.660;
	$minRg            = 10.639; 
	$maxRg            = 34.398;
	$minNC            = 0; 
	$maxNC            = 1441; # maximum number of native contacts
	$minNNC           = 0; 
	$maxNNC           = 1930; # maximum number of non-native contacts
	@averageStructure = (); # store <rmsd>, <rg>, <nc> (absolute), <nnc> (absolute)

	open (AVERAGE_STRUCTURE_FILE, "< $averageStructureFile") 
	or die "Cannot open average structure file $averageStructureFile. $!.\n";

	while (my $line = <AVERAGE_STRUCTURE_FILE>)
	{
		chomp($line);
		foreach($line) { s/^\s+//; s/\s+$//; s/\s+/ /g; }
		my @items = split(' ', $line);

		my $scaled_rmsd = ($items[1] - $minRMSD) / ($maxRMSD - $minRMSD);
		push @averageStructure, $scaled_rmsd;           # <rmsd>
		
		my $scaled_rg = ($items[4] - $minRg) / ($maxRg - $minRg);
		push @averageStructure, $scaled_rg;           # <rg>
		push @averageStructure, $items[22] ;  # <nc> already scaled
		push @averageStructure, $items[25]; # <nnc> already scaled
	}

	close AVERAGE_STRUCTURE_FILE;
	
	#
	# debug
	#
	foreach my $value (@averageStructure)
	{ print $value, "\n"; }

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
		my $rmsd = ($items[4] - $minRMSD) / ($maxRMSD - $minRMSD);
		my $rg   = ($items[5] - $minRg) / ($maxRg - $minRg);
		my $nc   = ($items[11] - $minNC) / ($maxNC - $minNC);
		my $nnc  = ($items[12] - $minNNC) / ($maxNNC - $minNNC);

		my $distance = (($rmsd - $averageStructure[0]) ** 2 +
							  ($rg - $averageStructure[1]) ** 2 +
							  ($nc - $averageStructure[2]) ** 2 +
							 ($nnc - $averageStructure[3]) ** 2) ** (1/2);

		print "$distance\n";
		my @tuple = ($originalLine, $distance);
		push @macrostateData, \@tuple;
	}

	close MACROSTATE_DATA_FILE;


#-------------- Sort the data by descending distances --------------------------
	@sortedMacrostateData = sort { $a->[1] <=> $b->[1] } @macrostateData;


#-------------- Output ---------------------------------------------------------
	open (OUTPUT, ">", $outputFile) 
	or die "Cannot write to output $outputFile. $!.\n";
	for ($i = 0; $i < $numberOfTopResults; $i++)
	{
		printf OUTPUT "%s\t%8.6f\n", 
		$sortedMacrostateData[$i][0], $sortedMacrostateData[$i][1];
	}
	
	close OUTPUT;