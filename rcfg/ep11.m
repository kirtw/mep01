ep11  ;CKW/ESC i27apr23  umep./ rcfg/ ;20230427-86;Test Fodder for MRou edit First Line
;   via ^devRM(devm)  and ^devWM(devm)
;
;
;
top  NEW Q S Q=""
     D ^epaIB
     S devm=PB_"rcfg/"_"ep11.m"
     S Q=$$^devRM(devm) I Q'="" Goto Qb
     S RM(1)="ep11 ;CKW/ESC i27apr23  umep./  rcfg/ ;20230427-81;Fodder MRou First Line Update"
     I 'RM S RM=1
     S Q=$$^devWM(devm) I Q'="" Goto Qb
     Q
;*
;* Common Q
Q    Q:$Q Q Q:Q=""  ; else fall thru Q not null
Qb   D qd Q:$Q Q Q
qd   D b^dv("Err ^"_$T(+0),"Q,SFL,GFL,FL,G,vn,val,vi") Q
;*
;*

     
