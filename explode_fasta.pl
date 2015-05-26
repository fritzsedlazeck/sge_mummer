#!/usr/bin/perl -w
use strict;

#initialling variables:
my $fh = undef;
my $curseq = undef;
my $filename = join('',$ARGV[1],"/summary");
my $name=undef;

#open files:
open (my $summary, ">", $filename) || die "Could not open file '$filename: $!\n";

#Fasta file:
open(FILE1, $ARGV[0]) || die "Could not open file '$ARGV[0]: $!\n";



while (<FILE1>) #reads in line after line
{
  if (/>(\S+)/) #If fasta header:
  {
    $curseq = $1;
    print STDERR "Splitting $curseq\n";
    $name=join('',$ARGV[1],"/$curseq.fa");
    open $fh, ">",$name or die "Cant open $curseq.fa ($!)\n";

    print $fh ">$curseq\n"; #print heaer in new file
	
    print $summary "$name\n"; #adds the name of the file to the summary file
  }
  else #sequence:
  {
    print $fh $_;	
  }
}
