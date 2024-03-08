dim1 ;SFISC/JFW,GFT,TOAD - M Syntax Checker, Exprs ; Dec 13, 2009
 ;;22.2;VA FileMan;**18**;Jan 05, 2016;Build 2
 ;;Per VA Directive 6402, this routine should not be modified.
 ;;Submitted to OSEHRA 5 January 2015 by the VISTA Expertise Network.
 ;;Based on Medsphere Systems Corporation's MSC FileMan 1051.
 ;;Licensed under the terms of the Apache License, Version 2.0.
 ;
 Q:ERR  NEW AI,AI1 S (II,SP,ERR,STK(-1,2),STK(-1,3))=0
 ;
 ;; %->EX is input expr
GG ; expr, expratom, expritem, subscript, parameter (called everywhere)
 D INC G:C="" FINISH^dim2
 G E:C=";"!($A(C)>95)!($A(C)<33) ; Already screened at start ? X?.ANP
 G QUOTE:C="""",FUNC:C="$",SUB^dim2:C="(",UP^dim2:C=")"
 G AR^dim2:C=",",SEL^dim2:C=":",GLO^dim2:C="^"
; exponential
EXP I C="E",$E(EX,II-1)?1N DO  G E:ERR S II=II-1 G GG
 . S %L1=$E(EX,II+1)
 . I %L1'?1(1N,1"+",1"-") S ERR=1 Q
 . NEW %OUT S %OUT=0 F II=II+2:1 D  Q:ERR!%OUT
 . . S C=$E(EX,II)
 . . I "<>=!&'[]+-*/\#_?,:)"[C S %OUT=1 Q
 . . I C'?1N S ERR=1 Q
 I C?1a!(C="%") D VAR^dim2
 G E:ERR,GG:C=""
 G PAT^dim2:C="?",BINOP^dim2:"=[]<>&!"[C,MTHOP^dim2:"/\*#_"[C
 G UNOP^dim2:"'+-"[C,IND^dim2:C="@"
PERIOD I C="." D  G E:ERR
 . I $P($G(STK(SP-1,0)),"^")="P" D  Q
 . . NEW C S C=$E(EX,II+1) I C?1N Q  ; decimal pass by value
 . . I C'="@",C'?1U,C'="%" S ERR=1 ; bad pass by reference
 . D INC NEW %L1,PL S %L1=$E(EX,II-2),PL="':=+-\/<>[](,*&!_#"
 . I %L1?1N,C?1N Q  ; 4.2
 . I PL[%L1,C?1N Q  ; +.2
 . S ERR=1 ; illegal period
 I C?1N,$E(EX,II+1)]"" G E:$E(EX,II+1)'?1(1NP,1"E")
GG1 ;
 I C]"","$(),:"""[C S II=II-1
 G GG
 ;
QUOTE ; strlit (GG)
 F %J=0:0 D INC Q:C=""!(C="""")
 G E:C=""!("[]()><\/+-=&!_#*,;:'"""'[$E(EX,II+1)) D:$D(STK(SP-1,"F")) FN:STK(SP-1,"F")["FN" G E:ERR,GG
 ;
FUNC ; intrinsics & extrinsics, mainly intrinsic functions (GG)
 D INC G EXT:C="$",E:C'?1A,SPV:$E(EX,II,999)'?.A1"(".E,FUNC1:C="Z"!($E(EX,II+1)="(")
 S %T=$E(EX,II,$F(EX,"(",II)-2)  ;
 I %T="ST"!(%T="STACK") G E ; SAC
 F FNP="FNUMBER^2;3","TRANSLATE^2;3","NAME^1;2","QLENGTH^1;1","QSUBSCRIPT^2;2","REVERSE^1;1" G FUNC2:$E(FNP,1,2)=%T,FUNC2:$P(FNP,"^")=%T
FNC ;;,ASCII^1;2,CHAR^1;999,DATA^1;1,EXTRACT^1;3,FIND^2;3,GET^1;2,JUSTIFY^2;3,LENGTH^1;2,ORDER^1;2,PIECE^2;4,QUERY^1;1,RANDOM^1;1,SELECT^1;999,TEXT^1;1,VIEW^1;999,ZFUNC^1;999
 G E:$T(FNC)'[(","_%T_"^")
FUNC1 S FNP=$P($T(FNC),",",$F("ACDEFGJLOPQRSTVZ",C)) G E:FNP=""  ; $Z* Functions
FUNC2 S II=$F(EX,"(",II)-1,STK(SP,0)="1^"_$P(FNP,"^",2),STK(SP,1)=0,STK(SP,2)=0,STK(SP,3)=0,STK(SP,"F")=FNP,SP=SP+1 S:$E(FNP)="S" STK(SP-1,2)=1
 I ",DATA,NAME,ORDER,QUERY,GET,"[(","_$P(FNP,"^")_",") G DATA^dim2
 I $E(FNP)="T",$E(FNP,2)'="R" D  I ERR G ERR^dim2
 . S AI=II,II=$F(EX,")",AI)-1,SP=SP-1,AI=$P($E(EX,AI,II-1),"(",2,99)
 . I AI?1"+"1N.E S AI=$E(AI,2,999)
 . NEW EX,II,SP S EX=AI D LABEL^dim3(1)
 G GG
 ;*
IFNC  KILL Fna S X=$T(FNC),X=$TR(X,"^",";")
       F pi=2:1:$L(X,",") S P=$P(X,",",pi),Na=$P(P,";"),Fn1=$P(P,";",2),Fn2=$P(P,";",3) DO  ;
         .S Fna(Na)=Fn1_","_Fn2
         .S Nalc=$$LC^dvc(Na)
         .S Fna(Nalc)=Fn1_","_Fn2
       Q
 ;
SPV ; intrinsic special variables (FUNC)
 I $E(EX,II+1)?1U S II=II+1,C=C_$E(EX,II) G SPV
 I ",D,EC,ES,ET,K,P,Q,ST,SY,TL,TR,"[(","_C_",") G E ; SAC
 I "HIJSTXYZ"[C&(C?1U)!(C?1"Z".U) G GG
 I "[],)><=_&#!'+-*\/?"'[$E(EX,II+1) G E
 I ",DEVICE,ECODE,ESTACK,ETRAP,KEY,PRINCIPAL,QUIT,STACK,SYSTEM,TLEVEL,TRESTART,"[(","_C_",") G E ; SAC
 I ",HOROLOG,IO,JOB,STORAGE,TEST,"[(","_C_",") G GG
E G ERR^dim2
 ;
INC S II=II+1,C=$E(EX,II) Q
 ;
FN ; literal string argument 2 of $FNUMBER (QUOTE)
 Q:STK(SP-1,1)'=1  F FZ=II-1:-1 S FN=$E(EX,FZ) Q:FN=""""
 S FN=$TR($E(EX,FZ+1,II-1),"pt","PT")
 F FZ=1:1 Q:$E(FN,FZ)=""  I "+-,TP"'[$E(FN,FZ) S ERR=1 Q
 Q:ERR  I FN["P" F FZ=1:1 Q:$E(FN,FZ)=""  I "+-T"[$E(FN,FZ) S ERR=1 Q
 Q
 ;
EXT ; extrinsic functions and variables (FUNC)
 D INC
 F II=II+1:1 S C1=$E(EX,II) Q:C1?1PC&("^%"'[C1)!(C1="")  S C=C_C1
 G:C="" E G:C?.E1"^" E G:C["^^" E
 S C1=$P(C,"^",2) I C1]"",C1'?1U.15AN,C1'?1"%".15AN G E
 S C=$P(C,"^") I C]"",C'?1U.15AN,C'?1"%".15AN,C'?1.16N G E ;p18
 I $E(EX,II)="(",$E(EX,II+1)'=")" S STK(SP,0)="P^",(STK(SP,1),STK(SP,2),STK(SP,3))=0,SP=SP+1 G GG
 S II=II+$S($E(EX,II,II+1)="()":1,1:-1)
 G GG:"[],)><=_&#!'+-*/\?:"[$E(EX,II+1),E

