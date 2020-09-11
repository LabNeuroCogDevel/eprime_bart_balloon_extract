#!/usr/bin/env perl
use strict; use warnings; use feature qq/say/;

# 20191001WF - init
#     record script used to extract from eprime log
#  ntab = number of "\t" tab characters -- how deep the loop is
# 20200911WF - JF+AP  trial numbers (TrialCount) and RT
#   allRTs is nested column like 'pump#=RT,pump#=RT,...'
#   pump# is size of ballon
#   manual pumps might start at any level of influated (eg. pump# = 5, or pump# = 21)
#
# mirrored between /Volumes/Hera/Projects/BART_task
#                  /Volumes/L/bea_res/Data/Tasks/BART/Basic

my @header = qw/3TrialCount 3Numpumps 4Numpumps 3Value 3Status 3PumpCollect.RT 4PumpAgain.RT 3PumpDur allRTs/;
print join "\t", qw/lunaid vdate/, @header; print "\n";

for my $elog (glob "/Volumes/L/bea_res/Data/Tasks/BART/Basic/1*/2*/BART_*.txt"){
   open my $fh, "<:encoding(utf-16LE)", $elog;
   # initialize subject, date, and ntab to NA
   my ($s, $d, $ntab) = ("NA")x3;
   my %v;
   while($_=<$fh>){
      chomp;
      my @F = split/:/;
      # remove anything not alphanumeric if we have somethign in the split
      $F[1] =~ s/[^A-Za-z0-9.]//g if $#F>0;
      $s=$F[1] if /^Subject/;
      # from mmddyyyy to yyyymmdd
      $d="$3$1$2" if m/^SessionDate.*(\d{2})-?(\d{2})-?(\d{4})/;
      # count number of tabs -- indcates "loop" level in eprime
      $ntab=s/\t//g;
      # grab important bits
      $v{$ntab.$&}=$F[1] if /TrialCount|Numpumps|Value|Status|PumpDur|PumpCollect.RT|PumpAgain.RT/;
      $v{"allRTs"}.="$1=$F[1]," if(/Pump(\d+)RT/);
      # Color is logged at the end of a trial. use this as opportunity to print trial info 
      if(/Color/) {
         say join("\t", $s,$d, map {$_||"NA"} @v{@header});
         %v=(); # this was not present in oneliner -- clear all values when we see a color
                # 4Numpumps does not happen every trial
      }
   }
}

__END__
from one-liner:

perl -Mopen=":std,IN,:encoding(utf-16LE)" -F: -salnE '$F[1] =~ s/[^A-Za-z0-9.]//g;$s=$F[1] if /^Subject/; $d=$F[1] if m/^SessionDate/;  $ntab=s/\t//g; $v{$ntab.$&}=$F[1] if /Numpumps|Value|Status/; print join("\t", $s,$d, @v{qw/3Numpumps 4Numpumps 3Value 3Status/}) if /Color/' 

now run like:
./extract_all.pl | tee all_$(date +%F).txt

