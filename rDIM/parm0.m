parm0  ;CKW/ESC i26nov23 umep./ rDIM/ ;2023-1126-90;Table driven mumps parser
;
;
; EX
top   S X1=1 
      D NXC
      ;Init table
      KILL STK S SP=1,RM="line"
      D IPT,IKEY
      ;
R01   I Ct="v" S label=Cv D NXC G L2
      S label="",IL=IL+1 G L3
L2    I C="(" D FAL  ; G L3
L3    I C=";" D COM2 G R01
      S Ci=1
C0    I C="@" D Icmd S Ci=Ci+1      
      I Ct="v",Kt="cmd" S Cmd=Wc D NXC G C1
      I C=";" D COM2 G R01
      S Q="cmd1" G ER
;*
COM2  S COM(ri)=$E(EX,X1,999)
      D NXln
      Q
;*
C1    I C=":" D POC G C2
C2    I C=" " G C3
      S ER="cmd2" G ER
;*
FAL    ;  formal args after label and (
      Q
ER    I $$NXln="" D NXC G R01
      ; Done
      D b^dv("Done ?","Q,C")
      Q
;*
C3    S Clab="Cmd"_Wc I $T(@Clab)="" D b^dv("err Clab","Clab,C,Ct")
      G @Clab
;*  CmdD for DO/D/d/do
CmdD  I C=" " S nDot=nDot+1 G C0
      D ERF
      I C=":" D PCA  ; arg post cond expr
      I C="," D NXC G CmdD  ; another arg
      S ER="Do arg?" G ER
;* entry Ref
ERF   S lab="",mrou="",off="" 
      I Ct="v" S lab=Cv D NXC
      I C="+" DO  G ER:ER'=""
        .D NXC I Ct="i" S off=Ci D NXC
        .S ER="ent-ref-off?"
      I C="^" DO  ;
        .D NXC I Ct="v" S mrou=Cv D NXC
      I C="(" D Arg
      Q
;* post cmd conditional of Wc
POC   D exprb  ;coerce boolean
      Q
;* post arg conditional
PCA   D exprb ; post cond of Arg
      Q
;*  Cmd level Indirection, coerce value of cmd syntax
Icmd  D expr
      Q
;*
NXC   S X2=X2+1,C=$E(EX,X2)
    I C="" S C=EOL,Ct="e" Q
    I C?1P S Ct="p" Q
    I C?1N DO  Q
      .F i=X2:1 I $E(EX,i)'?1N S X2=i,Ct="i" Q
      .S C=$E(EX,X2) I C="." DO  S Ct="n",X2=i Q
         ..F i=X2+1:1 I $E(EX,i)'?1N Q
    I C="%"!(C?1A) DO  S Ct="v",X2=i Q
      .F i=X2+1:1 I $E(EX,i)'?1AN  S X2=i-1 Q
      .S Cv=$E(EX,X1,X2)
      .S wd=$E(EX,X1,X2),wdl=$J(wd,"L")
      .S Kt=$G(KEY(wdl))
      .I Kt'="" 
    I C="""" DO  S Ct="q" Q
      .F i=X2:1:$L(EX) I $E(EX,i)="""",$E(EX,i+1)'="""" S X2=i+1,Cq=$TR($E(EX,X1,i),"""","")
    I C?1P S Ct="p" Q
    ; ctrl, tab, EOL ?
    D b^dv("Unsure","C,X1,X2,Ct")
    Q
;*$$Q ? done last line
NXln() S ri=ri+1,EX=$G(RM(ri))
      S X2=1,X1=1 D NXC
      Q:$Q Q  Q
;*
expr  ;
      Q
;*
exprb ;
      Q
;*
IKEY  ;
      Q
;*
IPT   ;
      Q
;*
Arg   ;
      Q
;*
