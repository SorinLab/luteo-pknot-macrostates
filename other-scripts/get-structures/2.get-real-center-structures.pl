#!/usr/bin/perl

# KHAI REMIX
# Apr 2015

# ----------------------- setup I/O --------------------------------------------
	$pknot_data_loc = "/home/fahdata/PKNOT"; # location where PROJXXXX's are present

	$bin_dir  = "/usr/local/share/GRO/gromacs-3.3/bin";  # location of trjconv
	$gro_dir  = $pknot_data_loc."/PKNOT-FAH-Files"; # location of .ndx files
	
	$infile        = @ARGV[0] || die "\n\tRequires list of data points...\n\n";
	$output_prefix = @ARGV[1] || die "\n\tRequires Name prefix for output pdb/gro files...\n\n"; #chomp $pkname;


# ------------------ get frame info & open .pdb (?) logfile --------------------
	open (INFILE, "< $infile")
	or die "Cannot open input file $infile. $!.\n";

	my $count = 0;
	while (my $line = <INFILE>)
	{
		$count++;

		foreach ($line) {  s/^\s+//; s/\s+$//; s/\s+/ /g; }
		my @items = split(' ', $line);

		$proj    = int($items[0]); # int() is to remove trailing 0's
		$run     = int($items[1]);
		$clone   = int($items[2]);
		$time    = int($items[3]);


# ================== output gromacs files ==================
		# first identify frame number and define .xtc file #
		$frame = int($time/1000);

		# Not sure if the below is necessary --KN
		# fix time to match time in xtc files 
		# $newTime = $time - (1000 * $frame);

	 	$xtcFile = $pknot_data_loc."/PROJ$proj/RUN$run/CLONE$clone/P$proj"."_R$run"."_C$clone".".xtc";
		$tprFile = $pknot_data_loc."/PROJ$proj/RUN$run/CLONE$clone/frame0.tpr";

		if ((-e $xtcFile) and (-e $tprFile))
		{
			# copy xtc and tpr files to current working directory
			system("cp $xtcFile ./current_frame.xtc");
			system("cp $tprFile ./current_frame.tpr");

			# define input filenames for trjconv
			$xtcFile = "current_frame.xtc";
			$tprFile = "current_frame.tpr";
			
			if($proj == 1796){ $ndxFile = "$gro_dir/p1796_2A43_luteo.ndx"; }
			if($proj == 1797){ $ndxFile = "$gro_dir/p1797_2G1W_aquifex.ndx"; }
			if($proj == 1798){ $ndxFile = "$gro_dir/p1798_2A43_luteo.ndx"; }
			if($proj == 1799){ $ndxFile = "$gro_dir/p1799_2G1W_aquifex.ndx"; }

			# define output pdb and gro filenames
			$pdbOut = "$output_prefix"."_p$proj"."_r$run"."_c$clone"."_t$time".".pdb";
			$groOut = "$output_prefix"."_p$proj"."_r$run"."_c$clone"."_t$time".".gro";
			
			# generate pdb and gro files
			system("echo 1 | $bin_dir/trjconv -f $xtcFile -s $tprFile -n $ndxFile -dump $time -o $pdbOut");	
			system("echo 1 | $bin_dir/trjconv -f $xtcFile -s $tprFile -n $ndxFile -dump $time -o $groOut");

			system("rm  current_frame.xtc  current_frame.tpr");
			print "Completed: $proj/$run/$clone/$time\n";			
	  	}

	  	if ($count == 1) { break; } # only get the first structure
	}

	close(INFILE);
