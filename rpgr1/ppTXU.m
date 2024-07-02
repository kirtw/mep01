ppTXU   ;CKW/ESC i20mar24 umep./  rppar1/ ;2024-0320-92;Audit TK() tokt's vs GRt()
;
;
;;tokFL:tkcod,tks,tkcs,tkce,tkri_TKv(tki)
top  NEW Q,DD  I $$arg^pps("TKv,GRt,GRv") G Qb
     S ts=0
     F tki=1:1:TKv S tkcod=$G(TKv(tki,"tkcod")) S tokt=tkcod DO  ;
       .I tokt="" D bug^dv("TKv(tki, missing tokt GRv(tokt ","DD,tki,TKv") G Qb
       .D GFL^kfm(tokFL) ; TKv(tki,  : tkcod~tokt, t
       .S DD=$D(GRt(tokt))
       .I DD=0 D ER("Undef tokt in GRt(  ")
       .; audit tks, tkcs, tkce
       .I tkcs'?1N,tkcs'=(ts+1) D ER("tkcs Start") ;Err
       .I tkce'?1.2N D ER("tkce End") ;Err
       .I tks="" D ER("tks null") ;Err
       .I $L(tks)'=(tkce-tkcs+1) D ER("tks") ;Err
       .S ts=tkce
     W:$X ! W "Audit of TK(tki,  tki end:",tki," completed.  ok?",!
     Q
;*
ER(M)   W:$X ! D b^dv("Err ","M,tks,tkcs,tkce,tkcod,tokt,tkri")
        Q
;*
Q      Q:$Q Q Q:Q=""
Qb     D b^dv("Err ^"_$T(+0),"Q,RG,devrg,gi,grab,gran") Q:$Q Q  Q
;*
