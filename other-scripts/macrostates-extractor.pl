#!/usr/bin/env perl

# Author: Khai Nguyen
# Date:   Jun 2015
# Purpose: A macrostate is identified by four dimensions: RMSD, Rg, native 
#          contacts, and non-native contacts. These boundaries for each 
#          macrostate are specified in the argument input file. The data points 
#          whose values in these boundaries are extracted and placed in a file.


# ---------------- MACROSTATE BOUNDARIES ---------------------------------------
	$maxRMSD       = 32.660;
	$maxRg         = 34.398;
	$maxNC         = 1441;
	$maxNNC        = 1930;
	$input         = $ARGV[0]; # big log file with all data points
	$output_prefix = $ARGV[1];

# -------- EXTRACTING DATA POINTS FOR EACH MACROSTATE --------------------------
	open (INPUT, "<", $input)
	or die "Cannot open $input. $!\n";

	open (OUT_A, ">", $output_prefix."A.txt");
	open (OUT_B, ">", $output_prefix."B.txt");
	open (OUT_C, ">", $output_prefix."C.txt");
	open (OUT_E, ">", $output_prefix."E.txt");
	open (OUT_G, ">", $output_prefix."G.txt");
	open (OUT_H, ">", $output_prefix."H.txt");
	open (OUT_I, ">", $output_prefix."I.txt");
	open (OUT_J, ">", $output_prefix."J.txt");
	open (OUT_K, ">", $output_prefix."K.txt");
	open (OUT_L, ">", $output_prefix."L.txt");
	open (OUT_U, ">", $output_prefix."U.txt");

	while (my $line = <INPUT>) {
		chomp($line);
		my $original_line = $line;

		foreach ($line) { s/^\s+//; s/\s+$//; s/\s+/ /g; }
		my @items = split(' ', $line);

		my $time = $items[3];
		if ($time >= 6000) { # only take data after conformational eq
			
			my $numbins = 0;  # number of states a given data point falls into
			my $states  = ""; # states a given data point falls into
			
			my $RMSD    = $items[4];  # RMSD
			my $rg      = $items[5];  # Rg
			my $nc      = $items[11]; # Native contacts
			my $nnc     = $items[12]; # Non-native contacts
			
			# State A - Checked for correct boundaries
			$A_RMSD_min = 0.0; $A_RMSD_max = 3.0;
			# Extract State A
			if (($A_RMSD_min <= $RMSD) and ($RMSD < $A_RMSD_max)) {   
				print OUT_A "$original_line\n";
				$numbins++; 
				$states = $states."A-"; 
			}

			# State B - Checked
			$B_RMSD_min = 3.0;           $B_RMSD_max = 6.0;
			$B_NC_min   = 0.6 * $maxNC;  $B_NC_max   = $maxNC;
			# Extract State B
			if (($B_RMSD_min <= $RMSD) and ($RMSD < $B_RMSD_max) and
				($B_NC_min <= $nc)     and ($nc < $B_NC_max)) {   
				print OUT_B "$original_line\n";
				$numbins++;
				$states = $states."B-"; 
			}

			# State C - Checked
			$C_RMSD_min = 3.5;            $C_RMSD_max = 6.5;
			$C_NC_min   = 0.425 * $maxNC; $C_NC_max   = 0.6 * $maxNC;
			# Extract State C
			if (($C_RMSD_min <= $RMSD) and ($RMSD < $C_RMSD_max) and
				($C_NC_min <= $nc)     and ($nc < $C_NC_max)) {
				print OUT_C "$original_line\n";
				$numbins++;
				$states = $states."C-"; }

			# State E - Checked
			$E_RMSD_min = 6.5;            $E_RMSD_max = 10.0;
			$E_NC_min   = 0.3 * $maxNC;   $E_NC_max   = 0.5 * $maxNC;
			# Extract State E
			if (($E_RMSD_min <= $RMSD) and ($RMSD < $E_RMSD_max) and 
				($E_NC_min <= $nc)     and ($nc < $E_NC_max)) {
				print OUT_E "$original_line\n";
				$numbins++;
				$states = $states."E-"; 
			}

			# State G - Checked
			$G_RMSD_min = 10.0;           $G_RMSD_max = 24.0;
			$G_RG_min   = 12.5;           $G_RG_max   = $maxRg;
			$G_NC_min   = 0.175 * $maxNC; $G_NC_max   = 0.325 * $maxNC;
			# Extract State G
			if (($G_RMSD_min <= $RMSD) and ($RMSD < $G_RMSD_max) and
				($G_RG_min <= $rg)     and ($rg < $G_RG_max) and 
				($G_NC_min <= $nc)     and ($nc < $G_NC_max)) {
				print OUT_G "$original_line\n";  
				$numbins++; 
				$states = $states."G-"; 
			}

			# State H - Checked
			$H_RMSD_min = 6.5;           $H_RMSD_max = 10.0;
			$H_NC_min   = 0.10 * $maxNC; $H_NC_max   = 0.225 * $maxNC;
			# Extract State H
			if (($H_RMSD_min <= $RMSD) and ($RMSD < $H_RMSD_max) and
				($H_NC_min <= $nc)     and ($nc < $H_NC_max)) {   
				print OUT_H "$original_line\n";  
				$numbins++; 
				$states = $states."H-"; 
			}

			# State I - Checked
			$I_RMSD_min = 10.0;          $I_RMSD_max = 16.0;
			$I_NC_min   = 0.10 * $maxNC; $I_NC_max   = 0.175 * $maxNC;
			# Extract State I
			if (($I_RMSD_min <= $RMSD) and ($I_RMSD_max) and
				($I_NC_min <= $nc)     and ($I_NC_max)) {   
				print OUT_I "$original_line\n";  
				$numbins++; 
				$states = $states."I-"; 
			}

			# State J - Checked
			$J_RMSD_min = 7.5;            $J_RMSD_max = 27.5;
			$J_NC_min   = 0.025 * $maxNC; $J_NC_max   = 0.10 * $maxNC;
			$J_NNC_min  = 0.0;            $J_NNC_max  = 0.56 * $maxNNC;
			# Extract State J
			if (($J_RMSD_min <= $RMSD) and ($RMSD < $J_RMSD_max) and
				($J_NC_min <= $nc)     and ($nc < $J_NC_max) and
				($J_NNC_min <= $nnc)   and ($nnc < $J_NNC_max)) {   
				print OUT_J "$original_line\n";  
				$numbins++;  
				$states = $states."J-"; 
			}

			# State K
			$K_RMSD_min = 7.5;            $K_RMSD_max = 27.5;
			$K_NC_min   = 0.025 * $maxNC; $K_NC_max   = 0.10 * $maxNC;
			$K_NNC_min  = 0.56 * $maxNNC; $K_NNC_max  = $maxNNC;
			# Extract State K
			if (($K_RMSD_min <= $RMSD) and ($RMSD < $K_RMSD_max) and
				($K_NC_min <= $nc)     and ($nc < $K_NC_max) and
				($K_NNC_min <= $nnc)   and ($nnc < $K_NNC_max)) {   
				print OUT_K "$original_line\n";  
				$numbins++; 
				$states = $states."K-"; 
			}

			# State L
			$L_NC_min  = 0.0;  $L_NC_max  = 0.025 * $maxNC;
			$L_NNC_min = 0.55; $L_NNC_max = $maxNNC;
			# Extract State L
			if (($L_NC_min <= $nc)   and ($nc < $L_NC_max) and
				($L_NNC_min <= $nnc) and ($nnc < $L_NNC_max)) {
				print OUT_L "$original_line\n";  
				$numbins++; 
				$states = $states."L1-"; 
			}

			# State U
			$U_NC_min  = 0.0; $U_NC_max  = 0.025 * $maxNC;
			$U_NNC_min = 0.0; $U_NNC_max = 0.335 * $maxNNC;
			# Extract State U
			if (($U_NC_min <= $nc)   and ($nc < $U_NC_max) and
				($U_NNC_min <= $nnc) and ($nnc < $U_NNC_max)) {   
				print OUT_U "$original_line\n";  
				$numbins++; 
				$states = $states."L3-"; 
			}
		}

		if ($numbins > 1) { 
			print STDOUT "$original_line\tnumbins:$numbins\t$states\n";
		}
	} # end of reading file while loop

	close INPUT;
	close OUT_A;
	close OUT_B;
	close OUT_C;
	close OUT_E;
	close OUT_G;
	close OUT_H;
	close OUT_I;
	close OUT_J;
	close OUT_K;
	close OUT_L;
	close OUT_U;