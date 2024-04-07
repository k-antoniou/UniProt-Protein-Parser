#!/usr/bin/perl
open OUTPUT, ">protein_details.txt"; #open output file
$/="\/\/\n";
while(<>){
$seq_start=1;
if ($_=~/^ID\s{3}(.*?)\s+(.*?)\;\s+(\d+\sAA.)/m)
{
	print OUTPUT ">$1"; #write protein ID
}
if ($_=~/^AC\s{3}(.*?)\;/m)
{
	print OUTPUT "|$1";
}
while($_=~/^FT\s{3}TRANSMEM\s+(\d+)\s+(\d+)/mg){
	push(@tmstart,$1); #save start of tm
	push(@tmend,$2); #save start of tm
}
if ($_=~/^SQ   SEQUENCE\s+(.*?)\;/m)
{
	print OUTPUT "|$1\n"; #print sequence
}

while ($_=~/^\s{5}(.*)/mg){
	$sequence=$1;
	$sequence=~s/\s//g;
 
	print OUTPUT "$sequence\n"; #print the sequence
	for($i=$seq_start;$i<length($sequence)+$seq_start;$i++){
		if($i==1){
			@tmstart=reverse(@tmstart);
			@tmend=reverse(@tmend);
			$a=pop(@tmstart);
			$b=pop(@tmend);
		}
		if($i>=$a && $i<=$b){
			print OUTPUT "M"; #print if tm 
			if($i==$b){
				$a=pop(@tmstart);
				$b=pop(@tmend);
			}
		}else{
			print OUTPUT "-"; #print if not tm
		}
	}
	print OUTPUT "\n";
	$seq_start=$seq_start+length($sequence);
}

  print OUTPUT "//\n"; #print end of protein
}
close OUTPUT;
