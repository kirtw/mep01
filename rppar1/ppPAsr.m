ppPAsr ;CKW/ESC umep./ rppar1/ ;2024-0327-97; Increment srs Iin  tki
;
;

;;stkFL:grabS,Lev_STK(StkP)
PSH(StkP)  S Lev=StkP S grabS=grab
    D SFL^kfm(stkFL)  ; Save, not actually stack function vs recursive save Tgrab/Tgran
    Q
POP(StkP)  ;  actually StkP=StkP-1  but dont reset loc vars ---
    D GFL^kfm("grabS,Lev_STK(StkP)") ; STK(StkP,
    ;
    Q
WSTK  D stb^dv3("STK","StkP:4,grab:10,grun:4,gran:12,grulst:40,Rn:4")
    NEW grab,grun,gran,grulst,Rn
    F STK=1:1:STK DO  ;
      .D GFL^kfm(stkFL) ; STK(StkP,
      .D bln^dv3("STK")
    W ! Q
;*
;*  trq
trc(M,VL) I $$arg^pps("M,VL") D bug^dv Q
    S trq=trq+1
    I gran="KCmd.1" D b^dv("Log trc","M,StkP,trq,grab,gran,Rn,grulst")
    Q
;*
;;tokFL:tkcod,tks,tkcs,tkce_TKv(tki)
;*   Bump Input token :  QI, tki', tkcod~TKc,tks,tkcs,tkce
Iin  NEW Q I $$arg^pps("tki") G Qb
     S tki=tki+1
     I tki>TKv S tki="",QI="End of TKv(tki" D NFL^kfm(tokFL) G Q  ;Done, no more Input
     D GFL^kfm(tokFL) ; TKv(tki
     S TKc=tkcod
       I TKc="" D bug^dv("Log TKv Done.","TKc,grab,Rn,grulst,tok")
     W:$X ! W "--nxt In:",tki,"  ",tkcod," ",tks,!
     S QI=""
     G Q
;* 
;*
Q      Q:$Q Q Q:Q=""
Qb     D b^dv("Err ^"_$T(+0),"Q,RG,devrg,gi,grab,gran") Q:$Q Q  Q
;*
;*  Bump Rn ptr into grulst
;*  Rn', grulst : QN, Rn', toty, tok
IRn  NEW Q I $$arg^pps("Rn,grulst") G Qb
     S Rn=Rn+1,tok=$P(grulst," ",Rn),toty=""
     I tok="" S Rn="",QN="" G Q
     S toty="R" I tok?1P!(tok[".") S toty="T"
     G Q
;*  Bump grun/gran
;*  grun', grnun : QN, grun', gran, grulst
Iun  NEW Q I $$arg^pps("grun,grab,grnun") G Qb
     S grun=grun+1,QN=grun ; in progress
     I grun>grnun S QN="",grun="" G Q
     S gran=grab_"."_grun
     D GFL^kfm("grulst",granFL)
     G Q
;*
