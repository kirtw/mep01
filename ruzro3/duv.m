duv(dvM,VVL)  ;CKW/ESC i4feb23 gmsa/ rzro3/ ;20230204-10; ^dz* Utility variant of ^dv Debug
;  new: bug^duv(M,VL)
  ;
  ;
  ; Works from, @VL,  *VL* lists
  ;
  S %zshc=2
  NEW %KMO,%c
d2  I $G(dvM)="" S dvM="Err NOS ^duv" S:$G(VVL)="" VVL="id"
  S %KMO=0 I dvM["KILL" S %KMO=1
  I $G(VVL)="" S VVL="@VL"
  zsh "s":%ZSH
    S %c=$G(%ZSH("S",%zshc)) I %c="" S %c="caller"
  ;* VVL, dvM, $IO ?
A NEW d,%i1,%i2,%VL,%n S d=$IO W:$X ! W "** Debug ",%c,":  ",dvM,!
  I $E(VVL)="@" S x=$P(VVL,"@",2),VVL=@x B  ;
  F %i1=1:1:$L(VVL,",") S %VL=$P(VVL,",",%i1) DO  
  .I %VL'["VL" S %vn=%VL D WV Q  ;just one var
  .W:$X !," ** " W %VL,"=" Q:$D(@%VL)=0  S %VL=@%VL W %VL,!  KILL:%KMO @%VL
  .F %i2=1:1:$L(%VL,",") S %vn=$P(%VL,",",%i2) D WV
  ;KILL VVL  if %KMO
Q  Q
;*  1aug17
bug(dvM,VVL) I $G(dvM)="" S dvM="Bug! NOS"
   I $G(VVL)="" S VVL="dvM"
   D ^dvstk
   G b2  ;simulate d b^dv wihtout extra stack layer
   Q
;*
;  ^dv output to log file  devdvlog
log(dvM,VVL) S dBdv=$IO I $G(devdvlog)="" D Ilog
   I $G(devdvlog)="" U 0 BREAK  Q  ;Bug ?
   U devdvlog S %zshc=3
   D d2
   U dBdv
   Q
;* Open devdvlog
Ilog  S devdvlog="dvlog.txt" OPEN devdvlog:(newversion)
   U devdvlog W !,"Default ^duv log file ???  ",$ZD($H),!! D ^dvstk W !!!
   Q
;*
  ;Entry  b^duv  Save $I, USE 0 zsh ? Break
b(dvM,VVL) 
b2  NEW dBdv,%zshc,%3,%D,%KMO,%S,%i,%n,%v,%vn,%vv
    S dBdv=$IO USE 0 S %zshc=3 D d2 ;D ^duv($G(dvM),$G(VVL))
    B
    U dBdv
    Q
    ;*  zsh  & Break (Use 0)   vs ^dvstk
zshb(dvM,VVL) NEW dBdv,%zshc
    S dBdv=$IO USE 0 S %zshc=3 D d2 ;D ^duv($G(dvM),$G(VVL))
    W:$X ! W "ZSH:-",! zsh  W !
    B  U dBdv Q
    Q
;*  Generc error  D be^dv
;RefBy: none locally  See G d2 ... SIC --- ?external entry, yes lots,~35 old
;  See cd ~/km7r;  grep -n "err\^duv" */r*/*.m  ; ...
err(dvM,VL) I $G(dvM)="" ;  call with or without ()
     S VL=$G(VL)
     S dvM="Error NOS",VVL="" G d2
;*
  ; %vn, @%vn,  $D(@vn)
WV S %vn=$P(%vn,"_") W:$X ! S %D=$D(@%vn) I %D>9 D WA Q:%D#2=0
  S %v=$G(@%vn) I %v="" S %v="null" S:$D(@%vn)#2=0 %v="UNDEF." W %vn,"=",%v,! G WQ
  I +%v=%v W %vn,"=",%v,! G WQ
  I %v W %vn,"=",%v," (",+%v,") ",! G WQ
  I $L(%v)>50 W "var ",%vn," (L=",$L(%v),") '",$E(%v,1,50),"...",! G WQ
  W %vn,"='",%v,"' ",! 
WQ KILL:%KMO @%vn Q
  ;*
  ;  %vn array;  Count nodes
WA  ;
  S %S="",%n=0 F %3=0:1 S %S=$O(@%vn@(%S)) Q:%S=""  I $D(@%vn@(%S))>9 S %n=%n+1
  W:$X ! W "Array ",%vn," has ",%3," nodes" I %n W " and ",%n," with SubNodes",!
  KILL:%KMO @%vn
  Q
  ;*
	;* * *   No internal Refs
ZBY	NEW Z2,me,stk,i,CA
	zsh "S":Z2  S me="^"_$T(+0),BY="? "_me
	S stk="" F i=0:1 S stk=$O(Z2("S",stk)) Q:stk=""  S CA=Z2("S",stk) I CA'[me S BY=CA Q
	Q
	; * * *
;*  Summarize and KILL (if %KMO) Arrays - EntryPoint
ka  S %KMO=1 G aa	;List One line and Kill Arrays     D ka^duv
la  S %KMO=0		;Just list			   D la^duv
aa  W:$X ! W "** Arrays-",! 
    S %vv="%" F %i=0:1 S %vv=$O(@%vv) Q:%vv=""  DO  ;  Find Arrays midst all vars
    .I $D(@%vv)>9 S %vn=%vv D WA Q
    Q
;*
;*   Sans Arrays, except one line, excludes %* vars
zwr   S %v0="%zzzzz" F %=0:1 S %v0=$O(@%v0) Q:%v0=""  DO
	.S %vn=%v0
	.I $D(@%v0)>2 D:$D(@%v0)#2 wv D zar Q
	.D wv
	W:$X ! W " That's All Folks (",$G(%)," vars)  !",!!
	Q
wv	S %v=$G(@%vn)
	W:$X ! W %vn,"=",?10
	I %v="" W "null.",! Q
	I +%v=%v W %v,! Q
	I $L(%v)+$X>80 DO  Q
	.W "'" S %x=80-$X,%L=$L(%v) W $E(%v,1,%x),! S %x=%x+1	;long string
	.W ?10,"... ($L=",%L,") " F  DO  S %x=%x2+1 Q:%x>%L  W ?9,"..."
	..W ?9," ..." S %x2=80-$X+%x W $E(%v,%x,%x2),! 
	W " '",%v,"' ",!
	Q
	;* array @%vn
zar	S %S="",%n=0 F %3=0:1 S %S=$O(@%vn@(%S)) Q:%S=""  I $D(@%vn@(%S))>9 S %n=%n+1
	W:$X ! W "Array ",%vn," has ",%3," nodes" I %n W " with ",%n," SubNodes",!
	Q
; * * *  29Oct15
wh(VWL)  D stb   W:$X !
	F %i=1:1:$L(VWL,",") S %vn=$P($P(VWL,",",%i),":") W ?%tb(%i),%vn," "
	W !
	Q
;*
w(VWL)  I $G(VWL)="" B  Q
	D stb
	W:$X !
	F %i=1:1:$L(VWL,",") S %vn=$P($P(VWL,",",%i),":") W ?%tb(%i),$G(@%vn)," "
	W !
	Q
stb	KILL %tb S %tb=2 F %i=1:1:$L(VWL,",") DO  ;
	  .S %nw=$P(VWL,",",%i),%w=$P(%nw,":",2),%vn=$P(%nw,":")
	  .I $L(%vn)+1>%w S %w=$L(%vn)+1  ; min width for label
	  .I '%w S %w=10 B
	  .S %tb(%i)=%tb,%tb=%tb+%w
	S %tb(%i+1)=%tb
	Q

  
