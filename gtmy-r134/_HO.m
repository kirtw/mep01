;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;								;
; Copyright (c) 1987-2019 Fidelity National Information		;
; Services, Inc. and/or its subsidiaries. All rights reserved.	;
;								;
; Copyright (c) 2020-2021 YottaDB LLC and/or its subsidiaries.	;
; All rights reserved.						;
;								;
;	This source code contains the intellectual property	;
;	of its copyright holder(s), and is made available	;
;	under a license.  If you do not know the terms of	;
;	the license, please stop and do not read further.	;
;								;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
%HO	;GT.M %HO utility - hexadecimal to octal conversion program
	;invoke at INT with %HO in hexadecimal to return %HO in octal
	;invoke at FUNC as an extrinsic function
	;if you make heavy use of this routine, consider $ZCALL
	;
	set %HO=$$FUNC(%HO)
	quit
INT	read !,"Hexadecimal: ",%HO set %HO=$$FUNC(%HO)
	quit
FUNC(h)
	quit:"-"=$extract(h) ""		; 0>h risks NUMOFLOW
	new e set e=$zextract(h,1,2) set:("0x"=e)!("0X"=e) h=$zextract(h,3,$zlength(h))
	new c,d,dg,l,o
	set l=$length(h)
	quit:(14<l) $$CONVERTBASE^%CONVBASEUTIL(h,16,8)
	set d=0,h=$translate(h,"abcdef","ABCDEF"),o=""
	for c=1:1:l set dg=$find("0123456789ABCDEF",$extract(h,c)) quit:'dg  set d=(d*16)+(dg-2)
	for  quit:'d  set o=d#8_o,d=d\8
	quit $select(0<o:o,1:0)
