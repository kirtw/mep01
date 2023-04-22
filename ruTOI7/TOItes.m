TOItes  ;CKW/ESC  i16feb18 ; 20180215-56 ; TOI Tests - Std  /*/ lines
  ;
  ; RefBy:  uCal Menu ttoi.
TAcq   D TtoiB^cqMa
     Q
;*    * * * * * * *
;  In context, totally data driven, expected values
;  Line Syntax /*/  start
;  vn=val   opt quotes for embedded spaces
;
;*   L2  dsp/lc,  L0, ri, rFil
A    I $G(L2)="" D bug^dv Q
     I $E(L2,1,3)'="/*/" D b^dv("Expected caller to find /*/ starting L2","L2,ri,rFil") Q
     S L3=$E(L2,4,999)  KILL TD
     MERGE TD=^QD(lid)
     F wi=1:1:$L(L3," ") S wd=$P(L3," ",wi) DO
       .S vn=$P(wd,"="),val=$P(wd,"=",2)
       .I val="" Q
       .I vn'?1L.6LN D b^dv("vn=val fmt ?","vn,val,L3") Q
       .    ;S EV(vn)=val
       .S toiv=$G(TD(vn))
AT     .I toiv'=val D ERR
       .; I toiv=val D b^dv("Log TOItes ","vn,val,toiv,ri,rFil")
     Q
;*
ERR   D b^dv("Err exp val vs toiv-","vn,val,toiv,L0,ri,rFil")
      Q
