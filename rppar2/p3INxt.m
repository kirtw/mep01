p3INxt ;CKW/ESC i3jul24 umep./ rppar2/ ;2024-0703-24;Get Next Input and rest of current String
;
;   LM  Line of mumps code, from mri in mRou, RM(mri)
;   mci ptr into LM
;   tki ptr into TKv(tki)  units, sometimes more than one char, eg. KILL
;   TKc is C  next char to drive parse
;   tokt is term tok found 1st char of, to finish word prn, ttfin
;   Adds EOL after line (and EOF), triggers TKc upon next call, ie mci=0
;
;
top   ;
;*  mci, tki : Str, cs,ce + mci', tki', C, TKc,  mri, LM'
;* Produces:  C~TKc, TT()
;;Static vars: mci, LM, mri, mRou, RM()   
NxtI  NEW Q I $$arg^p2s("mci,mri,tki,RM") G Qb
     ;I C=EOF,TKc=C G Q
     S mci=mci+1,C=$E(LM,mci),tki=tki+1
     I C=""  D NewL G Q
     KILL TT
     I C?1A S TT("A")=2,TT("AN")=3,TT("ANP")=4,TT("E")=5
     S:C?1L TT("L")=6 S:C?1U TT("U")=6
     S TKc=C 
     USE $P W:$X ! W " ** Next TKc:",TKc W:TKc?1C $A(TKc)," " W !
     G Q
;*
Q      Q:$Q Q Q:Q=""
Qb     D b^dv("Err ^"_$T(+0),"Q,StkP,grab,gran,QB,QN,QT") Q:$Q Q  Q
;* mri : TKc~C=EOL, mri', LM, mci=0  New Line past end of LM
NewL S C=EOL,TKc=C,mci=0
     I mri'<RM S C=EOF,TKc=C Q
     S mri=mri+1,LM=$G(RM(mri))
     I LM[$C(9) S LM=$TR(LM,$C(9)," ") ;subs one space for tab
     I LM[$C(10) S LM=$TR($C(10)) ;get rid of extra LF
     Q
;*
Init KILL TKv S TKv=0,tki=0,mci=0  
     D IES  ; CMD(wdl) keywords
     ;Read Mrou into RM()
     S mri=1,LM=$G(RM(1)),tki=0
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
;;tokFL:tkcod,tks,tkcs,tkce,tkri_TKv(tki)

;*  mci, LM, tki : mci', TKv(tki,  
VnaQT() I TKc'?1A,TKc'="^",TKc'="%" Q 0  ; QTest Fails   ;;ttQT
    S tkcs=mci,tkcod=tokt F xci=mci+1:1:$L(LM) S C=$E(LM,xci) I C'?1AN  Q
      S mci=xci-1,tkce=mci
      S tks=$E(LM,tkcs,tkce)
      D SFL^kfm("tks,tkcs,tkce,tkcod",tokFL)  ; : TKv(tki,  
      D pze^p2s("Log end VnaQT","TKc,mci,tkcs,tkce,tks,grts,grte,tki")        
    Q 1
;* tokt : QTest~$$, tki', mci' TKv(tki, 
CmdQT() S CC=$E(tokt),CU=$$UC^dvc(CC),CL=$$LC^dvc(CC)
        D GFL^kfm("ttC1L",granFL)
        I ttC1L'[TKc Q 0  ; QTest fails
        ;
      S c1=mci F mci=mci+1:1:$L(LM) S C=$E(LM,mci) I C'?1A DO  Q  ;;ttQT
        .S tkcs=c1,tkce=mci-1
        .S tks=$E(LM,tkcs,tkce),Slc=$$LC^dvc(tks)
        .I mci=c1 Q ; No continuation chars
      I mci>c1,$G(CMD(Slc))="" DO  Q "0 Err '"_Slc_"'"  ;Syntax Err, QTest 0
        .S ERR("InCmd")=Slc D ERR("Cmd Spelling?")
      S tkcod=tokt ; eg. 'Kcmd.'
      D SFL^kfm("tks,tkcs,tkce,tkcod",tokFL)  ; : TKv(tki,     
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
;*
;*  OBS old code
;*   Bump Input token :  QI, tki', ci -> tkcod~TKc,tks,tkcs,tkce
IinXX  NEW Q I $$arg^p2s("tki") G Qb
     S QI="" I tki'<TKv S QI="End of TKv(tki" D NFL^kfm(tokFL) G Q  ;Done, no more Input
     S tki=tki+1
     D GFL^kfm(tokFL) ; TKv(tki
     S TKc=tkcod
       I TKc="" D pze^p2s("Log TKv Done.","tki,TKc,grab,Rn,grulst,tok") G Qb
     W:$X ! W "--nxt In:",tki,"  ",tkcod," ",tks,!
     G Q
