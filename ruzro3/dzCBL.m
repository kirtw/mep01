dzCBL  ;CKW/ESC i14feb23 gmsa./ rzro3/ ;20230214-80;Compose zro from PBL,GBL
;
;
;
;*  See zro^mam
umad   S PBL="rcfg,ra1," 
       S GBL="rzro3,rdv2" 
       S MBL="rbrzm1" 
       D Bldzro
       USE $P W !!,"zro:",zro,!!!
       Q
;*  PBL, GBL, MBL  : -> zro
Bldzro S zrix="umad"
       S kwsys="km3a"
       S LUser="kw"
       ;
       S MIB=$ZTRNLNM("PWD")  ; current dir on mumps start
       S MXB=$ZTRNLNM("ydb_dist")  ; gtmy, symlink to ydb vers
       S izro=$ZTRNLNM("ydb_routines")  ; Mrou path list $zro
       ;  Don't ref $zro or will get crash if errors, frustrating
       S SBi=$ZTRNLNM("SB")
       S PBi=$ZTRNLNM("PB")
       S SB="/home/"_LUser_"/"_kwsys_"/"
       S PB=SB_zrix_"/"
       ;
       S zro=MXB_" "  ; source and obj, existing, both in $ydb_dist  itself
            ;don't delete *.o and don't compile   -> oi=1,si=1
       S zro=zro_" o( "
       D AR(PBL)
       S zro=zro_") ou( "
       D AR(GBL,"../gmsa/")
       I $G(MBL)'="" D AR(MBL,"../gmma/")
       S zro=zro_" )"       
       S zro=zro_" "_MXB_"/libyottadb.so "_MXB_"/libyottadbutil.so"  ; GDE.o is in ydb_dist
       Q
;*  
AR(RL,RB) S RB=$G(RB) I RB="" Q
       F li=1:1:$L(RL,",") S rd=$P(RL,",",li)  S zro=zro_RB_rd_" "
       Q
