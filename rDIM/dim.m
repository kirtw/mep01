dim ;SFISC/JFW,GFT,TOAD-FileMan: M Syntax Checker, Main ;28APR2016
 ;;22.2;VA FileMan;;Jan 05, 2016;Build 42
 ;;Per VA Directive 6402, this routine should not be modified.
 ;;Submitted to OSEHRA 5 January 2015 by the VISTA Expertise Network.
 ;;Based on Medsphere Systems Corporation's MSC FileMan 1051.
 ;;Licensed under the terms of the Apache License, Version 2.0.
 ;
 NEW MX,END,ERR,LAST
 S MX=X,MXn=(X=""),END="",ERR=0,LAST="" 
   I X'?.ANP S Q="ctrl chars?" G ER
   NEW Q,CWD,CM,C1 S Q=""
   NEW 
   D ICMD  ; : CMD(cmds)=C1
   D IFNC^dim1  ; : Fna(<fcn Na>, ...)=  Fn1,Fn2  from FNC^dim
 ; MX
GC ; get next command on line (*)
   S C=$E(MX)
   G ER:ERR,LAST:C=";" F  Q:C'=" "  S MX=$E(MX,2,999),MXn=(MX="")
   I "BCDEFGHIKLMNOQRSUWXZbcdefghiklmnoqrsuwxz"'[C S Q="Illegal Cmd "_C G ER
   S LAST=MX D SEP G ER:ERR 
   S COM=$P(ARG,":") ; command word, pre post-conditional
   S C2=$G(CMD(COM)) I C2'="" S COM=C2
   I C2="",$L(COM)>1 DO  G ER:ERR
     .S CM=$TR(COM,"ABCDEFGHIJKLMNOPQRSTUVWXYZ","abcdefghijklmnopqrstuvwxyz")
     .I CM="" BREAK  ; cant ???
     .S C2=$G(CMD(CM)) I C2'="" S COM=C2 Q
     .S ERR=1
   S PC=$P(ARG,":",2,99),PCn=(PC="") 
     I ARG[":",PCn G ER ; command postcond
   I 'PCn D ^dim1 G ER:ERR
   D SEP G ER:ERR I An,"CDGMORSUWXZ"[COM G ER ; argument list reqd?
 S END=ARG G @COM
 ;
B G GC:An&PCn,BK^dim4
C G CL^dim4
D G DG^dim3
E G GC:An&PCn,ER
F G ER:'PCn,ER:C=";",GC:An,FR^dim3 ;GFT-DON'T END WITH 'F'
G G DG^dim3
H G GC:An&PCn&'MXn,HN^dim3:'An,ER Q
I G ER:'PCn,IX^dim4
K G GC:An&PCn&'MXn,KL^dim3:'An,ER
L G LK^dim3
M G S
N G ER:An&MXn,K
O G OP^dim3
Q G ER:'An,GC:An&PCn,BK^dim4
R G RD^dim4
S G ST^dim4
U G OP^dim3
W G WR^dim4
X G IX^dim4
Z G GC
;*  CMD(cmd)=C1
ICMD  KILL CMD 
      S CWD="BREAK,CLOSE,DO,ELSE,FOR,GOTO,HALT,HANG,IF,KILL,LOCK,MERGE,NEW,OPEN,QUIT,READ,SET,USE,WRITE,XECUTE"
      F i=1:1:$L(CWD,",") S CM=$P(CWD,",",i),C1=$E(CM),CMD(C1)=C1,CMD(CM)=C1
      S CW2="break,close,do,else,for,goto,halt,hang,if,kill,lock,merge,new,open,quit,read,set,use,write,xecute"
      F i=1:1:$L(CW2,",") S CM=$P(CW2,",",i),C1=$E(CM),CMD(C1)=C1,CMD(CM)=C1
      Q
 ;*  MX : ARG, MX', ?II, C
;* Scan past quote  and to space, ARG is cmd argument(s)
SEP ; remove first " "-piece of MX into ARG: parse commands (GC) MX'
  NEW II,C
  F II=1:1 S C=$E(MX,II) DO:C=""""   Q:C=" "
    .NEW OUT S OUT=0 F  DO  Q:OUT!ERR
      ..S II=II+1,C=$E(MX,II) I C="" S ERR=1 Q
      ..I C="""" Q  
      ..S II=II+1,C=$E(MX,II) 
      ..I C="""" Q
      ..S OUT=1
  S ARG=$E(MX,1,II-1),II=II+1,MX=$E(MX,II,999),MXn=(MX="")
  S An=ARG=""
  Q
;*
LAST ; check to ensure no trailing "," at end of command (GC)
    S %L=$L(LAST)
    S $E(LAST,%L+1-$L(MX),%L)=""
    I $E(END,$L(END))="," S Q="comma in ARG" G ER  ;Doesnt tolerate multiple comma arguments ???
     ;I C="",$E(LAST,%L)=" " G ER   Trailing space is OK
    G END
 ;
ER  KILL X  ;Input var =MX why kill on error
END KILL PC,CA0,CA1,CA2,ARG,C1,C,COM,END,ERR,%H,II,%L,LAST,PL,MX,%Z  ; vs NEW ?
    Q
    
