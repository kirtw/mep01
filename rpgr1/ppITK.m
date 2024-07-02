ppITK(TLab) ;CKW/ESC i7mar24 umep./ rppar1/ ;2024-0307-60;Create TKv() fudge from $TEXT


;;
      I $G(TLab)="" S TLab="Texp1"
;*
top   KILL TKv S tki=0,TKv=0
      F I=1:1 S T=$T(@TLab+I),L=$P(T,";;",2,99) Q:L["***"  Q:L=""  DO  ;
        .I L["LM:" S LM=$P(L,":",2,999),TKv(0,"LM")=LM Q
        .S L2=$$DSP^dvc(L)
        .  I L2'=L D ^dv("dbl spaces in $T ","L2,L,tki,TLab,I") S L=L2
        .S tkcod=$P(L," ")
        .S tkcs=$P(L," ",2),tkce=$P(L," ",3)
        .S tks=$P(L," ",4) S:tks="" tks="_"   ; TOIcustom
        .S tki=tki+1
        .D SFL^kfm("tkcod,tks,tkcs,tkce_TKv(tki)")
        .S TKv=tki
      W:$X ! W "Finished ^"_$T(+0)_"  tki:",$G(tki)," codes",!!
      Q
;*
Texp1  ;; Fudge simplest expr tests
;;LM:a+b/2;;basic expr
;;Vna. 1 1 a
;;+    2 2 +
;;Vna. 3 3 b
;;/    4 4 /
;;Npat. 5 5 2
;  ***
;*
TK1  ;; Fudge simplest TK  K X,abc,Y,Z
;;LM:K X;test;;
;;Kwd. 1 1 K
;;sp1. 2 2 _
;;Vna. 3 3 X
;;,    4 4 ,
;;Vna. 5 7 abc
;;,    8 8 ,
;;Vna. 9 9 Y
;;,    10 10 ,
;;Vna. 11 11 Z
;  ***
;*

