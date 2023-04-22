GAmod  ;CKW/ESC i25jun22 gmma/  rmGP3/ ;20220625-94;Modules for MGbl Doc Generation
;
;
;
top    BREAK  HALT  ; No ^GAmod ? yet
;
;*    Here  vs ^mwZdoc
mbr    KILL
       D ^mwIMG
       ;D ^GAimg(FLVL)  ; :  VNv(vn, VVG(Gid,gFLna)
       D AllScan  ; FLVL, @gFLna : VCgv  Counts records per vn field
       Q

;*  Scan All Mgbls  VGN(Gna
AllScan  NEW Q I $$arg^GAs("FLVL") Goto Qbug
       ;D ^mwIMG  ; sic vs caller, mpj specific : FLVL
       ;  scan records, then interpret vn at end - D GAimg(FLVL) ; : VNv, VNgv()
       D ^GAimg(FLVL) ; : VNv(vn, VNgv(Gid,vn  ; Expected vn's
       F vvi=0:1 S Gna=$O(VGN(Gna)) Q:Gna=""  DO  ;
         .S gFLna=$G(VGN(Gna))
         .I gFLna="" D bug^dv Q
         .D XFL^GAs(gFLna) ; gFLna, @gFLna Gid, Gna, vnid
         .D ^GAscan(Gid)
         .D ^GAH(Gna)
     ; falls to Q
Q    Q:$Q Q  I Q'="" D qd
     Q
Qbug  D qd Q:$Q Q  Q
qd   D b^dv("Err ^"_$T(+0),"Q,Gid,gFLna,FLVL")
     Q
;*
