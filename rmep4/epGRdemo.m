epGRdemo ;CKW/ESC i14feb23
; File aDemo-Grammar.toi  : RG() of Demo Grammar
;
;*  : RG()  aDemo-Grammar.toi
GR00  S devRG="/home/kw/km3a/umep/rmep4/aDemo-Grammar.toi"
      S Q=$$^devRD(devRG,,"RG") I Q'="" Goto Qb
      Goto Q
;*
;* Common Exit
Q      Q:$Q Q D:Q'="" qd Q
Qb     D qd Q:$Q Q Q
qd     D b^dv("Err ^"_$T(+0),"ruid,ruab,ruLst")
       Q
;*


