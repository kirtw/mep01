ep4G0  ;CKW/ESC i31oct22  km3a/ umbr./ rmw1/ ;20230111-50;Start mep mumps earley Parser, Compile Grammar
;  Compile Grammar  $T (No Array intermediate yet) -> GRi(ruid)=RPgr, Gxi(
;
;
top   D ^ep2IMG  ; grGL, itemFL
        ; debug later D TT^ep2IMG  ; T^dws equivalent
      S Q=$$devlog^devIO("MEP-log.html","ww2mbr/") I Q'="" D bug^dv Q
      USE devlog
      ;D ^epGRdemo  ; Init Demo Grammar GRi(rusq)= RPgr -_-> ru*  GRk(), Gxi()
        D WGR^ep2W  ;Display Grammar GRk(ruid)
      ; S Ins="1+(2*3-4)"
      ; D ^ep4IN(Ins)  ; : INc(Ip),INty(Ip)
       D WIN^ep2W  ; Display Ins, INc(), INty()
      ;
      D ^ep4PAR  ;vers 4
      ;D PT^ep2W   ; Dis parse tree
      D clog^devlog
      Q
;*      
;* Common Exit
Q      Q:$Q Q D:Q'="" qd Q
Qb     D qd Q:$Q Q Q
qd     D b^dv("Err ^"_$T(+0),"ruid,ruab,ruLst")
       Q
;*
;*
FLg1  ;;grFL:runa,ruab,ruty,ruLst,nLst,tokCL,nLCL,Lna,rde_GRk(ruid)
;
;*  * * *

;*
      

