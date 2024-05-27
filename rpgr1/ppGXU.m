ppGXU ;CKW/ESC i8mar24 umep./ rppar1/ ;2024-0308-63; Audit Part 1 GRv GRc Undef Refs in grulst
;
;  was Aud^ppGRI
;  Tests Structural parts, format of elements
;    Creates  GXxg(grab,gran)=Rn  cross ref  grab is in grulst of gran
;
;;grabFL:grde,grnun,grri_GRv(grab)
Aud    NEW Q,ngr,ngn I $$arg^pps("GRv,GRc,GXsq") G Qb
       KILL GXxg,GXgtt,GXut,GXur  ; GXxg(grab,gran)=Rn
       S (ngr,ngn,nxg)=0  NEW grab,grnun,grun,gran,rsq,nni
       F rsq=1:1:GXsq S grab=$G(GXsq(rsq)) DO  ;
         .I grab="" D b^dv("Err grab GXsq(rsq","rsq,grab")  G Qb
         .S ngr=ngr+1
         .D GFL^kfm(grabFL) ; GRv(grab,    grri, grde, grnun     
         .I grab'?.1"["1A.10AN S Q="Err grab format 1A.10AN " G Qb  ;grab format
         .F grun=1:1:grnun S gran=grab_"."_grun DO  ;
            ..D GFL^kfm("grulst",granFL)  ; GRc(gran,
            ..S ngn=ngn+1
            ..D toty ; tok : toty {T, E, R}            
            ..S  VX="'"_tok_"'-"_" in "_gran_"."_Rnx_" at ln "_grri

            ..F Rnx=1:1:$L(grulst," ") S tok=$P(grulst," ",Rnx) DO  ;
                ...I tok="" DO  Q
                     ....I $G(grulst)="" D b^dv(grulst is ALL null","grulst,tok,gran,grab") Q
                     ....D b^dv("Err null tok in grulst","Rnx,grulst,tok,gran,grab") Q
                ...S ngt=ngt+1
                ...I Rnx=1,tok["/" DO  ; OBS  
                     ....S tok0=tok
                     ....S grtt=$P(tok,"/",2),tok=$P(tok,"/"),GXgtt(gran)=grtt
                     ....D b^dv("OBS / in rgulst tok","grri,grab,gran,grulst,Rn,tok")                     
                ...I tok?1P S tp=$G(GRt(tok)) DO:tp=""  ;
                     ....D wu("Undef ?1P tok/Term  ^"_$T(+0))
                     ....S GXup(tok)=VX
                ...I tok["." S tp=$G(GRt(tok)) DO:tp=""  ;
                     ....D wu("Undef tokt/GRt by ^"_$T(+0))
                     ....S GXut(tok)=VX
                ...I $D(GRv(tok))=0 DO  Q
                     ....D wu("Undef grab rule-name ^"_$T(+0))
                     ....S GXur(tok)=VX  ;Undef grab
                ...;tok~grab is in grulst of gran
                ...S GXxg(grab,gran)=VX
                ...S nxg=nxg+1
        W !!,"tot  num grabs ngr:",$G(ngr),"   num gran's  ngn:",$G(ngn),!!
      G Q
;*  tok : tpty {T, E, R} and fmt err appended
toty(tok) I $G(tok)="" S toty="?tok-null"  D b^dv("Bug arg tok","tok,toty") Q
    S toty="?"
    I $E(tok)="[" S toty="E" DO  ;
      .S tna=$E(tok,2,99) I tna'?1A.AN S toty=toty_" err fmt,"
      .I $L(tna)>10 S toty=toty_" len>10, "
    I tok?1P S toty="T"
    I tok["." S toty="T" DO  ;
      .S tna=$P(tok,"."),t2=$P(tna,".",2,999)
      .I tna="" S toty=toty_" err null tna dot, "      
      .I t2'="" S toty=toty_" err sfx dot only, "
    I toty="?" S toty="R" DO  ;
      .I tok'?1A.AN S toty=toty_" err grab fmt, "
      .I $L(tok>10 S toty=toty_" err tok len>10, "
    Q

;*
WUS   I $D(GXur)=0 W:$X ! W "No Undef refs in grulst GXur in ","devrg")
      E  S g1=0 FOR gj=0:1 S g1=$O(GXur(g1)) Q:g1=""  DO  ;
         .S grab=g1,VX=$G(GXut(g1))
         .W:$X ! W "Undef tok '",tok,"' ",VX,!
      I $D(GXut)=0 W:$X ! W "No Undef term toks in grulst  GXut ","devrg")
      E  S g1=0 FOR gj=0:1 S g1=$O(GXut(g1)) Q:g1=""  DO  ;
         .S grab=g1,grri=$G(GXut(g1))
         .W:$X ! W "'",grab," in "
      Q
;*
wu(M)  S:$G(M)="" M="Undef Err "_$G(tok)_"  "
       W:$X ! W M W "  ",tok,"   in ",grulst,"   "
       Q
;*
Q      Q:$Q Q Q:Q=""
Qb     D b^dv("Err ^"_$T(+0),"Q,RG,devrg,gi,grab,gran") Q:$Q Q  Q
;*
