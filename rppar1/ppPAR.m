ppPAR ;CKW/ESC i7feb24 umep./ rppar1/ ;2024-0327-97;mumps table mumps parser
;  TKv(tki)  Input tokenized
;  GRv(   GRt( ...
;   : PX(
;
;;tokFL:tkcod,tks,tkcs,tkce_TKv(tki)
top     NEW Q I $$arg^pps("TKv,GRv,GRc,GRt") G Qb
          KILL (TKv,GRv,GRc,GRt)  ; debug
        D ^ppIMG
        D ^ppPAinit
        S (QS,QT,QN,QB,QI,QA)="???"  ; just in case  Null pass, not null fails
        S tki=0 D Iin^ppPAsr ; TKv(tki,  :  tki=1,  -> tkcod,tks, tkcs,tkce 
        S grab="mCmds",Rn=1,grun=1  ;Starting top rule 'mCmds', ptr Rn
        ;
        S Q=$$^ppPAgrab(grab,StkP) ; : QB
        I QB'="" D b^dv("Err Final/Initial grab mCmds ","QQ,QB,grab")
        ; gstr ?  
        G Q  ;top Done, line LM and TKv(tki,  -> PTx, etc. 
;*
;;pt1FL:Lev_PTx(pti)
;;pt2FL:gran,grts,grte,grstr_PTx(pti,tki)        
;*

;*
Q      Q:$Q Q Q:Q=""
Qb     D b^dv("Err ^"_$T(+0),"Q,RG,devrg,gi,grab,gran") Q:$Q Q  Q
;*
