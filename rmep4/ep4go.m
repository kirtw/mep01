ep4g0  ;CKW/ESC i31oct22  km3a/ umbr./ rmw1/ ;20230111-50;Start mep mumps earley Parser, Compile Grammar
;  Compile Grammar, Read toi, Compile -> GRk(ruid)=RPgr, Gxi(
;
;
top   D ^epaIMG  ; grGL, itemFL
      S Q=$$devlog^devIO("MEP-log.html","ww2mbr/") I Q'="" D bug^dv Q
      USE devlog
      D ^epGRdemo  ; Read Init Demo Grammar from file rmep4/aDemo-Grammar.toi
        D WGR^ep4W  ;Display Grammar GRk(ruid)
        D ^ep4HGR  ;HGen Grammar Page
      ; S Ins="1+(2*3-4)"
      ; D ^ep4IN(Ins)  ; : INc(Ip),INty(Ip)
       D WIN^ep4W  ; Display Ins, INc(), INty()
      ;
      D ^ep4PAR  ;vers 4
      ;D ^ep4PTree  ;Create Parse Tree  PTR
      ;D PT^ep4W   ; Dis parse tree
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
;;grFL:runa,ruab,rugi,ruty,ruLst,nLst,tokCL,nLCL,Lna,rude_GRk(ruid)
;
;*  * * *

;*
      

