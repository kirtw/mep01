epGRdemo ;CKW/ESC i14feb23 umep./ rmep4/ ;20230408-52;Read Grammar File, MUMPS to RG()
;  : RG() of MUMPS Grammar
;
;*  : RG()  aDemo-Grammar.toi
GR00  S devRG="/home/kw/km3a/umep/rmep4/aM1-Grammar.toi"  ;MUMPS Elemental
      S Q=$$^devRD(devRG,,"RG") I Q'="" Goto Qb
      Goto Q
;*
;* Common Exit
Q      Q:$Q Q D:Q'="" qd Q
Qb     D qd Q:$Q Q Q
qd     D b^dv("Err ^"_$T(+0),"ruid,ruab,ruLst")
       Q
;*


