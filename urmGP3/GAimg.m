GAimg(FLVL) ;CKW/ESC i25jun22 gmsa/ rmGP3/ ;20220625-08;FLVL to VGN(Gna, VNgv(Gnad,vn), VNv(vn) ? cross Gna
;
; top Falls into FLVL (No arg)
;   FLVL from ^mwIMG  is list of super FL vars, jst set by ^mwIMG
;   Gid is MGbl ref and *id variable, eg ^ZWRM(mrid), $P2_ of super FL list var.
;   Gna is MGbl name, up to parenthesis
;   VNgv(Gid,vn) is index of fields expected in an MGbl structure, incl a subscript
;   VNv(vn   ?
;*  FLVL, @gFLna : VNv(vn), VNgv(Gid,vn), VGN(Gna,gFLna)=gFL
FLVL   NEW Q I $$arg^GAs("FLVL") Goto Qbug
      KILL VCgv,VNv,VGN     NEW gFLna,vi,FL,Gid,Gna,gFL
      F vli=1:1:$L(FLVL,",") S gFLna=$P(FLVL,",",vli)  I gFLna'=""  DO  ;
        .D XFL^GAs(gFLna) ; gFLna : Gid, Gna, FL
        .   I Q'="" Goto Qbug ;gFLna in FLVL named var undef ?
        .S VGN(Gna,gFLna)=gFL ;LookUp by MGb name
        .;S VGN(Gna)=Gid  ; last if mult, should be same Gid
        .F vi=1:1:$L(FL,",") S vn=$P(FL,",",vi) I vn'="" DO  ;
           ..S VNgv(Gna,vn)=vi_"^/"_Gid
           ..;S VNv(vn)=vi_"^/"_Gid
Q     Q:$Q Q  I Q'="" D qd
      Q
Qbug  D qd  Q:$Q Q  Q
qd    D b^dv("Err ^"_$T(+0),"Q,zrid,FLVL,VNgv")
      Q

