;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;								;
; Copyright (c) 1991-2019 Fidelity National Information		;
; Services, Inc. and/or its subsidiaries. All rights reserved.	;
;								;
;	This source code contains the intellectual property	;
;	of its copyright holder(s), and is made available	;
;	under a license.  If you do not know the terms of	;
;	the license, please stop and do not read further.	;
;								;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
%GI	;Load globals into database
	;Possible enhancements:
	;selection and/or exclusion by key list, range and/or wildcard
	;optional confirmation by global name
	;callable entry point
	;
	new c,chset,d,dos,fmt,g,i,n,q,sav,saveread,x,y,%ZD
	set d("io")=$io
	use $principal
	write !,"Global Input Utility",!
	set $zstatus=""
	if '$data(%zdebug) new $etrap set $etrap="zgoto "_$zlevel_":err^"_$text(+0) do
	. zshow "d":d										; save original $p settings
	. set x=$piece($piece(d("D",1),"CTRA=",2)," ")
	. set:""=x x=""""""
	. set d("use")="$principal:(ctrap="_x
	. set x=$piece(d("D",1),"EXCE=",2),x=$zwrite($extract(x,2,$length(x)-1))
	. set:""=x x=""""""
	. set d("use")=d("use")_":exception="_x_":"_$select($find(d("D",1),"NOCENE"):"nocenable",1:"cenable")_")"
	. use $principal:(ctrap=$char(3,4):exception="halt:$zeof!($zstatus[""TERMWRITE"")  "_$etrap:nocenable)
	for  do  quit:$length(%ZD)
	. read !,"Input device: <terminal>: ",%ZD
	. if '$length(%ZD) set %ZD=$principal quit
	. quit:"^"=%ZD
	. if "?"=%ZD do  quit
	 . . write !!,"Select the device you want for input"
	 . . write !,"If you wish to exit enter a caret (^)",!
	 . . set %ZD=""
	. if $zparse(%ZD)="" write "  no such device" set %ZD="" quit
	. open:$principal'=%ZD %ZD:(readonly:rewind:stream:recordsize=2044:ichset="M":exception="goto noopen"):0
	. if '$test  write !,%ZD," is not available" set %ZD=""
	. quit
noopen	. write !,$piece($ZS,",",2,999),!
	. close %ZD
	. set ($zstatus,%ZD)=""
	if "^"=%ZD do err quit
	write !!
	set sav="",(g,n)=0
	if $principal'=%ZD use %ZD:(exception="zgoto "_$zlevel_":eof":ctrap=$C(3,4)) do  quit:"^"=x
	. read x,y
	. use $principal
	. set dos=($zchar(13)=$extract(x,$length(x)))					; the label selects dos/not for entire file
	. set:dos x=$extract(x,1,$length(x)-1),y=$extract(y,1,$length(y)-1)
	. write !,x,!,y,!
	. set chset=$select(x["UTF-8":"UTF-8",1:"M")
	. if $zchset'=chset write "Extract CHSET ",chset," doesn't match current $ZCHSET ",$zchset,!
	. read !,"OK <Yes>? ",x,!!
	. if "^"=x do err quit
	. if $length(x),$extract("NO",1,$length(x))=$translate(x,"no","NO") set x="^" do err quit
	. set fmt=$get(y)["ZWR"
	else  do  if "^"=x do err quit							; if input is $p, no label
	. set chset=$zchset,dos=0,fmt=1
	. read !,"Format <ZWR>? ",x,!!
	. quit:"^"=x
	. if $length(x) set x=$translate($zconvert(x,"U"),"L") if $extract("GO",1,$length(x))=x set fmt=0 quit
	set x=$$read
	if 'fmt do
	. if x?1"^"1(1"%",1A).30AN.1(1"("1.E1")")1"=".E set fmt=1 quit			; looks like ZWR
	. set y=$$read
	. do  for  set x=$$read,y=$$read if "*"'[$extract(x) do			; GLO
	. . quit:(""=x)&(""=y)
	. . set @x=y
	. . set n=n+1,x=$piece(x,"(")
	. . if x'=sav,x'="^" do
	. . . set g=g+1,sav=x
	. . . if $principal'=%ZD use $principal write:$x>70 ! write x,?$x\10+1*10
	if (fmt) do  for  set x=$$read do						; ZWR
	. quit:""=x
	. set (i,q)=1,y=""								; find first equal-sign not in quotes
	. for  set c=i,i=$find(x,"=",i) do:$extract(x,c,i-2)[""""  quit:q
	. . for c=c:1:i-2 set:""""=$extract(c) q='q
	. set y=$extract(x,1,i-2)
	. if 8193>$zlength(x) set @x
	. else  set:8192<$length(y) y=$zwrite(y,1) set @y=$zwrite($extract(x,i,$length(x)),1)
	. set n=n+1,x=$piece(y,"(")
	. if x'=sav,"^"'=x do
	. . set g=g+1,sav=x
	. . if $principal'=%ZD use $principal write:$x>70 ! write x,?$x\10+1*10
eof	;
err	set $ecode=""
	if $data(%ZD),%ZD'=$principal close %ZD
	use:$data(d("use")) @d("use")
	use:$data(d("io")) d("io")
	if ""'=$zstatus,($zstatus'["CTRAP")&($zstatus'["IOEOF") write !,"ERROR: ",$zstatus
	quit:'$get(n)
	write !!,"Restored ",n," node",$select(n=1:"",1:"s")
	write " in ",g," global",$select(g=1:".",1:"s.")
	quit
read()	; concatenate reads that fill the buffer; also centralize the USE and dos <LF> stripping
	new i,e,x
	use %ZD
	set e=0,x=$get(saveread),i=1+(""'=x),saveread=""
	for i=i:1 do  quit:e
	. if $principal=$io read "> ",x(i),!
	. else  read x(i)
	. if $zeof,$increment(e) quit
	. if ""=x(i),$increment(e) quit
	. if 0=i#2,$increment(e) set saveread=x(i) quit
	. set x=x_x(i)
	. if 2044'=$zlength(x(i)),$increment(e) quit
	set:dos x=$extract(x,1,$length(x)-1)
	quit x
