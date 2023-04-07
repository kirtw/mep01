epaucp ;CKW/ESC i5apr23 umep./ rcfg/ ;20230405-02; Copy gmsa./ rdirs to ur*/ in umep
;
;
;
top    ;
       D ^devIB  ; $zro : GB, PB, SB
       D IIL
       ;
       F di=1:1:$L(GBL," ") S rdir=$P(GBL," ",di) I rdir'="" DO  ;
         .S Src=GB_rdir_"/*"
         .S Des=PB_"u"_rdir_"/"
         .S Z="cd "_PB_";  mkdir -p "_Des_"; cd "_Des_" ; rm *.m -v ;cp -v "_Src_" "_Des
         .U $P W:$X ! W Z,!
         .ZSY Z
       U $P W " Completed Util Copies.",!
       S zroI=$zro
       D zroC  ; modified UBL -> zroC in ^ZWZ
       D b^dv("Log zroC calculation ur* ","zroC,zroI")
       S $zro=zroC  ; SWITCH ! ??? 
       D ^dzzl($zro)  ; Compile
       S zroT=$zro
       D ^dv("Log compile done.","zroT,zroC")
       Q
;*
IIL    S PBL="rcfg rmep2 rmep4 rmePT1 rsr rxmep1"
       S GBL="rdve1 rzro3 rmgbFL3 rmGP3 rmenu3 rTOI7 rvv rhgen4b rdev3 rd2c rddv3"
       Q
;*   : zroC, and in ^ZWZ
zroC   ;
       D IIL
       S UBL="" F di=1:1:$L(GBL," ") DO  S UBL=$E(UBL,2,999)
          .S r=$P(GBL," ",di)
          .S ur="$PB/ru"_$E(r,2,99)
          .S UBL=UBL_" "_ur
       D ^dzCzro(PBL,UBL) ; : zro
       D kwmpj^dzIB(PB) ; kwmpj, kwsys, LUser
       S zrid=kwmpj
       S zroC=zro
       S ^ZWZ(zrid,"zroC")=zroC
       S ^ZWZ(zrid,"zroStart")=zroC
       Q
;*
