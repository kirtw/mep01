dim2 ;SFISC/XAK,GFT,TOAD-FileMan: M Syntax Checker, Exprs ; Jan 30, 2023@14:38:33
 ;;22.2;VA FileMan;**24**;Jan 05, 2016;Build 3
 ;;Per VA Directive 6402, this routine should not be modified.
 ;;Submitted to OSEHRA 5 January 2015 by the VISTA Expertise Network.
 ;;Based on Medsphere Systems Corporation's MSC FileMan 1051.
 ;;Licensed under the terms of the Apache License, Version 2.0.
 ;
 ;12277;4186487;4104;
 ;
SUB ; "(": open paren situations (GG^dim1)
 F JJ=II-1:-1 S C1=$E(EX,JJ) Q:C1'?1(1UN,1"%")
 S C1=$E(EX,JJ+1,II-1)
 I C1]"",C1'?1(1U,1"%").UN G ERR
 ;I C1]"",EX[("."_C1) G ERR ;DID NOT ALLOW "W A(6)-$$X(.A)"
 S STK(SP,0)=$S(C1]""!($E(EX,JJ)="^"):"V^",$E(EX,JJ)="@":"@^",1:"0^")
 S STK(SP,1)=0,STK(SP,2)=0,STK(SP,3)=0,SP=SP+1 G 1
 ;
UP ; ")": close paren situations (GG^dim1)
 I SP=0 G ERR
 I "(,"[$E(EX,II-1),$P($G(STK(SP-1,0)),"^")'["P" G ERR
 I $E(EX,II+1)]"","<>_[]:/\?'+-=!&#*),"""'[$E(EX,II+1) G ERR
 S SP=SP-1,STK(SP,1)=STK(SP,1)+1,%F=$P(STK(SP,0),"^") I %F D  G ERR:ERR
 . S %F=$P(STK(SP,0),"^",2),nFc=STK(SP,1)
 . I nFc<+%F S ERR=1 Q  ; not enough commas for this function
 . I nFc>$P(%F,";",2) S ERR=1 Q  ; too many commas for this function
 . I STK(SP,2),'STK(SP,3) S ERR=1 ; we're in $S and haven't yet hit a :
 KILL STK(SP+1)
 I '%F,%F'["V",%F'["@",%F'["P",STK(SP,1)>1 G ERR
 G 1
 ;
AR ; ",": comma situations -- "P" below means "parameters" (GG^dim1)
 I SP<1 G ERR
 I "(,"[$E(EX,II-1),$P($G(STK(SP-1,0)),"^")'["P" G ERR
 I 'STK(SP-1,3),STK(SP-1,2) G ERR
 I "@("[$E(EX,1,2) G ERR
 S STK(SP-1,1)=STK(SP-1,1)+1,STK(SP-1,3)=0 G 1
 ;
SEL ; ":": $SELECT delimiter (GG^dim1)
 S STK(SP-1,3)=STK(SP-1,3)+1 G ERR:'STK(SP-1,2)!(STK(SP-1,3)>1),1
 ;
GLO ; "^": global reference (GG^dim1)
 D INC G ERR:$E(EX,II,999)'?1U.UN.P.E&("STK("'[C)
 G ERR:"=+-\/<>(,#!&*':@[]_"'[$E(EX,II-2)
 S II=II-1 G 1
 ;
PAT ; "?": pattern match (GG^dim1)
 G ERR:II=1,1:$E(EX,II+1)="@" D INC,PATTERN G ERR:ERR S II=II-1 G 1
 ;
PATTERN F  D PATATOM Q:C'?1N&(C'=".")!ERR
 Q
PATATOM D REPCOUNT Q:ERR
 I C="""" D STRLIT,INC:'ERR Q
 I C="(" D ALTRN8 Q
 D PATCODE
 Q
REPCOUNT ;
 I C'?1N,C'="." S ERR=1 Q
 N FROM S FROM=+$E(EX,II,999) I C?1N D INTLIT Q:ERR
 I C="." D INC
 Q:C'?1N  I +$E(EX,II,999)<FROM S ERR=1 Q
 D INTLIT Q
INTLIT I C'?1N S ERR=1 Q
 F  D INC Q:C'?1N
 Q
STRLIT F  D INC Q:C=""  I C="""" Q:$E(EX,II+1)'=""""  S II=II+1
 I C="" S ERR=1
 Q
PATCODE I "ACELNPU"'[C!(C="") S ERR=1 Q
 F  D INC Q:C=""  Q:"ACELNPU"'[C
 Q
ALTRN8 I C'="(" S ERR=1 Q  ;alternate patterns (AE) are within a set of parentheses
 D INC,PATATOM Q:ERR
 I C="," F  Q:","'[C  D INC,PATATOM Q:ERR  ;AE elements that are seperated by comma
 F  Q:C=")"  D PATATOM Q:ERR  ;AE elements that are not seperated ;p24
 I C'=")" S ERR=1 Q
 D INC
 Q
 ;
BINOP ; binary operator (GG^dim1)
 S PL1=""")%'",PL2="""($+-^%@'." G OPCHK
 ;
MTHOP ; math or relational operator (GG^dim1)
 S PL1=""")%",PL2="""($+-^%@'." G OPCHK
 ;
UNOP ; unary operator (GG^dim1)
 S PL1=""":<>+-'\/()%@#&!*=_][,"
 S PL2="""($+-=&!^%.@'" I C="'" S PL2=PL2_"<>?[]"
 G OPCHK
 ;
IND ; "@": indirection (GG^dim1)
 I $E(COM)="F" G ERR
 S PL1="^?@(%+-=\/#*!&'_<>[]:,.",PL2="""(+^-'$@%" G OPCHK
 ;
OPCHK ; ensure that the characters before and after the operator are OK
 S Cpv=$E(EX,II-1),Cnx=$E(EX,II+1) I Cpv="'","[]&!<>="[C S Cpv=$E(EX,II-2)
 I Cpv="","+-'@"'[C G ERR ;              binary: require before
 I Cpv'?1UN,PL1'[Cpv G ERR ;              all: screen before
 F %F="*","]" I C=%F,Cnx=%F S II=II+1,Cnx=$E(EX,II+1) Q
 I Cnx="" G ERR ;                         all: require after
 I Cnx'?1UN,PL2'[Cnx G ERR ;              all: screen after
 I C="'","!&[]?=<>"'[Cnx,Cpv?1")"!(Cpv?1UN) G ERR ;GFT: unary "'" may precede an operator, can't follow a variable name
 G 1
 ;
1 ; common exit point for all of ^dim2
 G GG^dim1
 ;
DATA ; glvn arguments of $D,$G,$NA,$O, & $Q functions (FUNC^dim1)
 D INC G ERR:C="",ERR:C=")",DATA:"^@"[C D VAR
 G ERR:"@(,)"'[C!ERR,GG1^dim1
;*  : START II-ptr
VAR ; variables encountered while parsing exprs (DATA, GG^dim1)
 NEW START S START=II-1 I $E(EX,START)="^" S START=START-1
 I C="%" D INC
 N OUT S OUT=0 F JJ=II:1 S C=$E(EX,JJ) D  Q:OUT
 . I ",<>?/\[]+-=_()*&#!':"[C S OUT=1 Q
 . I C="@",$E(EX,JJ+1)="(",$E(EX,START)="@" S OUT=1 Q
 . I C'?1UN S ERR=1
 . I C="^",$D(STK(SP-1,"F")),STK(SP-1,"F")["TEXT" S ERR=0,OUT=1
 Q:ERR
 I C="@" S II=JJ Q
 S %F=$E(EX,II,JJ-1)
 I %F="^",$E(EX,JJ)'="(" S ERR=1
 I %F]"",%F'?1U.UN,$E(EX,II-1,JJ-1)'?1"%".UN S ERR=1
 S II=JJ 
 Q
 ;
INC S II=II+1,C=$E(EX,II)
 Q
 ;
ERR S ERR=1,SP=0
FINISH G ERR:SP'=0 KILL C,EX,%F,nFc,II,JJ,Cpv,Cnx,SP,%T,PL1,PL2,%FN,%FZ
Q Q
