GA(FLVL) ;CKW/ESC i23jun22 gmma/ rbrzm1/ ;20220624-05; Analyze vn fields of MGbl in *FL
;Should be comma list (or one) of *FL names or one, but name, NOT FL list itself
;
top  NEW Q I $$arg^GAs("FLVL")  Goto Qbug     
     D ^GAimg(FLVL)  ; : VNv, VNgv   also VGN(Gna,)
     D la^dv
     D ^dv("Log post GAimg","FLVL") W !!
     S Gloop="" F gfi=0:1 S Gloop=$O(VNgv(Gloop)) Q:Gloop=""  DO  ;  was VGN  dupl
       .S Gna=Gloop 
       .D ^dv("Log ^GA Gna start loop","Gna")
       .D ^GAscan(Gna)
       .D la("Post GAscan Calc VCgv, VAgc, ")
       .D ^GAH(Gna)  ; HGen One MGbl  VCgv(), VCt()
       .S ^ZWG(Gna,"devHmgb")=devHmgb
       .D la("End of Gna Loop")
     USE $P W:$X ! W "Completed -",$G(devHmgb),!
     Q
;*  debug log sr, Show all ARYs
la(M)   USE $P W:$X !! W !!,$G(M),! D la^dv
     D ^dv("Log ^"_$T(+0),"M,Gna,devHmgb")
     Q
;*
Q    Q:$Q Q I Q'="" D qdv
     Q
Qbug D qdv Q:$Q Q  Q
;*
qdv  D b^dv("Err ^GA Mgbl Audit","Q,Gna,Gid,G0,gFL,gFLna")
     Q
;*
;*   Gna  : Zsum  comment
ZNA    S G0=Gna_"(0)",Zsum="Zero Node "_G0_"  " 
       I 'vin S Zsum=Zsum_" has no records/*id nodes."
       I vin S Zsum=Zsum_" has "_nid_" nodes;"  D WG0
       Q
;*
WGN  USE $P W:$X ! W Zsum,!
     I 'nid W "  No *id nodes.",!  Q
     W "  ",nid,"  nodes present, with ",nvn," distinct fields.",!
     W Vall,!,Vno,!,Vp,!
     Q
;*
WG0  W "Node Zero-  ",Zsum,"  " I '$D(VNc) W " Undef.",! Q
     zwr V0 W !!
     Q
;*
mbr  D GA^mwZdoc
     Q     
;*     
       
     
