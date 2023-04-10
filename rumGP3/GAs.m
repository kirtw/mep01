GAs ;CKW/ESC i25jun22 gmma/ rmGP3/ ;20220625-63;SR of GA/GP MGbl Doc Utilities
;
;
;
top    NEW Q S Q="No Entry ^GAs" Goto Qbug
;
Q    Q:$Q Q I Q'="" D qd
     Q
Qbug D qd  Q:$Q Q  Q
;*
qd   D b^dv("Err ^"_$T(+0),"Q,VL")
     Q
;
;*  See primary in ^mws  of MBR project
;*  trial arg  -- arg^mws, arg^dvs   or other, M,VL $$ only, null ok
;*  Sets Q null or err, saves caller from having to do this, sic bug if ;out
;;  label(arg1,arg2) NEW Q I $$arg^mws("arg1,arg3") Goto Q ;shared exit
;;    Q is set null if args ok, not returned in $$, as 0/1 returned as $$ for branching
;;  Null ok, set null if UNDEF   arg2:null   extend super list colon2 props --- ?
;*  also sets Q null or Err, returns $$ branch 0 ok, 1 Err (ie $$~ Q'="" )
arg(VL)  NEW ARY,FL,vn,vi S Q=""  ; Q is NOT NEWed here, but set null or returned
        I $G(VL)="" S Q="Null arg VL" Goto Qa
        S ARY=$P(VL,"_",2),FL=$P(VL,"_")  ; tolerate, not reqd
        S argFL=FL,vi=0
        I FL'="" F vi=1:1:$L(FL,",") S vn=$P(FL,",",vi) DO  ;
          .I $D(@vn)=0 S Q=Q_"$$arg "_vn_" UNDEF," Q
          .I $G(@vn)="" S Q=Q_vn_" Null," Q
          .;further tests ?  def vs null, ARY vs base node undef, null ?
        S argNvi=vi
Qa      S argQ=Q,argRet=(Q'=""),argDolQ=$Q,argVL=VL
        I Q'="" D ^dvstk,b^dv(Q,"Q,argVL")
        Q Q'=""  ; $$ is not Q, but 0/1 if ERR for branching I $$arg
;*  FLVL :  VGN(Gna)=Gid
VXN(FLVL) NEW Q I $$arg^GAs("FLVL") Goto Qbug
        KILL VGN ; or not, accumulate ok
        F fi=1:1:$L(FLVL,",") S g=$P(FLVL,",",fi) I g'="" DO  ;
          .S FLg=$G(@g),Gid=$P(FLg,"_",2)
          .S Gna=$P(Gid,"(")
          .S VGN(Gna)=Gid
        Goto Q
;*
;*      Scrape Vars for vn:*FL (or *VL)  and two _pieces ?
;*   local vars : VVA(gFL)=gFL temp -> FLVL  and VNgv(Gid,vn)=vi ^/ Gidd
GetFLVL  NEW Vs,VVA  ZSH "V":Vs  ; Vs("V",vi)="<vn>="val"  incl array nodes
      F vi=1:1 S VE=$G(Vs("V",vi)) Q:$D(Vs("V",vi))=0  DO  ;
        .S VE=$G(Vs("V",vi))
        .S vn=$P(VE,"="),val=$P(VE,"=",2,99)
        .I vn["(" Q
        .I vn["FL",$P(vn,"FL",2)="" DO  ;
           ..S gFLna=vn
           ..S VVA(gFLna)=val
           ..S gFL=vn,sfl=@vn,FL=$P(gFL,"_"),Gid=$P(gFL,"_",2)
           ..F fi=1:1:$L(FL,",") S vn=$P(FL,",",vi),VNgv(Gid,vn)=vi_"^/"_Gid
      S g="",FLVL="" F vi=0:1 S g=$O(VVA(g)) Q:g=""  S FLVL=FLVL_","_g
      S FLVL=$E(FLVL,2,999) ; Remove leading comma
      Q
;* expand gFLna : gFL, FL, Gid, Gna, vnid
XFL(gFLna)  NEW Q,D I $$arg("gFLna") Goto Qbug
      I '$D(@gFLna) S Q="Undef *FL "_gFLna Goto Qbug
      S gFL=$G(@gFLna) I gFL="" S Q="Err gFLna in XFL" Goto Qbug
      S FL=$P(gFL,"_"),Gid=$P(gFL,"_",2)
        I FL[":" DO  ; what?, vn translation, meta fields  
          .D b^dv("Err handling : sub in *FL","gFL,gFLna,FL")    
      D vnid(Gid)
      Q
;*  Gid : vnid, Gna
vnid(Gid) NEW Q I $$arg("Gid") Goto Qbug
    S vnid=$P($P(Gid,"(",2),")")
      I vnid["," S Q="Only one subscript handled."
    S Gna=$P(Gid,"(")
      I Gna'?.1"^"1A.10AN S Q=Q_" Gna from Gid( '"_Gna_"' ?"
    Goto Q
;*

