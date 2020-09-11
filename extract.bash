#!/usr/bin/env bash
echo "USE ./extract_all.pl # updated 20200911. prev 20180718"
exit 1
set -e
trap 'e=$?; [ $e -ne 0 ] && echo "$0 exited in error"' EXIT

#
# extract bart task 
#
perl -Mopen=":std,IN,:encoding(utf-16LE)" -F: -salnE '$F[1] =~ s/[^A-Za-z0-9.]//g;$s=$F[1] if /^Subject/; $d=$F[1] if m/^SessionDate/;  $ntab=s/\t//g; $v{$ntab.$&}=$F[1] if /Numpumps|Value|Status/; print join("\t", $s,$d, @v{qw/3Numpumps 4Numpumps 3Value 3Status/}) if /Color/' /Volumes/L/bea_res/Tasks/NewEyeLab/MM\ Y3\ Behavioral/BART/BART_*.txt > bart.txt
