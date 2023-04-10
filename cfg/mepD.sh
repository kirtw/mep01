#!/bin/bash          mepD.sh    in k*/ <mpj> /cfg/ 

#  parameters as $PWD base folder, then by devy-profile.sh
#   Assumes $PWD is base of ten8 or ten8a

kwsys="km3a"
kwmpj="umep"
cd /home/kw/$kwsys/$kwmpj    #  $PB

. cfg/devy-profile.sh   # : $ydb_routines, $ydb_gbldir  $ydb_dist

echo "Starting $PB   ^epa"

$ydb_dist/yottadb -R ^epaGoDev


mur   #  rundown after mumps/ydb exits

echo
