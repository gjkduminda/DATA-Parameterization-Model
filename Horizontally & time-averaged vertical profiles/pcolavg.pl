#!/usr/bin/perl --

%cols = ( 
   "tmean", "2",
   "tmin", "3",
   "tmax", "4", 
   "vrms", "5",
   "vmin", "6",
   "vmax", "7",
   "rmfmean", "8",
   "rmfmin", "9",
   "rmfmax", "10",
   "vhrms", "11",
   "vhmin", "12",
   "vhmax", "13",
   "etamean", "14",
   "etamin", "15",
   "etamax", "16", 
   "emean", "17",
   "emin", "18",
   "emax", "19", 
   "smean", "20",
   "smin", "21",
   "smax", "22", 
   "hvortrms", "23",
   "hvortmin", "24",
   "hvortmax", "25",
   "vvortrms", "26",
   "vvortmin", "27",
   "vvortmax", "28",
   "divrms", "29",
   "divmin", "30",
   "divmax", "31",
   "adv", "32",
   "diff", "33",
   "intheat", "34", 
   "vdiss", "35",
   "adheat", "36",
   "cmean", "37",
   "cmin", "38",
   "cmax", "39" );
@fields = ( "1" );
%sums = ( );
@args = @ARGV;
$nstart = -1;
$nend = 99999999;
$nstep = 1;
$timeval = 0;
while ($#ARGV>=0) {
    if ($ARGV[0]!~/\d/) { 
	push @fields, ( $cols{$ARGV[0]} ); 
    } elsif ($ARGV[0]=~/\d*\.\d*/) {
	$timeval=1;
	if ($nstart == -1) {
	    $nstart = $ARGV[0];
	} elsif ($nend == 99999999) {
	    $nend = $ARGV[0];
	} else {
	    $nstep = $ARGV[0];
	}
    } else {
	if ($nstart == -1) { 	    $nstart = $ARGV[0]; 
	} elsif ($nend == 99999999) {
	    $nend = $ARGV[0];
	} else {
	    $nstep = $ARGV[0];
        }
    }
    shift;
}
$on = 0;
$first = 1;
$num = 0;
while (<>) {
    if ($_=~/[*]+step\:\s*(\d+)\s*;\stime\s=\s+([\d\.\+\-EeDd]*)/) {
	$v = ($timeval) ? $2 : $1;
	if ($first&&$on) {$first=0};
	if ($v>=$nstart&&$v<=$nend&&(!(($v-$nstart)%$nstep))) { $on = 1; $num++;} else { $on = 0; }
    } else {
	if ($on) {
	    @line = split (" ", $_);
	    if ($first) { push (@z, $line[0]);}
	    foreach $f ( @fields ) {
		if ($f!=1) {
		  if ($first) {
		     $sums{$line[0]}{$f} = $line[$f-1];
		  } else {
		     $sums{$line[0]}{$f} += $line[$f-1];
		  }
	        }
	    }
	}
    }
}
foreach $zlev ( @z ) {
   print $zlev." ";
   foreach $f ( @fields ) {
	if ($f!=1) {print $sums{$zlev}{$f}/(1.0*$num)." ";}
   }
   print "\n";
}
exit(1);
