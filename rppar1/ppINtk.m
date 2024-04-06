ppINtk  ;CKW/ESC i7feb24  umep./  rppar1/ ;2024-0207-70;Parse input LM to tokens TKv(ti)
;
;  RM()  MuMPS MRou source code,  from file <MRou>.m
;  
;  TKv(tki,vn)  for Tokens of one line, ri/label+I, L0~LM string
;tki:i,sub Sequential token (not id, info in sequence!)
;;tks:s Input string value of token
;;tkcod:s,c Token code, ends in ., terminal code in rules of grammar
;;tkcs:i Ptr into LM input line start
;;tkce:i Ptr to last char in input included in this token
;
;
;;tokFL:tkcod,tks,tkcs,tkce,tkri_TKv(tki)
top   D II  ;TKc
      D IKY  ; KY() key word for TKk(ky)=<Tok>  choose TKk vs TKc wd by context/rule
      I $D(RM)'=11 D bug^dv Q
      F ri=1:1:RM S L0=$G(RM(ri)) D PL
      ;
      Q
;* pre-Parse L0 to tokens TKc(ti), ignore label
PL    S LC=$P(L0," ",2,999)
P2    D NXC,C1
      I C=EOF Q
      G P2
;*      
C1    S c0=ci I C=" " S tt="wsp." DO  G PL
        .I LC[$C(9) S LC=$TR(LC,$C(9)," ")
        .F i=ci+1:1 I $E(LC,i)'=" " S ci=i-1 Q
        .D ITK S TKc(ti)="wsp.",TKs(ti)=$E(LC,c0,ci)
      I C?1P D ITK S TKc(ti)=C,TKs(ti)=C Q
      I C?1n DO  Q
        .F i=ci+1:1 I $E(LC,i)'?1n  Q
        .D ITK S ci=i-1,TKs(ti)=$E(LC,c0,ci),TKc(ti)="i."
      I C?1A DO  Q
        .F i=ci+1:1 I $E(LC,i)'?1AN Q
        .D ITK S ci=i-1,TKc(ti)="wd."
        .S key=$E(LC,c0,ci),klc=$$LC^dvc(key)
        .S Tc=$G(KY(klc)) I Tc'="" S:Tc'["." Tc=Tc_"." S TKk(ti)=Tc
      I C=EOL Q
      I C=EOF Q
      D b^dv("Err C type ?","C,ci,LC")
      Q
ITK   S ti=ti+1,TKs=ti,TKc=ti Q
;*  EOL extra vs ci,LC
NXC   S ci=ci+1,C=$E(LC,ci),EOL=$C(10),EOF=$C(14)
      I C="" S C=EOL,ci=0,ri=ri+1,LC=$G(RM(ri)) I LC="",ri>RM S C=EOF Q
      Q
;*
II    KILL TKc,TKs S TKc=0,TKs=0,ti=0
      S ci=0,ri=0,LC=""
      ;
      Q
;*
;*  KY(lc)=<tokKY>  eg Scom. s set
IKY   KILL KY S KY=0
      F I=1:1 S T=$T(KEYS+I),L=$P(T,";;",2,9) Q:T["***"  Q:T=""  I L'="" DO  ;
        .S Tc=$P(L," "),KL=$P(L," ",2,999)
        .  I Tc[":" S Tc=$P(L,":"),KL=$P(L,":",2,99)
        .I Tc'["." S Tc=Tc_"."
        .F ki=1:1:$L(KL," ") S key=$P(KL," ",ki) DO:key'?1.L  S KY(key)=Tc
           ..S key=$$LC^dvc(key)
      Q
;*
KEYS  ; Automatically extrapolates to Upper Case variants in match algorithm $$LC
;;Swd s set
;;Kwd k kill
;;Qwd q quit
;;
;;fEwd e extract
;;fLwd l length
;***;
