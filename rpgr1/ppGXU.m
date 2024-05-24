ppGXU ;CKW/ESC i8mar24 umep./ rppar1/ ;2024-0308-63; Audit Part 1 GRv GRc Undef Refs in grulst
;
;  was Aud^ppGRI
;  Tests Structural parts, format of elements
;    Creates  GXxg(grab,gran)  cross ref  grab is in grulst of gran
;
;;grabFL:grde,grnun,grri_GRv(grab)
Aud    NEW Q,ng,nan I $$arg^pps("GRv,GRc,GXsq") G Qb
       KILL GXxg,GXgtt,GXut,GXur  ; GXxg(grab,gran)=
       S (ng,nan,nxg)=0  NEW grab,grnun,grun,gran,rsq,nni
       F rsq=1:1:GXsq S grab=$G(GXsq(rsq)) DO  ;
         .I grab="" D b^dv("Err grab GXsq(rsq","rsq,grab")  G Qb
         .S ng=ng+1
         .D GFL^kfm(grabFL) ; GRv(grab,    grri, grde, grnun     
         .I grab'?.1"["1A.10AN S Q="Err grab format 1A.10AN " G Qb
         .F grun=1:1:grnun S gran=grab_"."_grun DO  ;
            ..D GFL^kfm("grulst",granFL)  ; GRc(gran,
            ..S nan=nan+1
            ..F Rnx=1:1:$L(grulst," ") S tok=$P(grulst," ",Rnx) I tok'="" DO  ;
                ...I Rnx=1,tok["/" S grtt=$P(tok,"/",2),tok=$P(tok,"/"),GXgtt(gran)=grtt
                ...I tok?1P S tp=$G(GRt(tok)) DO:tp=""  Q
                     ....D wu("Undef ?1P tok/Term  ^"_$T(+0))
                     ....S GXut(tok)=grri
                ...I tok["." S tp=$G(GRt(tok)) DO:tp=""   Q
                     ....D wu("Undef tokt/GRt by ^"_$T(+0))
                     ....S GXut(tok)=grri
                ...I $D(GRv(tok))=0 DO  Q
                     ....D wu("Undef grab rule-name ^"_$T(+0))
                     ....S GXur(tok)=grri  ;Undef grab
                ...;tok~grab is in grulst of gran
                ...S nxg=nxg+1
        W !!,"tot  num grabs ng:",$G(ng),"   num gran's  nan:",$G(nan),!!
      G Q
;*
wu(M)  S:$G(M)="" M="Undef Err "_$G(tok)_"  "
       W:$X ! W M W "  ",tok,"   in ",grulst,"   "
;*
Q      Q:$Q Q Q:Q=""
Qb     D b^dv("Err ^"_$T(+0),"Q,RG,devrg,gi,grab,gran") Q:$Q Q  Q
;*
