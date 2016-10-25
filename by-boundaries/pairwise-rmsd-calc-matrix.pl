#!/usr/bin/perl

# ------------------------ setup I/O -------------------------------------------
$bin_dir          = "/usr/local/share/GRO/gromacs-3.3/bin";
$ndxFile          = "~/Dropbox/SorinLab/1.PKNOT-RNA/3.macrostates/ndx/p1796_2A43_luteo.ndx"; 
# ndx file is needed so that correct group can be selected in g_rmsd ("protein" but actually rna)
$nm2A             = 10.0; # nm to Angstrom conversion
%rmsd             = (); 
@macrostateLabels = ("A", "B", "C", "D", "D1", "E", "E1", "F", "G", "H", "I", "J", "K", "L1", "L2", "L3");
#@macrostateLabels = ("A");
$numOfStrts       = 10;
$topResultsFile   = "top10structures.txt";


# ------------------------- catalog available gro/pdb files --------------------
	foreach $macrostate (@macrostateLabels)
	{
		chdir($macrostate);

		# get gro files
		my @groFiles = ();

		open (TOP10RESULTS, "<$topResultsFile")
		or die "Cannot open $macrostate/$topResultsFile";
		
		while (my $line = <TOP10RESULTS>)
		{
			foreach ($line) {  s/^\s+//; s/\s+$//; s/\s+/ /g; }
			@items = split(' ', $line);

			my $project  =  $items[0];
			my $run      = $items[1];
			my $clone    = $items[2];
			my $time     = $items[3];
			my $distance = $items[13]; # distance to the average structure of this macrostate

			my $groFile = "${macrostate}_p${project}_r${run}_c${clone}_t${time}.gro";
			my @fileNameDistance = ($groFile, $distance);
			push @groFiles, \@fileNameDistance;
		}
		

		# calculate rmsd between any two of the structures
		for (my $i = 0; $i < scalar(@groFiles) - 1; $i++)
		{
			for (my $j = $i + 1; $j < scalar(@groFiles); $j++)
			{
				# calculate RMSD between two structures
				my $struct1 = $groFiles[$i][0];
				my $struct2 = $groFiles[$j][0];

				#print "$struct1 - $struct2\n";
				#next;

				`echo 1 1 | $bin_dir/g_rms -s $struct1 -f $struct2 -n $ndxFile`;

				# and extract it
				my $newIn = `tail -1 rmsd.xvg`;
				foreach ($newIn) { s/^\s+//; s/\s+$//; s/\s+/ /g; }
				
				@rmsdArray = split(' ', $newIn);
				$rmsd{"$i-$j"} = $rmsdArray[1];
				
				if (-e "rmsd.xvg")
				{ `rm rmsd.xvg`; }
			}
		}

		# OUTPUT	
		open (OUTPUT, "> ${macrostate}_RMSD_matrix.txt")
		or die "Cannot write to $outname\n\n";

		# print files that were compared
		for (my $i = 0; $i < scalar(@groFiles); $i++)
		{ print OUTPUT "$i:\t$groFiles[$i][0]\t$groFiles[$i][1]\n"; }
		print OUTPUT "\n";

		# print header row
		printf OUTPUT "%5s\t", "-";
		for (my $i = 0; $i < $numOfStrts; $i++)
		{ printf OUTPUT "%5s\t", "$i"; }
		print OUTPUT "\n";

		for (my $i = 0; $i < $numOfStrts; $i++)
		{
			{ printf OUTPUT "%5s\t", $i; } # print header column

			for (my $j = 0; $j < $numOfStrts; $j++)
			{
				$finalRMSD = $nm2A * $rmsd{"$i-$j"};
				printf OUTPUT "%5.2f\t", $finalRMSD;
  			}
  			print OUTPUT "\n";
		}

		close(OUTPUT);

		chdir("..");
	}