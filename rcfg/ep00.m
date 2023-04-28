ep00  ;CKW/ESC i27apr23  umep./ rcfg/ ;20230427-80;Test Update timestamp on first line
;   via ^devRM(devm)  and ^devWM(devm)
;
;
;
top  NEW Q S Q=""
     D ^epaIB
     S devm=PB_"rcfg/"_"ep11.m"  ; Fodder MRou
     S Q=$$^devRM(devm) I Q'="" Goto Qb
     S L1old=$G(RM(1))
     S Q=$$^devWM(devm) I Q'="" Goto Qb
     S L1new=$G(RM(1))
     W !!,L1old,!,"->",!,L1new,!!
     Q
;*
;* Common Q
Q    Q:$Q Q Q:Q=""  ; else fall thru Q not null
Qb   D qd Q:$Q Q Q
qd   D b^dv("Err ^"_$T(+0),"Q,SFL,GFL,FL,G,vn,val,vi") Q
;*
;*

     
