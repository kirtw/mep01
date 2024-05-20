ppITK(TLab) ;CKW/ESC i7mar24 umep./ rppar1/ ;2024-0307-60;Create TKv() fudge from $TEXT


;;
      I $G(TLab)="" S TLab="TK1"
;*
top   KILL TKv S tki=0,TKv=0
      F I=1:1 S T=$T(@TLab+I),L=$P(T,";;",2,99) Q:L["***"  Q:L=""  DO  ;
        .I L["LM:" S LM=$P(L,":",2,999),TKv(0,"LM")=LM Q
        .S L2=$$DSP^dvc(L)
        .  I L2'=L D ^dv("dbl spaces in $T ","L2,L,tki,TLab,I") S L=L2
        .S tkcod=$P(L," "),tks=$P(L," ",2) S:tks="" tks=" "   ; TOIcustom
        .S tkcs=$P(L," ",3),tkce=$P(L," ",4)
        .S tki=tki+1
        .D SFL^kfm("tkcod,tks,tkcs,tkce_TKv(tki)")
        .S TKv=tki
      W:$X ! W "Finished ^"_$T(+0)_"  tki:",$G(tki)," codes",!!
      Q
        
TKC  ;; Fudge TKv()  tkcod tks 
;;Swd. S 1 1
;;sp1. _ 2 2
;;Vna. X 3 3
;;= = 4 4
;;Vna. Y 5 5
;;eol.
;  ***

TK1  ;; Fudge simplest TK  K X,Y
;;LM:K X;test;;
;;Kwd. K 1 1
;;sp1. _ 2 2
;;Vna. X 3 3
;;,  , 4 4
;;Vna. Y 5 5
;  ***
;*
TK0  ;; Fudge simplest TK  K X
;;LM:K X;test;;
;;Kwd. K 1 1
;;sp1. _ 2 2
;;Vna. X 3 3
;  ***
