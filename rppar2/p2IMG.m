p2IMG ;CKW/ESC i5dec22 umep./ rppar2/ ;2024-0503-32; ^p2* ^p2PAR table mumps parser- FL vars
;  audFL^  Audit copies
;  IKILLFL^ Kill loc var for ALL fields (not *FL vars)

;* : VVL, *FL
top   NEW Q,fi,xFL,FL,T,x2  S Q=""
       S VVL="grabFL,granFL,tokFL,tokgrFL,pt2FL,sgrabFL,sgranFL"  ;comma list labels/*FL names
            ; remove pt1FL
       FOR fi=1:1:$L(VVL,",")  DO  ;
         .S xFL=$P(VVL,",",fi)
         .I xFL="" D bug^dv Q
         .S @xFL=""  ; def init
         .S T=$T(@xFL) I T="" D b^dv("Err xFL("_xFL_") in VVL (^p2IMG) no label","T,xFL,VVL,fi")
         .S T=$P(T,";;",2),x2=$P(T,":"),FL=$P(T,":",2,99)
         .I x2'=xFL D b^dv("Err src name","x2,xFL,T,fi,VVL") Q
         .S @xFL=FL
       G Q
;*  Init All loc vars in *FL  KILL or Set Null
IKILLFL  D ^p2IMG ; VVL,*FL
       NEW vi,vn,xFL,FL
       FOR fi=1:1:$L(VVL,",") S xFL=$P(VVL,",",fi) DO  ;
         .S FL=$P(xFL,"_")
         .F vi=1:1:$L(FL,",") S vn=$P(FL,",",vi) KILL @vn  ;; KILL vs Set Null?
       Q
;*
tokFL  ;;tokFL:tkcod,tks,tkcs,tkce,tkri_TKv(tki)
tokgrFL ;;tokgrFL:ttde,ttri_GRt(tokt)
;
grabFL ;;grabFL:grde,grnun,grri_GRv(grab)
granFL ;;granFL:grulst,gropsr_GRc(gran)
;
;;  Stack STK(StkP) in ^p2PAR  All grab vars incl grab, ditto All gran vars incl gran
sgrabFL  ;;sgrabFL:grab,sty,grde,grri,grts,grte,grnun,Gn,grun_STK(StkP)  ;StkP odd
sgranFL  ;;sgranFL:gran,sty,gnts,gnte,grulst,gropsr,Rn,tok_STK(StkP)    ; StkP even, sty="gran"
;
pt2FL  ;;pt2FL:gran,gnts,gnte_PTx(StkP,gnts)
;
;*
Q      Q:$Q Q Q:Q=""
Qb     D b^dv("Err ^"_$T(+0),"Q,VVL,") Q:$Q Q  Q
;*  
;
;*   By caller, once each startup ^cmdMenu    
audFL D ^p2IMG,IB^mepIO,^kfmUafl(PB)  ; 2nd arg Save Edited MRou code (not yet)
      Q
;*       
;*


