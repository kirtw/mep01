;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;								;
; Copyright (c) 1985-2019 Fidelity National Information		;
; Services, Inc. and/or its subsidiaries. All rights reserved.	;
;								;
;	This source code contains the intellectual property	;
;	of its copyright holder(s), and is made available	;
;	under a license.  If you do not know the terms of	;
;	the license, please stop and do not read further.	;
;								;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
%RI	;Converts mumps routines from a standard routine output (RO)
	;file to individual *.m files.
	;possible enhancements:
	;selection and/or exclusion by list, range and/or wildcard
	;optional confirmation by routine name
	;callable entry point
	;
	new d,dir,dos,ff,io,l,r,x,y,z,%ZD
	set d("io")=$io
	use $principal
	write !,"Routine Input Utility - Converts RO file to *.m files.",!
	set $zstatus=""
	if '$data(%zdebug) new $etrap set $etrap="zgoto "_$zlevel_":ERR^"_$text(+0) do
	. zshow "d":d										; save original $p settings
	. set x=$piece($piece(d("D",1),"CTRA=",2)," ")
	. set:""=x x=""""""
	. set d("use")="$principal:(ctrap="_x
	. set x=$piece(d("D",1),"EXCE=",2),x=$zwrite($extract(x,2,$length(x)-1))
	. set:""=x x=""""""
	. set d("use")=d("use")_":exception="_x_":"_$select($find(d("D",1),"NOCENE"):"nocenable",1:"cenable")_")"
	. use $principal:(ctrap=$char(3,4):exception="halt:$zeof!($zstatus[""TERMWRITE"")  "_$etrap:nocenable)
	set dos=0									; the label selects dos/not for entire file
	read !,"Formfeed delimited <No>? ",x
	set ff=$select("Y"=$translate($extract(x),"y","Y"):$zchar(13,12),1:"")
	for  do  quit:$length(%ZD)
	. read !,"Input device: <terminal>: ",%ZD,!
	. if '$length(%ZD) set %ZD=$principal quit
	. quit:"^"=%ZD
	. if "?"=%ZD do  quit
	 . . write !!,"Select the device you want for input"
	 . . write !,"If you wish to exit enter a carat (^)",!
	 . . set %ZD=""
	. if ""=$zparse(%ZD) write "  no such device" set %ZD="" quit
	. open:$principal'=%ZD %ZD:(readonly:rewind:recordsize=2**20:ichset="M":exception="goto noopen"):0
	. if '$test  write !,%ZD," is not available" set %ZD="" quit
	. quit
noopen	. write !,$piece($zstatus,",",2,999),! close %ZD set %ZD=""
	if "^"=%ZD do ERR quit
	use:$principal'=%ZD %ZD:(width=2**20:exception="zgoto "_$zlevel_":eof":ctrap=$C(3,4))
	if $principal'=%ZD read x,y set dos=($zchar(13)=$extract(x,$length(x))) do:dos  use $principal write !,x,!,y,!!
	. set x=$extract(x,1,$length(x)-1),y=$extract(y,1,$length(y)-1)
	read !,"Output directory : ",dir,!!
	if "^"=dir close:$principal'=%ZD %ZD use:$data(d("use")) @d("use") use:$data(d("io")) d("io") quit	; restore devices
	if ""'=dir set:"/"'=$extract(dir,$length(dir)) dir=dir_"/"
	set (l,r)=0
	for  use %ZD write:$principal=%ZD !,"Routine: " read x do   if $principal=%ZD,""=x quit
	. set:$zchar(13)=$extract(x,$length(x)) x=$extract(x,1,$length(x)-1)
	. quit:""=x
	. set x=$piece(x,"^")
	. quit:(""=x)!'(($extract(x)?1a)!($extract(x)="%"))!($extract(x,2,99)'?.an)
	. if $principal=%ZD write !,"Enter routine "
	. else  use $principal write:$x>70 ! write x,?$x\10+1*10
	. set x=dir_$translate($extract(x),"%","_")_$extract(x,2,9999)_".m",r=r+1		;convert % to _
	. open x:(newversion:noreadonly:recordsize=2**20)
	. for  use %ZD write:$principal=%ZD ! read y do:dos  quit:y=ff  set l=l+1 use x write $select(""=y:" ",1:y),!
	.. set:$zchar(13)=$extract(y,$length(y)) y=$extract(y,1,$length(y)-1)
	. close x
eof	close:$length(x) x
	close:%ZD'=$principal %ZD
	use:$data(d("use")) @d("use")
	use:$data(d("io")) d("io")
	if ""'=$zstatus,($zstatus'["CTRAP")&($zstatus'["IOEOF") write !,"ERROR: ",$zstatus
	write !!!,"Restored ",l," line",$select(l=1:"",1:"s")
	write " in ",r," routine",$select(r=1:".",1:"s.")
	quit
	;
ERR	if ""'=$zstatus,($zstatus'["CTRAP")&($zstatus'["IOEOF") write !,"ERROR: ",$zstatus
	if $data(%ZD),%ZD'=$principal close %ZD
	use:$data(d("use")) @d("use")
	use:$data(d("io")) d("io")
	set $ecode=""
	quit
