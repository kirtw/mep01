ppIMG ;CKW/ESC i5dec22 umep./ rcfg/ ;2024-0302-91; ^pp*table mumps parser- FL vars
;  rev primary copy like copy copies
;

;*
top2   NEW Q,VVL,fi,xFL,FL,T,x2  S Q=""
       S VVL="grulFL,tokFL,granFL"
       F fi=1:1:$L(VVL,",")  DO  ;
         .S xFL=$P(VVL,",",fi)
         .I xFL="" D bug^dv Q
         .S @xFL=""  ; def init
         .S T=$T(@xFL),T=$P(T,";;",2),x2=$P(T,":"),FL=$P(T,":",2,99)
         .I x2'=xFL D b^dv("Err src name","x2,xFL,T,fi,VVL") Q
         .S @xFL=FL
       G Q
;*
tokFL  ;;tokFL:tkcod,tks,tkcs,tkce_TKv(tki)
grulFL ;;grulFL:grde,grnun,grri_GRv(grab)
granFL ;;granFL:grulst,gopsr,grtt_GRc(gran)
;
;*
Q      Q:$Q Q Q:Q=""
Qb     D b^dv("Err ^"_$T(+0),"Q,RUL,TOK,Rn,QRU") Q:$Q Q  Q
;*  
;
;*   By caller, once each startup ^cmdMenu    
audFL D ^ppIMG,IB^mepIO,^kfmUafl(PB)  ; 2nd arg Save Edited MRou code (not yet)
      Q
;*       
;*


