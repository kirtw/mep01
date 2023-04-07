dzIB(zroA) ;CKW/ESC i5apr23  gmsa./  rzro3/ ;20230405-50; ^devIB equiv, need in rzro! $ZTRNENV
;  : dist,SB,PB,GB,  MB, W2B
;1. Derive from $zro, tricky/KLUDGE vs my form of $zro
;2. $ZTRN    base on devy  $SB, $PB, $GB, ... 
;
;   See prior IB^dzIMG 
top   NEW Q S Q="" I $G(zroA)'="" D zro G Q
      D ENV
Q     Q:$Q Q  Q:Q=""
Qb    S Q="IB Err ^"_$T(+0) D b^duv(Q,"zroA,dist,SB,PB,GB")
      Q:$Q Q Q
;
ENV   S dist=$ZTRNLNM("ydb_dist") I dist="" S dist=$ZTRNLNM("gtm_dist")
      S zrodevy=$ZTRNLNM("ydb_routines")
      S zgldevy=$ZTRNLNM("ydb_gbldir")
      S EVL="PWD,SB,PB,GB,MB,W2B" F i=1:1:$L(EVL,",") S ev=$P(EVL,",",i) DO  ;
        .S v=$ZTRNLNM(ev)
        .I ev["B" S v=v_"/"  ;env var vs sys var convention adjust for terminal /
        .S @ev=v
      Q
;*
;*  from zro
zro   S dist=$P(zroA," ")
      S x=$P(zroA,"("),ns=$L(x," ")
      I ns=2 S PB=$P($P(x," ",ns),"o/")_"/"
      S nsl=$L(PB,"/"),SB=$P(PB,"/",1,nsl-1)_"/",mpj=$P(PB,"/",nsl)
      S GB=SB_"gmsa/"
      S MB=SB_"gmma/"
      S W2B=PB_"ww2m/"
      I $G(zrid)="",$D(^ZWZ(mpj)) S zrid=mpj
      D b^duv("Log zro^"_$T(+0),"dist,SB,PB,GB")
      Q
;*
;*  PB : kwmpj, LUser, kwsys
kwmpj(PB)  I $G(PB)="" D bug^dv Q
      NEW Q,nsl
      S nsl=$L(PB,"/") I nsl'=6 S Q="err expect PB nsl=6" D bug^duv(Q,"nsl,PB")
      S kwmpj=$P(PB,"/",5)
      S LUser=$P(PB,"/",3)
      S kwsys=$P(PB,"/",4)
      Q
