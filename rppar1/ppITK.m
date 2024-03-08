ppITK ;CKW/ESC i7mar24 umep./ rppar1/ ;2024-0307-60;Create TKv() fudge for S X=Y


;;
;*
top   KILL TKv S tki=0,TKv=0
      F I=1:1 S T=$T(TKC+I),L=$P(T,";;",2,99) Q:L["***"  Q:L=""  DO  ;
        .S tkcod=$P(L," "),tks=$P(L," ",2) S:tks="" tks=" "
        .S tkcs=$P(L," ",3),tkce=$P(L," ",4)
        .S tki=tki+1
        .D SFL^kfm("tkcod,tks,tkcs,tkce_TKv(tki)")
        .S TKv=tki
      W:$X ! W "Finished ^"_$T(+0)_"  tki:",$G(tki)," codes",!!
      Q
        
TKC  ;; Fudge TKv()  tkcod tks 
;;Swd. S 1 1
;;sp1. _ 2 2
;;Vwd. X 3 3
;;= = 4 4
;;Vwd. Y 5 5
;;eol.
;  ***
