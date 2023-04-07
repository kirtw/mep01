#!/bin/bash
#
#   
kwmpj="umep"    #  running gmma itself as mpj vs utility, bash local only
kwsys="km3a"

#        Sub cfg
export SB="/home/kw/$kwsys"
export GB="$SB/gmsa"
export MB="$SB/gmma"
export PB="$SB/$kwmpj"

#export WGU=$$SB/wwgu       #  Specific html, usu *.*2.html  HGen files  SYS analysis (ewd, node, GTMY)
#export WG1U=$$SB/wmgu          #  Hand Crafted html files, TP  trials before HGen ^gu*

export ydb_gbldir="$PB/cfg/ydb-mumps.gld"

   src="$PB/cfg/devy-profile.sh"  #   in gmma/ cfg/

export ydb_dist="$PB/gtmy"   # gtmy-->  vs  mpj-local mumps-ydb-r134/  M mode, 

export ydb_chset="M"
   
#  No Comments after \eol !! #  nor ;  removed $PB/rMP1 ^ep* vs ^ep2* in rmep2/
export ydb_routines="$ydb_dist \
$PB/o( $PB/rcfg $PB/rmep2 $PB/rmep4 $PB/rmePT1 $PB/rsr $PB/rxmep1  \
       ) \
$PB/ou(\
       $GB/rdve1  \
       $GB/rzro3 $GB/rmgbFL3 $GB/rmGP3 \
       $GB/rmenu3 $GB/rTOI7  \
       $GB/rvv $GB/rhgen4b $GB/rdev3 \
       $GB/rd2c  \
       $GB/rddv3)"
#
#Simple start use ^ZWZ("umep",zroStart
export ydb_routines="$ydb_dist $PB/o($PB/rcfg) $PB/ou($PB/urzro3)"  
#
# mpj aliases 'exclusively' in .bash_aliases  now 

alias ydb=". $src;  $ydb_dist/yottadb -direct"

alias gde=". $src ;  $ydb_dist/yottadb -R GDE"   # vs rungde.sh Non interactive
alias mupip="cd $PB/g ; $ydb_dist/mupip "
alias mur="mupip rundown -f $PB/g/ydb-mumps.dat; ps -C mumps; ps -C yottadb"

# alias mbr=". $PB/cfg/mbr.sh    #  mumps browser KISS ^mbr, ^mw* rmbrz1/ "


#
