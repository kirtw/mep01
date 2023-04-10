dzIzro   ;CKW/ESC i9sep22 km3a/ gmsa/ rzro3/ ;20220909-40;Derive and test existence of rdir - $zro
;
;
top    D III
       D TR(rdLPB0,PB)
       D TR(rdLPB1,PB)
       S zro2=PB_"o("_zro1_") "
       S zro1=" "_PB_"ou("
       D TR(rdLGB,GB)
       D TR(rdLMB,MB)
       S izro=zro2_zro1_")"  ; lib*.so ?
       Q
;*
TR(rdL,BB)  ;
       NEW Q S Q=""
       I $G(rdL)="" S Q="arg-rdL" G Qbug
       I $G(BB)="" S Q="Null BB" G Qbug
       I ($E(BB)'="/")!($E(BB,$L(BB))'="/") S Q="BB fmt" G Qbug
       ;
       F di=1:1:$L(rdL," ") S rdir=$P(rdL," ",di) I rdir'="" D R1(rdir,BB)
       ;
       Q
;*  append rdir to zro1  - accumulating $zro value
R1(rdir,BB)  ;
       S zro1=zro1_" "_BB_rdir
       Q
;*  test rdir for existence and containing at least on mRou *.m file       
T1(rdir,BB)  ;
       S schd=BB_rdir
       S schr=BB_rdir_"*.m"
       S durl=$ZPARSE(schd) I durl="" D b^dv("Err schd","durl,schd,rdir,BB")
       S x=ZSEARCH("^X")  ; clear ptr
       S murl=$ZSEARCH(schr) I murl="" S Q="Empty rdir, no *.m" D b^dv(Q,"Q,murl,schr,rdir,BB") Q
       ; just ck for one mRou.m
       Q
;*
Q      Q:$Q Q Q:Q=""  D qz Q
Qbug   D qz Q:$Q Q Q
qz     D b^dv("Err ^"_$T(+0),"Q,rdL,BB")
       Q
;*
III    S kwsys="km3a",kwmpj="umad"
       S SB="/home/kw/"_kwsys_"/"
       S PB=SB_kwmpj_"/"
       S GB=SB_"gmsa/"
       S MB=SB_"gmma/"
       ;
       S rdLPB0="rcfg"
       S rdLPB1="ra1,rMGR"
       S rdLGB="rzro3 rmgbFL3 rmenu3 rTOI7 rvv rhgen4b rdev3 rd2c rdbget rdve1 rd2vl"
       S rdLMB="r rcfg-gmma rbrzm1 ragmma rkbd1 rmide15 rmFL rns rMIDE rHNMP  rTJ rProto rnav2 rthr rguH rilist rmbs rgrep rTAC rmGP3"
       S zro1=""
       Q
       

;;export ydb_routines="$ydb_dist $PB/o(   \
;;       $PB/ra1 $PB/rcfg $PB/rMGR ) \
;;$PB/ou( \
;;       $MB/r \
;;       $MB/rcfg-gmma \
;;       $MB/rbrzm1 \
;;       $GB/rdve1 \
;;       $MB/ragmma \
;;       $MB/rkbd1 \
;;       $MB/rmide15 \
;;       $MB/rmFL \
;;       $MB/rns \
;;       $MB/rMIDE \
;;       $MB/rHNMP  \
;;       $MB/rTJ \
;;       $MB/rProto \
;;       $MB/rnav2 \
;;       $MB/rthr \
;;       $MB/rguH 
;;       $MB/rilist \
;;       $MB/rmbs \
;;       $MB/rgrep \
;;       $MB/rTAC \
;;       $GB/rzro3 \
;;       $GB/rmgbFL3 \
;;       $MB/rmGP3 \
;;       $GB/rmenu3 \
;;       $GB/rTOI7  \
;;       $GB/rvv \
;;       $GB/rhgen4b \
;;       $GB/rdev3 \
;;       $GB/rd2c \
;;       $GB/rdbget \
;;       $GB/rd2vl)"
