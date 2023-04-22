GAscan(Gna) ;CKW/ESC i29jun22 gmsa/ rmGP3/ ;20220629-55;Scan One MGbl for vn in records
;  MGbl or Array ?,  Records  (not Zero Node here)
;  Gid has vnid and Gna used in scan
;  remove use of Gid, vnid in scan
;
;   Scan One Mgb- Gid, count records, which fields in each
;   Gid, VNv(vn : (vnid, Gna
top   NEW Q I $$arg^GAs("Gna") Goto Qbug
      I $G(Gna)="" S Q="No Gna from Gid" Goto Qbug
      I $D(@Gna)=0 S Q="MGbl/ARY "_Gna_"' is UNDEF." Goto Q
      G Gscan ; continue vs fall thru...(sic)
;;   G, : VCgv(Gna,vn) count or Abstraction All,None, Some n/%
;*    vnid, Gna : nid  num records, VCgv(vn)= counts,  VNabs(vn) = {All, None, %} 
Gscan  KILL VCgv(Gna),VAgv(Gna),VAcv
     S scid=0 F nid=0:1 S scid=$O(@Gna@(scid)) Q:scid=""  DO  ;
Rec    .S vn=0 F vi=0:1 S vn=$O(@Gna@(scid,vn)) Q:vn=""  DO  ;
vn       ..S VCgv(Gna,vn)=$G(VCgv(Gna,vn))+1  ;just count nodes by name
         ..S val=$G(@Gna@(scid,vn))
         ..; val type, count by type n, i, str $L<10, long str avg length
     S ^ZWG(Gna,"nid")=nid
     I 'nid  S Q="No records." Goto Q
GSva ; Now show VCgv(vn) counts, vs VAgv(Gna,vn)  type codes {All,None,Some,Stray, ...}
     ;    and Sort by codes VAcv(vc,vn)=""
     S vn="" F vi=0:1 S vn=$O(VCgv(Gna,vn)) Q:vn=""  DO  ;
       .S n=$G(VCgv(Gna,vn)),vc=""
       .I n=nid S vc="All"
       .E  I 'n S vc="None"
       .E  S vc="Some"
       .S VAgv(Gna,vn)=vc,VAcv(vc,vn)=""
       .I $G(VNgv(Gna,vn))="" S VAcv("Stray",vn)=n
Q    Q:$Q Q  I Q'="" D qd
     Q
Qbug  D qd Q:$Q Q  Q
qd   D b^dv("Err ^"_$T(+0),"Q,Gid,vnid,Gna,VCgv")
     Q
;*     
DVC  I $D(VAcv("None")) D VNone
     I $D(VAcv("All"))  D VAll
     I $D(VAcv("Some"))  D VSome
     I $D(VAcv("Stray")) D VStray
     Q
;*
;*
VNone   USE $P W:$X ! W "No vals for the following-",!
        S vn=0 F vi=0:1 S vn=$O(VAcv("None",vn)) Q:vn=""  W vn,", " W:$X>80 !,"  "
        Q
VAll    USE $P W:$X ! W "Normal, all defined- ",!
        S vn=0 F vi=0:1 S vn=$O(VAcv("All",vn)) Q:vn=""  W vn,", " W:$X>80 !,"  "
        Q
VSome   USE $P W:$X ! W "Some, not all- ",!
        S vn=0 F vi=0:1 S vn=$O(VAcv("Some",vn)) Q:vn=""  DO  ;
        .S np=vn_"?",nv=$G(VAcv(vn))
        .I nv,nid S np=(nv/nid*100\1)_"%"
        .W vn," - ",np," " W:$X>80 !,"  "
        Q
VStray  USE $P W:$X ! W "Stray fields, not in any *FL list-",!
        S vn=0 F vi=0:1 S vn=$O(VAcv("Stray",vn)) Q:vn=""  DO  ;
          .S n=$G(VAcv("Stray",vn))
          .W:$X ! W "  ",vn,"  x",n," occurrences."
        Q
;*
;*      * * * * *  test/dbg  * * * * *
;*   
dbg  S Gna="^ZWRM" D ^GAscan(Gna),^GAH(Gna)
     S Gna="^ZWCB" D ^GAscan(Gna),^GAH(Gna)
     S Gna="^ZWD" D ^GAscan(Gna),^GAH(Gna)
     S Gna="^ZWZ" D ^GAscan(Gna),^GAH(Gna)
     ;
     zwr VCgv
     D DVC
     Q
     
