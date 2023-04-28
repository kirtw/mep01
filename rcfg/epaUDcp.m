epaUDcp ;CKW/ESC i5apr23 umep./ rcfg/ ;20230405-02; Update zro*;Copy gmsa./ rdirs to ur*/ in umep
;   zroStd and zroUcp
;
;
top    ;
       S zrid="umep"
       D Czro
       D CPu  ;
       Q
;* Copy GBL utilities to UBL ru* rdirs
CPu    D IIL ;  : zrid='umep', PB, PBL, GBL, UBL
       I $zro["ruzro" D b^dv("Do not run this op from alias mep, zroUcp Self-contained config","zroUcp") Q 
       ; Copy files incl *.m from gmsa./  to umep./ modified rdir's ru* inside umep
       ;  Remove only *.m files first, copy all files
       ;    vs Remove rudir completely  rudir/
       F di=1:1:$L(GBL," ") S grdir=$P(GBL," ",di) I grdir'="" DO  ;  
         .D grur ; grdir : urdir, Src~gurl, Des~uurl
         .S chm1="chmod -R 777 "_Des_";",chm2="chmod -R 555 "_Des_";"
         .S Z="cd "_PB_"; rm -rfv "_urdir_"; mkdir -p "_Des_"; cd "_Des_" ;"_chm1_"rm *.m -v ; cp -rv "_Src_"/* "_Des_"; "_chm2
         .U $P W:$X ! W Z,!
         .ZSY Z
       U $P W " Completed Util Copies.",!,"UBL:",UBL,!!
       Q
;* derive PB~umep ru* rdir from gmsa./ rdir
grur   S urdir="ru"_$E(grdir,2,99)
       S gurl=GB_grdir,Src=gurl
       S uurl=PB_urdir,Des=uurl
       Q
;* mpjD~umep ; UBL, PBL, GBL, PB,SB,GB
IIL    S zrid="umep",mpjDir=zrid
       D mpjIB^dzIB(mpjDir) ; PB, SB from mpjD: umep
       S PBL="rcfg rmep4 rmePT1 rsr"  ;  rxmep1 OBS ^epaG0, ^epaPAR
       S GBL="rdve1 rzro3 rmgbFL3 rmGP3 rmenu3 rTOI7 rhgen4b rdev3 rd2c rddv3"
       S UBL="" F di=1:1:$L(GBL," ") S grdir=$P(GBL," ",di) DO  ;
         .D grur ; grdir : urdir,
         .S UBL=UBL_" $PB/"_urdir
       I $E(UBL)=" " S UBL=$E(UBL,2,9999)
       E  I UBL'="" D b^dv("UBL no sp first ","UBL,GBL")
       Q   
;* Recalculate zroStd and zroUcp from lists PBL,GBL, UBL
Czro   D IIL ; PBL, GBL, UBL    
       D zroCSU  ; modified UBL -> zroStd, zroUcp in ^ZWZ(zrid~"umep",
       D ^dv("Log zroStd, zroUcp calculation ur* ","zroStd,zroUcp") W !,zroStd,!!,zroUcp,!!
       Q       
;* zrid  : zroC, and in ^ZWZ
zroCSU   ;
       D ^dzCzro(PB,PBL,UBL) ; : zro
       S zroUcp=zro
       S ^ZWZ(zrid,"zroUcp")=zroUcp
       ;
       D ^dzCzro(PB,PBL,GBL) ; : zro       
       S zroStd=zro
       S ^ZWZ(zrid,"zroStd")=zroStd     
       I zroUcp["rvv" DO  ;
          .W !!,"zroStd-",zroStd,!!,"zroUcp-",!,zroUcp,!!
          .D b^dv("Log zroUcp","GBL,UBL,zroUcp,zroStd")          
       Q
;*
