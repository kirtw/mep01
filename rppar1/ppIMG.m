ppIMG ;CKW/ESC i5dec22 umep./ rcfg/ ;2024-0302-91; ^pp*table mumps parser- FL vars
;  rev primary copy like copy copies
;  audFL^  Audit copies
;  IKILLFL^ Kill loc var for ALL fields (not *FL vars)

;* : VVL, *FL
top2   NEW Q,fi,xFL,FL,T,x2  S Q=""
       S VVL="grabFL,tokFL,granFL,stkFL,pt1FL,pt2FL"
       F fi=1:1:$L(VVL,",")  DO  ;
         .S xFL=$P(VVL,",",fi)
         .I xFL="" D bug^dv Q
         .S @xFL=""  ; def init
         .S T=$T(@xFL),T=$P(T,";;",2),x2=$P(T,":"),FL=$P(T,":",2,99)
         .I x2'=xFL D b^dv("Err src name","x2,xFL,T,fi,VVL") Q
         .S @xFL=FL
       G Q
;*  Init All loc vars in *FL  KILL or Set Null
IKILLFL  D ^ppIMG ; VVL,*FL
       NEW vi,vn,xFL,FL
       F fi=1:1:$L(VVL,",") S xFL=$P(VVL,",",fi) DO  ;
         .S FL=$P(xFL,"_")
         .F vi=1:1:$L(FL,",") S vn=$P(FL,",",vi) KILL @vn  ;; KILL vs Set Null?
       Q
;*
tokFL  ;;tokFL:tkcod,tks,tkcs,tkce_TKv(tki)
grabFL ;;grabFL:grde,grnun,grri_GRv(grab)
granFL ;;granFL:grulst,gropsr,grtt_GRc(gran)
;
stkFL  ;;stkFL:grabC,grunC,gran,grulst,RnC_STK(STK)
;
pt1FL  ;;pt1FL:Lev_PTx(pti)
pt2FL  ;;pt2FL:gran,grts,grte,grstr_PTx(pti,tki)
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


