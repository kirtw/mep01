dim4 ;SFISC/JFW,GFT,TOAD-FileMan: M Syntax Checker, Commands ;5/6/97  09:10
 ;;22.2;VA FileMan;;Jan 05, 2016;Build 42
 ;;Per VA Directive 6402, this routine should not be modified.
 ;;Submitted to OSEHRA 5 January 2015 by the VISTA Expertise Network.
 ;;Based on Medsphere Systems Corporation's MSC FileMan 1051.
 ;;Licensed under the terms of the Apache License, Version 2.0.
 ;
 ;12279;3292224;3060;
 ;
BK ; BREAK and QUIT (B^dim and Q^dim)
 I ARG]"" S EX=ARG D ^dim1 G ER:ERR
 G GC^dim
 ;
CL ; CLOSE (C^dim)
 G ER:ERR I ARG]"" F  D S S EX=CA0 D ^dim1 G:ARG=""!ERR GC^dim
 G GC^dim
 ;
IX ; IF and XECUTE (I^dim and X^dim)
 G GC^dim:ARG=""!ERR D S S CL=":" D S1 I C=CL S EX=CA1 D ^dim1 G ER:CA1=""!ERR
 S EX=CA0 D ^dim1 G IX
 ;
ST ; SET and MERGE (S^dim and M^dim)
 G GC^dim:ARG=""!ERR D S G ER:ERR!(CA0=""&(C=","))
 I CA0?1"@".E S EX=CA0 D ^dim1 G ST
 S CL="=" D S1 G ER:(CA0="")!(CA1="") S EX=CA1 G ER:COM="M"&'$$GLVN(EX) D ^dim1 G ER:ERR
 I CA0?1"(".E1")" S CA0=$E(CA0,2,$L(CA0)-1) G ER:COM="M",STM
 D VV G ST
 ;
STM ; SET (x,y)=... (ST)
 G ST:ERR!(CA0=""),ER:CA0?1",".E S CL="," D S1 G ER:ERR!(C=CL&(CA1=""))
 D VV S CA0=CA1 G STM
 ;
RD ; READ (R^dim)
 G GC^dim:ARG=""!ERR D S G ER:ERR!(C=","&(CA0=""))
 I "!#?"[$E(CA0,1) S II=0 D FRM G RD
 I CA0?1"""".E G ER:$P(CA0,"""",3)'="" S EX=CA0 D ^dim1 G RD
 I CA0?1"*".E S CA0=$E(CA0,2,999)
 I $E(CA0)="^","^TMP^XTMP^"'[$P(CA0,"(") G ER
 F CL=":","#" D  G ER:ERR
 . D S1 Q:ERR
 . I CA0="" S ERR=1 Q
 . I CA1="",C=CL S ERR=1 Q
 . S EX=CA1 D ^dim1
 D VV G ER:ERR,RD
 ;
WR ; WRITE (W^dim)
 G GC^dim:ARG=""!ERR D S G ER:ERR!(CA0=""&(C=","))
 I "!#?/"[$E(CA0) S II=0 D FRM G WR
 S:CA0?1"*".E CA0=$E(CA0,2,999) S EX=CA0 D ^dim1 G WR
 ;
FRM ; format (RD and WR)
 S II=II+1,C=$E(CA0,II) Q:C=""  G FRM:"!#"[C
 S EX=$E(CA0,II+1,999) I EX]"",C="?" D ^dim1 Q
 I C="/",COM="W" S:EX?1"?".E EX="A"_$E(EX,2,999) I EX?1AN.E D ^dim1 Q
 S ERR=1 Q
 ;
S ; split at first comma: end of first argument (*)
 S (CA0,C)="" Q:ERR  S (ERR,II)=0
INC D INC0 D QT:C="""",P:C="(" Q:ERR  G OUT:","[C,INC
QT D INC0 Q:C=""""  G QT:C]"" S ERR=1 Q
P S PL=1 F JJ=0:0 D INC0 D QT:C="""" S PL=PL+$S(C="(":1,C=")":-1,1:0) Q:'PL  I C="" S ERR=1 Q
 Q
OUT S CA0=$E(ARG,1,II-1),ARG=$E(ARG,II+1,999) Q
INC0 S II=II+1,C=$E(ARG,II) Q
 ;
S1 ; split at first instance of CL (*)
 S (CA1,C)="" Q:ERR  S (ERR,II)=0
INCR D INC1 D QT1:C="""",P1:C="(" Q:ERR  G OUT1:CL[C,INCR
OUT1 S CA1=$E(CA0,II+1,999),CA0=$E(CA0,1,II-1) Q
QT1 D INC1 Q:C=""""  G QT1:C]"" S ERR=1 Q
P1 S PL=1 F JJ=0:0 D INC1 D QT1:C="""" S PL=PL+$S(C="(":1,C=")":-1,1:0) Q:'PL  I C="" S ERR=1 Q
 Q
INC1 S II=II+1,C=$E(CA0,II) Q
 ;
VV ; glvn or setleft (ST, STM, and RD)
 S EX=CA0 Q:ERR
 I EX]"",$$GLVN(EX)=0 D
 .I EX,COM'="S" S ERR=1 Q  ; ???
 .I EX["(",(EX?1"$P".E)!(EX?1"$E".E) Q
 .I EX="$X"!(EX="$Y") Q
 .I EX="$D"!(EX="$DEVICE")!(EX="$K")!(EX="$KEY")!(EX="$EC")!(EX="$ECODE")!(EX="$ET")!(EX="$ETRAP") S ERR=1 Q  ; SAC
 .S ERR=1
 D ^dim1:'ERR Q
 ;
GLVN(EX) ; glvn (not counting subscript syntax)
 I EX?.1"^"1U.UN Q 1
 I EX?.1"^"1U.UN1"("1.E1")" Q 1
 I EX?.1"^"1"EX".UN Q 1
 I EX?.1"^"1"EX".UN1"("1.E1")" Q 1
 I EX?1"^("1.E1")" Q 1
 I EX?1"^$"1.U1"("1.E1")" Q 1
 I EX?1"@"1.E Q 1
 Q 0
 ;
ER G ER^dim
