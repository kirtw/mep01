dim3 ;SFISC/JFW,GFT,TOAD-FileMan: M Syntax Checker, Commands ;25MAR2010
 ;;22.2;VA FileMan;;Jan 05, 2016;Build 42
 ;;Per VA Directive 6402, this routine should not be modified.
 ;;Submitted to OSEHRA 5 January 2015 by the VISTA Expertise Network.
 ;;Based on Medsphere Systems Corporation's MSC FileMan 1051.
 ;;Licensed under the terms of the Apache License, Version 2.0.
 ;
 ; These DO modules
DG ; DO and GET (D^dim and G^dim)
 G GC^dim:ARG=""!ERR D PARS G ER:ERR
 S CL=":" D PARS1 G ER:ERR I CH=CL G ER:CA1="" S EX=CA1 D ^dim1
 I CA0["@^" S EX=CA0 D ^dim1 G DG
 I CA0["(",$E(CA0)'="@",$E($P(CA0,"^",2))'="@" D  G ER:ERR
 . I COM'="D" S ERR=1 Q
 . S EX=CA0
 . I EX'?.E1"(".E1")" S ERR=1 Q
 . S CH=$P(EX,"("),CH1=$P(CH,"^",2,999),II=$F(EX,"(")-1
 . I CH=""!(CH?.E1"^") S ERR=1 Q
 . I CH1]"",CH1'?1U.15AN,CH1'?1"%".15AN S ERR=1 Q
 . S CH=$P(CH,"^") I CH]"",CH'?1U.15AN,CH'?1"%".15AN,CH'?1.15N S ERR=1 Q
 . Q:$E(EX,II,II+1)="()"
 . S (STK(-1,2),STK(-1,3))=0,SP=1,STK(0,0)="P^",(STK(0,1),STK(0,2),STK(0,3))=0
 . D GG^dim1
 E  D LABEL(0)
 G DG
 ;
LABEL(OFFSET) ; labelref, entryref, and $TEXT argument (DG and TEXT^dim1)
 S CL="^" D PARS1 Q:ERR
 I CH=CL S:CA1=""!($E(CA1)="^") ERR=1 S EX=CA1 D VV,^dim1 Q:ERR
 S EX=CA0 D VV:EX'=+%&'OFFSET,^dim1 
 Q
 ;
KL ; KILL, LOCK, and NEW (K^dim and LK)
 D PARS G ER:ERR
 I CA0="",CH="," G ER
 I CA0?1"^"1UP.UN,COM'="L" G ER
 I CA0?1"(".E1")" D  G KL
 . S ARG("E")=$L(ARG)
 . S CA0=$E(CA0,2,$L(CA0)-1) S ARG=CA0_$S(ARG]"":","_ARG,1:"")
 S EX=CA0 I COM="L","+-"[$E(CA0) S $E(CA0)=""
 I COM="N",'$$LNAME(EX) G ER
 I COM="K",$D(ARG("E")),'$$LNAME(EX) G ER
 I $D(ARG("E")),$L(ARG)'>ARG("E") K ARG("E")
 D VV,^dim1 G GC^dim:ARG=""!ERR
 G KL
 ;
LK ; LOCK (L^dim)
 S CA0=ARG,CL=":" S:"+-"[$E(CA0) CA0=$E(CA0,2,999) D PARS1
 I CH=CL G ER:CA1="" S EX=CA1 D ^dim1
 S ARG=CA0 G GC^dim:CA0="",KL
 ;
HN ; HANG (H^dim)
 S EX=ARG D ^dim1 G GC^dim
 ;
OP ; OPEN and USE (O^dim and U^dim)
 G GC^dim:ARG=""!ERR D PARS G ER:ERR!(CH=","&(CA0=""))
 G US:COM="U" S CL=":" D PARS1 S CA2=CA0,CA0=CA1 S:CH=CL&(CA0="") ERR=1 D PARS1 G ER:ERR!(CH=CL&(CA1=""))
 F CL="CA1","CA2" S EX=@CL D ^dim1 G OP:ERR
 G OP
US S CL=":" D PARS1 G ER:CH=CL&(CA1="") S EX=CA0 D ^dim1
 S CA0=CA1 D PARS1 G ER:CH]"",OP
 ;
FR ; FOR (F^dim)
 S CL="=",CA0=ARG D PARS1 G ER:ERR!(CA1="")!(CA0="") S ARG=CA1
 S EX=CA0 G ER:CA0?1"^".E D VV,^dim1 G ER:ERR
FR1 G GC^dim:ARG=""!ERR D PARS
 S CL=":" F CA0=CA0,CA1 D PARS1 G ER:ERR!(CA0=""&(CH=CL)) S EX=CA0 D ^dim1
 I CA1]"" S EX=CA1 D ^dim1
 G FR1
 ;
PARS S (CA0,CH)="" Q:ERR  S (ERR,II)=0
INC D INC0 D QT:CH="""",PARAN:CH="(" Q:ERR  G OUT:","[CH,INC
QT D INC0 Q:CH=""""  G QT:CH]"" S ERR=1 Q
PARAN S PL=1 F JJ=0:0 D INC0 D QT:CH="""" S PL=PL+$S(CH="(":1,CH=")":-1,1:0) Q:'PL  I CH="" S ERR=1 Q
 Q
OUT S CA0=$E(ARG,1,II-1),ARG=$E(ARG,II+1,999) Q
INC0 S II=II+1,CH=$E(ARG,II) Q
 ;
PARS1 S (CA1,CH)="" Q:ERR  S (ERR,II)=0
INCR D INC1 D QT1:CH="""",PARAN1:CH="(" Q:ERR=1  G OUT1:CL[CH,INCR
OUT1 S CA1=$E(CA0,II+1,999),CA0=$E(CA0,1,II-1) Q
QT1 D INC1 Q:CH=""""  G QT1:CH]"" S ERR=1 Q
PARAN1 S PL=1 F JJ=0:0 D INC1 D QT1:CH="""" S PL=PL+$S(CH="(":1,CH=")":-1,1:0) Q:'PL  I CH="" S ERR=1 Q
 Q
INC1 S II=II+1,CH=$E(CA0,II) Q
 ;
VV ; variable, label, or routine name (LABEL, KL, and FR)
 I 'ERR,EX]"",EX'["@",EX'?1U.15UN,EX'?1U.15UN1"(".E1")",EX'?1"%".15UN1"(".E1")",EX'?1"%".15UN,EX'?1"^"1U.15UN1"(".E1")",EX'?1"^%".15UN1"(".E1")",EX'?1"^(".E1")",EX'?1"^"1U.15UN S ERR=1
 S:EX["?@" ERR=1 Q
 ;
LNAME(EX) ; lname (KL)
 I EX?1(1A,1"%").7UN Q 1
 I EX?1"@".E Q 1
 Q 0
 ;
ER G ER^dim

