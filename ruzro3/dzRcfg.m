dzRcfg(impj) ;CKW/ESC i10nov22 gmsa/./ rzro3/ ;20221110-79;Read zroCfg File: izro
;
;      : zro2  replacement for $zro izro
       I $G(impj)="" D bug^dv("arg impj ~kwmpj","impj")
;
top    NEW:0 BB,PB,SB,GB,MB,W2B,fil,dev,RON,X,Zeof,CB,dist
       NEW:0 zro2
       D devIBmpj(impj)  ; PB,SB,GB,MB
       S fil="zroCfg.mdk"
       S dev=PB_"cfg/"_fil
       S Q=$$RD(dev)
       S zro2=dist_" "_PB_"o("
       S BB=PB  ;default before any // lines  
       D ^dv("  * * * Log Rcfg ","fil,PB,BB,dev,RD")       
       ;
       F ri=1:1:RD S X0=RD(ri) DO  ;
         .S X=$$DSP(X0)
         .I X["//" D DS(X) Q  ; Set BB         
         .S rdir=$P(X," ")
         .I rdir="" Q
         .W:$X ! W "Add ",BB,"  ",rdir,!
         .S zro2=zro2_BB_rdir_" "
       S zro2=zro2_") "_dist_"/libyottadb.so "_dist_"/libyottadbutil.so"
       D ^dv("Log zro2 done","zro2")
szro   ;S Q=$$^dzroz(zro2) I Q'="" G Q
       ;D Wzdir
       S izro=zro2
       ;S $zro=zro2 leave to caller to set $zro
Q      Q:$Q Q Q:Q=""  D qz Q
Qbug   D qz Q:$Q Q Q
qz     D b^dv("Err ^"_$T(+0),"Q,rdL,BB")
       Q
;*  // line  Requires  PB,SB,GB,MB  
DS(X)  ;
       I X["#" S C=$P(X,"#",2,9),X=$P(X,"#")
       S X=$$DSP($P(X,"//",2))
       F xi=1:1:$L(X," ") DO  ;
         .S XP=$P(X," ",xi) 
         .U $P W:$X ! W "Lp:",xi," ",ri," -'",XP,"' ",!,zro2,!         
         .I XP="" Q
         .I XP="ou" S zro2=zro2_") "_PB_"ou(" Q
         .I XP["GB" S BB=GB Q
         .I XP="MB" S BB=MB Q
         .I XP="PB" S BB=PB Q
         .I XP["BB" B  S BB=$P(XP,"BB:",2) D b^dv("Log BB","BB,xi,XP,X,ri") Q
         .D b^dv2("Err ?XP in // line","XP,xi,X,zro2,BB")
       Q
;*
Wzdir  W !!,"zdir(oi,si)- ",!
       I $D(zdir)=0 W "zdir() UNDEF."
       E  zwr zdir
       W !
       Q
;*
RD(dev)  NEW Q S Q=""   NEW RON,X
       CLOSE dev ; safety/debug repitition
       OPEN dev:(readonly:exception="G EO^"_$T(+0))
       USE dev:(rewind:exception="G EU^"_$T(+0))
       S RON=0,rj=0 F ri=1:1 USE dev R X S Zeof=$ZEOF USE $P Q:Zeof  Q:X["***"  DO  ;
         .I X["#" S X=$P(X,"#") ;ignore comments
         .I X="" Q
         .I X["//" S RON=1  ;turn on parsing
         .Q:'RON
         .S rj=rj+1,RD(rj)=X,RD=rj
       Q Q
;*
EO     U $P S Q="Err Opening dev" 
       W:$X ! W $ZS,!,$ZE,!
       D b^dv(Q,"Q,dev,PB")
       Q Q
EU     U $P S Q="Err USEing dev" D b^dv(Q,"Q,dev,ZEOF,ri,X")
       Q Q
;*   :  PB, GB, MB, W2B
devIBmpj(mpj) S kwmpj=mpj
       S SB="/home/kw/km3a/"
       S PB=SB_kwmpj_"/"
       S GB=SB_"gmsa/"
       S MB=SB_"gmma/"
       S W2B=PB_"ww2x"
       S dist=$P($zro,"(")
       Q
;*
;*  sub for ^devIB til stabilized
devIB  S CB=$ZTRNLNM("PWD")
       S dist=$ZTRNLNM("ydb_dist")
cb       I CB="" S CB="/home/kw/km3a/umad/" B  ;
         I dist="" D b^dv2("Err dist","dist,CB") Q
d2       I $E(CB,$L(CB))'="/" S CB=CB_"/"
       S nsl=$L(CB,"/")
       S SB=$P(CB,"/",1,nsl-2)
       S kwmpj=$P(CB,"/",nsl-1)
       S kwsys=$P(CB,"/",nsl-2)
       S PB=CB
       Q

;*
;*  Copy from gmsa/ rd2c/ ^dv2c to avoid dependencies
;*  Replace all dbl spaces (or more) with single, and remove starting/ending
DSP(X)	NEW i I $G(X)="" Q X
    S X=$TR(X,$C(9)_$C(10)_$C(13),"   ")  ;replace tab,lf,cr with space
    F i=0:1 Q:X'["  "  S X=$P(X,"  ")_" "_$P(X,"  ",2,9999)
	Q $$TSP(X)
;*  Remove start and end spaces (only)
TSP(X)	NEW i S X=$TR(X,$C(9)_$C(10)_$C(13),"   ")  ;replace tab,lf,cr with space
	I $E($G(X))=" " F i=1:1:$L(X) I $E(X,i)'=" " S X=$E(X,i,999) Q
	I $E(X,$L(X))=" " F i=$L(X):-1:1 I $E(X,i)'=" " S X=$E(X,1,i) Q
	I X=" " S X=""  ; Funny case all spaces  vs end i=0 second line ?
	Q X
