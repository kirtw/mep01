p2IMG ;CKW/ESC i5dec22 umep./ rppar2/ ;2024-0503-32; ^p2* ^p2PAR table mumps parser- FL vars
;  audFL^  Audit copies
;  IKILLFL^ Kill loc var for ALL fields (not *FL vars)

;* : VVL, *FL
top   NEW Q,fi,xFL,FL,T,x2  S Q=""
       S VVL="grabFL,granFL,tokFL,tokgrFL,pt2FL,sgrabFL,sgranFL,stokFL"  ;comma list labels/*FL names
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
;*  Not token, but Input Terminals sic name  -->trmFL  (or tkiFL - not good for searching)
tokFL  ;;tokFL:tkcod,tks,tkcs,tkce,tkri_TKv(tki)
tokgrFL ;;tokgrFL:ttde,ttri_GRt(tokt)
;
grabFL ;;grabFL:grde,grnun,grri_GRv(grab)
granFL ;;granFL:grulst,gropsr,grtt_GRc(gran)
;
;;  Stack STK(StkP) in ^p2PAR  All grab vars incl grab, ditto All gran vars incl gran
;* StkP odd for grab, even for gran
sgrabFL  ;;sgrabFL:grab,sty,grnun,grts,grte,grde,grri_STK(StkP)
;*  remove gnts,gnte,
sgranFL  ;;sgranFL:gran,sty,grulst,nlst,Rn,tok,gropsr,gropsyn,grstr_STK(StkP)
stokFL   ;;stokFL:gnn,sty,gtki_STK(StkP)
;
pt2FL  ;;pt2FL:gran,grts,grte_PTx(StkP,grts)
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
audFIX D ^p2IMG,IB^mepIO S PB=PB_"r*/p2*.m"
       D ^kfmUafl(PB)  ; 2nd arg Save Edited MRou code (not yet)
      Q
;*


