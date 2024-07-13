p3INxt ;CKW/ESC i3jul24 umep./ rppar2/ ;2024-0703-24;Get Next Input and rest of current String
;
;   LM  Line of mumps code, from MRi in mRou, RM(MRi)
;   LMi ptr into LM
;   LMc,<-TKc is C  next char to drive parse
;   tokt is term tok found 1st char of, to finish word prn, grsyn
;   Adds EOL after line (and EOF), triggers LMc upon next call, ie LMi=0
;
;
top   ;
;*  LMi: grstr, cs,ce + LMi', LMc,  MRi
;* Produces:  C~LMc, TT()
;;Static vars: LMi, LM, MRi, mRou, RM()   
NxtI  NEW Q I $$arg^p2s("LMi,LM,MRi,RM") G Qb
     ;I C=EOF,LMc=C G Q
     S LMi=LMi+1,C=$E(LM,LMi),LMc=C
     I C=""  D NewL G Q
     KILL TT
     I C?1A S TT("A")=2,TT("AN")=3,TT("ANP")=4,TT("E")=5
     S:C?1L TT("L")=6 S:C?1U TT("U")=6
     S LMc=C 
     USE $P W:$X ! W " ** Next LMc:",LMc W:LMc?1C $A(LMc)," " W !
     G Q
;*
Q      Q:$Q Q Q:Q=""
Qb     D b^dv("Err ^"_$T(+0),"Q,StkP,grab,gran,QB,QN,QT") Q:$Q Q  Q
;* MRi : LMc~C=EOL, MRi', LM, LMi=0  New Line past end of LM
NewL S C=EOL,LMc=C,LMi=0
     I MRi'<RM S C=EOF,LMc=C Q
     S MRi=MRi+1,LM=$G(RM(MRi))
     I LM[$C(9) S LM=$TR(LM,$C(9)," ") ;subs one space for tab
     I LM[$C(10) S LM=$TR($C(10)) ;get rid of extra LF
     Q
;*
Init D IES  ; CMD(wdl) keywords
     ;Read Mrou into RM()
     S MRi=1,LM=$G(RM(MRi)),LMi=0
     S EOL=$C(10),EOF=$C(14)
     D NxtI  ;does this for caller !
       ;Fudge ttQT attr of certain terminals which may be multi Input chars
       ; and funky mumpsy QTest's
     S GRt("Vna.","ttQT")="VnaQT"
     F a=65:1:65+25 S C=$C(a),tC=C_"cmd." I $D(GRt(tC)) DO  ;
       .S CL=$$LC^dvc(C),ttC1L=C_" "_CL
       .S GRt(tC,"ttC1L")=ttC1L
       .S GRt(tC,"ttQT")="CmdQT"       
       .W:$X ! W "Assign ttQT of ",tC," = CmdQT","(",ttC1L,") ",!
     Q
;;tokgrFL:ttde,ttri,tokt,tts,ttQT_GRt(tokt)     
;  
;*  LMi, LM, LMi tkcs,tkce : grstr, LMi', new LMc,  tkcod
VnaQT() ;I LMc'?1A,LMc'="^",LMc'="%" Q 0  ;;Vna. TTt1  QTest already passed 1st char  
      ;;TTt1(tokt,LMc)
    NEW xci
    S tkcs=LMi,tkcod=tokt F xci=LMi+1:1:$L(LM)+1 S C=$E(LM,xci) I C'?1AN  Q
      S LMi=xci-1,tkce=LMi
      S grstr=$E(LM,tkcs,tkce)
      D pze^p2s("Log end VnaQT","LMc,LMi,tkcs,tkce,grstr,grts,grte,gran,Rn")        
    Q 1
;* tokt : QTest~$$,  LMi' 
CmdQT() S CC=$E(tokt),CU=$$UC^dvc(CC),CL=$$LC^dvc(CC)    ;;ttQT
        D GFL^kfm("ttC1L",granFL)
        I ttC1L'[LMc Q 0  ; QTest fails
        ;
      S c1=LMi F LMi=LMi+1:1:$L(LM) S C=$E(LM,LMi) I C'?1A DO  Q
        .S tkcs=c1,tkce=LMi-1
        .S tks=$E(LM,tkcs,tkce),Slc=$$LC^dvc(tks)
        .I LMi=c1 Q ; No continuation chars
      I LMi>c1,$G(CMD(Slc))="" DO  Q "0 Err '"_Slc_"'"  ;Syntax Err, QTest 0
        .S ERR("InCmd")=Slc D ERR("Cmd Spelling?")
      S tkcod=tokt ; eg. 'Kcmd.'
      ;D SFL^kfm("tks,tkcs,tkce,tkcod",tokFL)  ; : TKv(tki,     
      Q 1
;*
ERR(M) S:$G(M)="" M="Err ^"_$T(+0)
       W:$X ! W M,"  ",!
       Q
;*  : CMD(CmdWds)=  vs KEY() combined, sep tests anyway
IES  NEW CML,Cj,Cmd,Clc,CU,CL,C1
     S CML="BREAK,CLOSE,DO,ELSE,FOR,GOTO,HALT,HANG,IF,JOB,KILL,LOCK,MERGE,NEW,OPEN"
       S CML=CML_",PRINT,QUIT,READ,SET,TRANS,USE,VIEW,WRITE,XECUTE"
     KILL CMD
     F cj=1:1:$L(CML,",") S Cmd=$P(CML,",",cj),Clc=$$LC^dvc(Cmd),C1=$E(Cmd) DO  ;
       .S CU=$E(Cmd),CL=$E(Clc),CMD(CU)=C1,CMD(CL)=C1
       .S CMD(Cmd)=C1,CMD(Clc)=C1
     ; $FUN words, OPEN wds, ... ?keywords
     Q
;*
;*  Fudge RM() for testing
fake KILL RM
     S RM(1)="a+b/c",RM=1,mRou="Expr1"
     Q
;*

