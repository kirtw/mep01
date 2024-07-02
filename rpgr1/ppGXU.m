ppGXU ;CKW/ESC i8mar24 umep./ rppar1/ ;2024-0308-63; Audit Part 1 GRv GRc Undef Refs in grulst
;
;  was Aud^ppGRI
;  Tests Structural parts, format of elements
;    Creates  GXxg(tok,gran)=Rn  cross ref  grab/tokt is in grulst of gran
;  Undef Refs  GXur R & E, GXup T/?1p, GXut T dot name
;
;;grabFL:grde,grnun,grri_GRv(grab)
Aud    NEW Q,ngr,ngn I $$arg^pps("GRv,GRc,GXsq") G Qb
    USE $P W:$X ! W !,"GRammar Audit 1 - Undef Refs  ^"_$T(+0),!!
       KILL GXxg,GXut,GXur,GXup,GXgtt  ; GXxg(grab/tok,gran)=Rnx/VX
       S (GXxg,GXut,GXur,GXup,GXgtt)=0
       S (ngr,ngn,ngt,nxg,nuxg)=0  NEW grab,grnun,grun,gran,rsq,nni
       FOR rsq=1:1:GXsq S grab=$G(GXsq(rsq)) DO  ;
         .I grab="" D b^dv("Err grab GXsq(rsq","rsq,grab")  G Qb
         .S ngr=ngr+1
         .D GFL^kfm(grabFL) ; GRv(grab,    grri, grde, grnun     
         .I grab'?.1"["1A.10AN.1"]" S Q="Err grab format 1A.10AN " G Qb  ;grab format
         .FOR grun=1:1:grnun S gran=grab_"."_grun DO  ;
            ..D GFL^kfm("grulst",granFL)  ; GRc(gran,
            ..S ngn=ngn+1
            ..FOR Rnx=1:1:$L(grulst," ") S tok=$P(grulst," ",Rnx) DO  ;
                ...D setty(tok) ; tok : toty {T, E, R},  VX
                ...I tok="" DO  Q
                     ....I $G(grulst)="" D b^dv("grulst is ALL null","gran,grulst,tok") Q
                     ....D b^dv("Err null tok in grulst","gran,Rnx,grulst,tok") Q
                ...S ngt=ngt+1
                ...I tok?1P S D=$D(GRt(tok)) D:'D UP D:D XUG
                ...I tok["." S D=$D(GRt(tok)) DO:'D UP D:D XUG
                ...I (toty="R")!(toty="E") S D=$D(GRv(tok)) D:'D UG D:D XUG ;toty='R' or 'E' 
        W !!,"tot  num grabs ngr:",$G(ngr),"   num gran's  ngn:",$G(ngn)," ngt:",$G(ngt),!!
        I nxg W:$X ! W "grab undef errors: ",nxg,!!
      I $G(devlog)'="" USE $P D WUS USE devlog 
        D WUS  ;Dump GXu* Undef Refs
      G Q
;*
XUG   S GXxg(tok,gran)=VX,GXxg=GXxg+1  ;nl cross ref
      Q
UG    D wu("Undef grab rule-name UG^"_$T(+0))
      S nuxg=nuxg+1
      S GXur(tok,gran)=VX,GXur=GXur+1  ;Undef tok/grab
      Q
UP    D wu("GXut Undef tokt./?1P GRt by UP^"_$T(+0))
      S GXut(tok,gran)=VX,GXut=GXut+1
      Q
;*  tok : tpty {T, E, R} and fmt err appended,  VX
setty(tok) I $G(tok)="" S toty="?tok-null"  D b^dv("Bug arg tok","tok,toty") Q
    S toty="?",VX="?"
    I $E(tok)="[" S toty="E" DO  ;
      .S tna=$E(tok,2,99) 
      .S tna=$P(tna,"]")
      .I tna'?1A.10AN S toty=toty_" err fmt,"
      .I $L(tna)>10 S toty=toty_" len>10, "
    I tok?1P S toty="T"
    I tok["." S toty="T" DO  ;
      .S tna=$P(tok,"."),t2=$P(tna,".",2,999)
      .I tna="" S toty=toty_" err null tna dot, "      
      .I t2'="" S toty=toty_" err sfx dot only, "
    I toty="?" S toty="R" DO  ;
      .I tok'?1A.AN S toty=toty_" err grab fmt, "
      .I $L(tok)>10 S toty=toty_" err tok len>10, "
    S VX="'"_tok_"' - ("_toty_") in "_gran_"."_Rnx_" at ln "_grri
    Q

;*  GXur(grab  Undef tok as grab   GXut(grab  GXup(grab
WUS   W:$X ! W "Undef toks Analysis  WUS^"_$T(+0),!!
      I $D(GXur)=0 W:$X ! W "No Undef grab refs in grulst GXur in devrg: ",$G(devrg),!
      E  S g1=0 W:$X ! W "GXur- " FOR gj=0:1 S g1=$O(GXur(g1)) Q:g1=""  DO  ;
         .S gn0=0 F  S gn0=$O(GXur(g1,gn0)) Q:gn0=""  DO  ;
           ..S tok=g1,VX=$G(GXur(g1,gn0))
           ..I VX="" D b^dv("Err VX ","VX,tok,gran,grab,gn0,g1")
           ..W:$X ! W VX,!
      I $D(GXut)=0 W:$X ! W "No Undef term toks in grulst  GXut devrg: ",devrg,!
      E  S g1=0 W:$X ! W "GXut- " FOR gj=0:1 S g1=$O(GXut(g1)) Q:g1=""  DO  ;
         .S gn0=0 F  S gn0=$O(GXut(g1,gn0)) Q:gn0=""  DO  ;
           ..S grab=g1,VX=$G(GXut(g1,gn0))
           ..W:$X ! W VX,!
      I $D(GXup)=0 W:$X ! W "No Undef term punct in grulst  GXup devrg: ",devrg,!
      E  S g1=0 W:$X ! W "GXup- " FOR gj=0:1 S g1=$O(GXup(g1)) Q:g1=""  DO  ;
         .S gn0=0 F  S gn0=$O(GXup(g1,gn0)) Q:gn0=""  DO  ;
           ..S grab=g1,VX=$G(GXup(g1,gn0))
           ..W:$X ! W VX,!             
      Q
;*
wu(M)  S:$G(M)="" M="Undef Err "_$G(tok)_"  "
       W:$X ! W M W "  ",tok,"   in ",grulst,"   "
       Q
;*
Q      Q:$Q Q Q:Q=""
Qb     D b^dv("Err ^"_$T(+0),"Q,RG,devrg,gi,grab,gran") Q:$Q Q  Q
;*
