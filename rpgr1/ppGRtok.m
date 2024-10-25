ppGRtok ;CKW/ESC i30jun24 umep./ rpgr1/ ;2024-0630-49;Construct Terminal grammar GRt
;  separate TOI files and processing from mGR1a.mdk  and ^ppGRI
;
;
;
top  NEW Q,tsq S Q=""   ;Read RT() from mPAR-TERM1a.mdk 
     ;GRt()
     D ^p2IMG  ; tokgrFL
     D CRTtokt ; RT//tok : GRt(tokt, GXtsq(tsq)=tokt
     D Aa
     G Q
;
;*  GRt  :  GRt(tokt)=tokt  Index of terminal token names, including certain Punct
CRTtokt NEW Q S Q=""  I $$arg^pps("RT") G Qb
       NEW gi,gi0,PUL,P,tokt,L,L1
       KILL GRt,GXtsq,GXtt S GXtt=0,gti=0,GXtsq=0 
       KILL TTc1 ;
         S TTc1("sp1."," ")=1  ;Fudge, not from term table syntax
         S TTc1("com1.",",")=1
         S TTc1("dot1.",".")=1
         F c=" ",$C(9,10) S TTc1("wsp.",c)=1   ;EOL=$C(10) 
       S gi0=0 F gi=1:1:RT S L=$G(RT(gi)) I $E(L,1,2)="//",L["tokt" S gi0=gi+1 Q
       I 'gi0 S Q="Err did not find //tokt in RT("_gi G Qb
       ; Punct List
       S PUL=$P(L," ",2,999) D TPUL(PUL),AudP
       ;
       F gi=gi0:1:RT S L=$G(RT(gi)) Q:L["//"  Q:L["***"  DO  ;
         .S L1=$$DSP^dvc($P(L,"::")),L2=$$DSP^dvc($P(L,"::",2))
         .S tokt=$P(L1," ")
         .S ttde=$P(L1," ",2,9) I ttde="" S ttde=tokt
         .S ttri=gi
         .I tokt="" Q  ;Ignore blank line
         .I tokt'["." S tokt=tokt_"."
         .I L2'="" D C1 ; tokt, L2 : TTc1(tokt,C)=1
         .D SFL^kfm("ttde,ttri",tokgrFL) ; GRt(tokt, 
         .S tsq=tsq+1,GXtsq(tsq)=tokt,GXtsg=tsq
       G Q
;* tokt, L2 sp-delim-list
C1     KILL TTc1(tokt)
       F ci=1:1:$L(L2," ") S P=$P(L2," ",ci) DO  ;
         .I P[".",$D(TTc1(P)) DO  Q  ;copy
            ..MERGE TTc1(tokt)=TTc1(P)
         .I P?1ANP S TTc1(tokt,P)=1 Q
         .D b^dv("Err tokt Unk Chars in L2","tokt,L2,ci,P")
       ;I tokt="Apat." W !! KILL TT MERGE TT=TTc1(tokt) zwr TT W !! D b^dv("Log Apat.","tokt")
       Q
;*

       
;*
Q      Q:$Q Q Q:Q=""
Qb     D b^dv("Err ^"_$T(+0),"Q,RG,devrg,gi,grab,gran") Q:$Q Q  Q
Qbug   D b^dv("Bug ?arg ","Q,gi")  Q:$Q Q  Q
;*
;;tokgrFL:ttde,ttri_GRt(tokt)         
Aa     NEW Q S Q=""  S ttri="Aa"
       F ci=1:1:26 S C=$C(ci+64),c=$C(96+ci) DO  ; two entries per letter, cap & lc
         .I (c'?1L)!(C'?1U) d b^dv("Err  c and C","ci,c,C")
         .S tokt=c_".",tks=c 
         .S ttde="Letter "_c
         .S tsq=tsq+1,GXtsq(tsq)=tokt,GXtsg=tsq
         .D SFL^kfm("ttde,tokt,tks,ttri",tokgrFL) ; tokt
         .;
         .S tokt=C_".",tks=C
         .S ttde="Letter "_C 
         .S tsq=tsq+1,GXtsq(tsq)=tokt,GXtsg=tsq
         .D SFL^kfm("ttde,tokt,tks,ttri",tokgrFL)
         .W:$X ! W ci,": ",tokt," ",?8,tks," ",?18,ttde,!
       W:$X ! W "Finished CRTtok^"_$T(+0)_"  Composing GRt(tokt,  Terminal token db.",!
       G Q
;*  terminals as unquoted punct
TPUL(PUL) NEW Q I $$arg^p2s("PUL") G Qbug
         I PUL'?5.50P D b^dv("Bug PUL line //tokt Punct List","PUL,L,gi0") G Qb
         F tsq=1:1:$L(PUL) S P=$E(PUL,tsq) DO  ;
           .I P=" " Q  ;ignore space
           .I P'?1P D b^dv("Err in PUL non-punct","P,tsq,PUL") Q
           .S GRt(P)=P
           .S GXtsq(tsq)=P  ;Literal Punct
         S GRt(0,"PUL")=PUL
         G Q
;*
AudP     F ci=32:1:126,241:1:253 S C=$C(ci) DO  ;
           .I C?1P DO  Q  ;
             ..I $G(GRt(C))'="" Q  ;test C=GRt(C) ? 
             ..I C=" " Q  ;space is NOT in GRt
             ..I "`~|"[C Q  ;Non-mumps Punct
             ..D b^dv("Punct not in TKv terminal","ci,C")
           .I C?1N DO  Q
             ..
           .I C?1C DO  Q
             ..S nCtrl=$G(nCtrl)+1
             ..D b^dv("Ctrl Char","ci,C")
           .I C?1A DO  Q
             ..;
           .D b^dv("Other pattern C ","C,ci")
         W:$X ! W "Completed Punct Audit- AudP^"_$T(+0),!
         Q
;*
