;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;								;
; Copyright (c) 1987-2019 Fidelity National Information		;
; Services, Inc. and/or its subsidiaries. All rights reserved.	;
;								;
; Copyright (c) 2019-2020 YottaDB LLC and/or its subsidiaries.  ;
; All rights reserved.                                          ;
;								;
;	This source code contains the intellectual property	;
;	of its copyright holder(s), and is made available	;
;	under a license.  If you do not know the terms of	;
;	the license, please stop and do not read further.	;
;								;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
%DH	; GT.M %DH utility - decimal to hexadecimal conversion program
	; invoke with %DH in decimal and %DL digits to return %DH in hexadecimal
	; invoke at INT to execute interactively
	; invoke at FUNC as an extrinsic function
	; if you make heavy use of this routine, consider $ZCALL
	;
	set %DH=$$FUNC(%DH,$get(%DL,8))
	quit
INT	new %DL
	read !,"Decimal: ",%DH read !,"Digits:  ",%DL set:""=%DL %DL=8 set %DH=$$FUNC(%DH,%DL)
	q
FUNC(d,l)
	new maxp,maxn,isn,i,h,apnd,k,fval
	; Length by default is set to 8
	set l=$get(l,8)
	; max values are one greater than actual unsigned 64/32 bit values
	set isn=0,i=0,h="",apnd="0",k=d,maxp="18446744073709551616",maxn="9223372036854775809"
	; Input length without sign is considered for conversion in case of signed values
	set fval=$zextract(d,1)
	set:fval="-" isn=1,k=$extract(d,2,$length(d)),apnd="F"
	set:fval="+" k=$extract(d,2,$length(d))
	set fval=$zextract(k,1)
	set:fval="0" k=$$VALIDVAL(k) ; removing zero's if present
	; First condition: -ve Input greater than max -ve 64bit value is handled by $ZCONVERT()
	; Second condition: +ve Input less than max unsigned 64bit value is handled by $ZCONVERT()
	; other values are handled by M code.
	if ((isn&(($length(k)<19)!(($length(k)=19)&(maxn]k))))!('isn&(($length(k)<20)!(($length(k)=20)&(maxp]k))))) set h=$zconvert(d,"DEC","HEX") ; $ZCONVERT() handles signed input hence d is passed
	else  do
	. set h=$$CONVERTBASE^%CONVBASEUTIL(k,10,16)
	. set:(isn&("0"'=h)) h=$$CONVNEG^%CONVBASEUTIL(h,16)
	set i=$length(h)
	for  quit:i'<l  set h=apnd_h,i=i+1
	quit h
; This routine removes any leading zero's in the input
; Returns: value without the leading zeros if any
VALIDVAL(val)
	new i,inv,res ; inv is used to exit the following for on occurence of a valid decimal digit
	set i=1,inv=0,res=0
	for i=1:1:$zlength(val)  do  quit:inv=1
	. set res=$zextract(val,i)
	. set:res'=0 inv=1
	. quit:inv=1
	set:res'=0 res=$extract(val,i,$zlength(val))
	quit res
