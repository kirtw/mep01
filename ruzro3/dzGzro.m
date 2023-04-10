dzGzro  ;CKW/ESC i2jun20 gmsa/ rd2zro/ ; 20200602-88 ; Index ^QZRO, ^QZx $zro by mpj & cfg/*profile.sh
;
; No top entry
;
;*$$Q  : ^QZRO(qzid), ^QZx(
;*RefBy:  KAcf/rcfg/cfMenu.m:38:  ;;  z2.   grep^dzGzro  Gather ZRO ^QZRO profiles for projects
grep()  ;
        S devp="/home/kw/km6a/gmsa/rd2zro/grep-zro-2jun20.txt"
        S Q=$$^devRD(devp) I Q'="" D b^dv(Q,"Q")
          ;  RDa()
        D IQZ,^dzIMG  ; : zroFL, 
        F ri=1:1:RDa S L=RDa(ri)  I L'="" DO  ;
          .I L'["gtmroutine" Q
          .I L["grep" Q
          .I $E($P(L,":",3),1,6)["#" Q  ; D b^dv(" # ","L,ri") Q
          .D NFL^dgmg(zroFL)  ;clear profile, set @vn null
          .S qL=L
          .S mFol=$P(L,":"),n=$L(mFol,"/")
          .I $P(mFol,"/",n-1)'="cfg" D b^dv("Err mFol cfg ?","mFol,ri,L")
          .S mpj=$P(mFol,"/",1,n-2)
          .S PB=SB_"/"_mpj
          .S qPB=SB_"/"_mpj,qSB=SB,qGB=GB,qPB=PB
          .S fPro=$P(mFol,"/",n)
          .S p2=$P(L,"routines=""",2),szro=$P(p2,"""")
          .I szro="" D b^dv("log szro","szro,L,p2")
          .D xzro
          .D T^dws("zroFL=szro,qzro,mFol,mBase,mpj,fPro,qSB,qGB,qPB,qL_^QZRO(qzid)")
          .S Q=$$qzidNxt^dzIMG  ; : new qzid
          .S Q=$$SFL^dgmg(zroFL) ; qzid, ^QZRO
          .D SQx
        USE $P W:$X ! W " Completed (^"_$T(+0)_") about "_ri_" ^QZRO profiles.",! 
        D ^GP5("^QZRO")
        D ^GP5("^QZx")
        Q
;*
SQx     I mpj'="" S ^QZx("mpj",mpj)=qzid
        Q
;; su3/cfg/sud-profile.sh:9:export gtmroutines="$PB/o($PB/r $PB/rsr $PB/rdv $GB/gmsa/rdv) $gtm_dist"

;*  szro  SB, GB, PB, Substitute for $PB etc in szro -> qzro  z/qzro
xzro    S z=szro
        S V="$PB" F i=1:1 Q:z'[V  S z=$P(z,V)_PB_$P(z,V,2,99)
        S V="$GB" F i=i:1 Q:z'[V  S z=$P(z,V)_GB_$P(z,V,2,99)
        S V="$SB" F i=i:1 Q:z'[V  S z=$P(z,V)_SB_$P(z,V,2,99)
        F V="$mBase","$gtmMBase","$MPbase","$tbase" F i=1:1 Q:z'[V  S z=$P(z,V)_PB_$P(z,V,2,99)
        F V="$gmsaBase","$MPJ","$MBase" F i=1:1 Q:z'[V  S z=$P(z,V)_GB_$P(z,V,2,99)
        F V="$Gfd" F i=1:1 Q:z'[V  S z=$P(z,V)_"gmfd"_$P(z,V,2,99)
        S qzro=z
        I $L(z,"$")>2  D b^dv(" More $ ","mpj,szro,qzro,z,i")  ; tolerate one $gtm_dist remaining
        Q
;*
IQZ     KILL ^QZRO,^QZx
        S SB="/home/kw/km6a"
        S GB=SB_"/gmsa"
        S PWD=$ZTRNLNM("PWD")  ; sic vs base when grep run, /home/kw/km6a"
        S mBase="/home/kw/km6a/"  ; ?mpj/
        Q
;*
nsZXU   ;
        I $D(RXU)=0 D b^dv("Must do check first to see RXU","qzid") Q
        KILL nNS S ns=""
        S mr=0 F mi=0:1 S mr=$O(RXU(mr)) Q:mr=""  D NS
        USE $P W:$X ! W "Name Spaces-",!
        S ns="" F ni=0:1 S ns=$O(nNS(ns)) Q:ns=""  DO  ;
          .S n=$G(nNS(ns))
          .W:$X ! W "  ",ns,"  x ",n,!
        Q
;*
NS      F i=1:1:nn I $E(mr,i)'=$E(ns,i)  DO  ;
          .D Ens
          .I i=1 S ns=mr,ne=1,nn=$L(ns) Q  ;No letters match
          .S ns=$E(mr,1,i-1),ne=1,nn=$L(ns)
        S ne=ne+1
        Q
;*
Ens     S nNS(ns)=ne
        Q
