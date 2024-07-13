p3PSH ;CKW/ESC i11jul24 umep./ rppar2/ ;2024-0711-60;OBS PSH POP srs
;from ^p3PAR
;
;
;  Mainly StkP  +1 for grab, +1 for gran
;
;*
Q      Q:$Q Q Q:Q=""
Qb     D b^dv("Err ^"_$T(+0),"Q,StkP,grab,gran,QB,QN,QT") Q:$Q Q  Q
;*
xPSH(M) S M=$G(M,"argPSH") D PSHb(M),PSHn Q  ; ,PSHt  
POP2(M) S M=$G(M,"argPOP") ;D POPn,POPb(M)   Q  ; POPt,
       S StkP=StkP-2
       Q
;*       
;;sgrabFL:grab,sty,grnun,Gn,grun,grts,grte,grde,grri_STK(StkP)
PSHb(M)  S sty="grab" S M=$G(M)
    S StkP=StkP+1 
    D SFL^kfm(sgrabFL)  ; Save
    W:$X ! W "PSHb- grab:",$G(grab),"#",StkP,!
    Q
;*  
;;sgranFL:gran,sty,grulst,nlst,Rn,tok,gropsr_STK(StkP)
PSHn(M) S sty="gran"  S M=$G(M)
    S StkP=StkP+1 
    S Lev=StkP
    D SFL^kfm(sgranFL) ; : STK(StkP)
    W:$X ! W "PSHn by ",M," gran:",$G(gran),"#",StkP,!
    Q
;;stokFL:gnn,sty,gtki_STK(StkP)
xPSHt(M)   S M=$G(M) S sty="tok" S gtki=$G(tki)
    S StkP=StkP+1
    D SFL^kfm(stokFL)
    W:$X ! W "PSHt-",M," gnn:",$G(gnn),"#",StkP,!    
    Q
;*  
;*
xPOPb(M)   S M=$G(M)
    I StkP<1 D b^dv("PSHb Sync-StkP not odd ","StkP")
    D GFL^kfm(sgrabFL) ; STK(StkP,
    W:$X ! W "POPb-",M," grab:",$G(grab),"#",StkP,!
    I sty'="grab" D bug^dv("Stk sync pop/push sty grab","sty,M,StkP,grab,gran")
    S StkP=StkP-1
    Q
xPOPn(M)  S M=$G(M) ;  actually StkP=StkP-1  but dont reset loc vars ---
    I StkP<2 D b^dv("Err Stk UnderFlop pop","StkP") G Qb
    D GFL^kfm(sgranFL) ; STK(StkP,
    W:$X ! W "POPn-",M," gran:",$G(gran),"#",StkP,!    
    I sty'="gran" D ^WSTK,^dvstk,b^dv("Stk sync pop/push sty gran","M,sty,StkP,grab,gran")
    S StkP=StkP-1
    Q   
xPOPt(M)  S M=$G(M,"argPOPt")
    I StkP<2 D b^dv("Err Stk UnderFlop pop","StkP") G Qb
    D GFL^kfm(stokFL)
    W:$X ! W "POPt-",M," gnn:",$G(gnn),"#",StkP,!
    I sty'="tok" D ^dvstk,b^dv("Err POPt sty ","sty,M,StkP,gnn")
    S StkP=StkP-1
    Q      
