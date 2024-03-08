mepIO  ;CKW/ESC i10jul23 umep./ rppar1/ ;2023-0710-25; IO sr and IB for ^cmd* in umad./
;   See also cmdIO
;
;*
;*
IBsys   S kwsys="km3a",kwuser="kw"
        S SB="/home/"_kwuser_"/"_kwsys_"/"
        S GB=SB_"gmsa/"
        Q
;*  from ^mas, Substitute for ^devIB  too generic, still behavior changes
;simpler name IB^mas   dev is redundant  vs masIB^      See IBzro, IBmpj^madIO
IB      D IBsys ; : SB, GB
        S kwmpj="umep"
        S PB=SB_kwmpj_"/"
        S W2B=PB_"ww2x/"
        S W2mbr=PB_"ww2mbr/"
        S CWB=$ZTRNLNM("PWD")_"/"
        Q
;*
;*  shared most mep/umep./ variants 
;*  : zro  saved by caller, $zro set by caller
ppIBzro  ;
       D IB  ; umep
       S PBL="rcfg,rppar1,../umbr/rmbrme"  ;umad./ rzdoc temp
       S GBL="rmenu3,rzro3,rhgen5,rmgbFL3,rdbg4,rcor1,rdev4,rsrc1,rmGP4,rerr1" ;,rzdoc
       D ^dzCzro(PB,PBL,GBL) ; : zro
       ;caller compiles, caller sets $zro=
       Q
;*   @mpp  mpp.sh ^ppGo
IBzro  ;  vs IBzro^mas   duplicate here ?  different ( mad bash)
       D IB  ; umep
       S PBL="rcfg,rppar1,rmep2,rmep4,rmePT1,rsr,rxmep1,rDIM,../umbr/rmbrme"  ;umad./ rzdoc temp
       S GBL="rmenu3,rzro3,rhgen5,rmgbFL3,rdbg4,rcor1,rdev4,rsrc1,rmGP4,rerr1" ;,rzdoc
         ;remove rd2vl, ^dvc only in rsrc1/ now   umbr access via umbr./ rmbeme/^mbrofme
       D ^dzCzro(PB,PBL,GBL) ; : zro
       ;caller compiles, caller sets $zro=
       Q
;*

IBzroCP ; ^epaGoInd  Utilities Copy and refs to those in ru*/
       Q
;rcfg/  rmep2/  rmePT1/  rud2c/   rudev3/  ruhgen4b/  rumgbFL3/  ruTOI7/  ruzro3/
;rDIM/  rmep4/  rsr/     ruddv3/  rudve1/  rumenu3/   rumGP3/    ruvv/    rxmep1/

;*  : devlog (opened), devlog is $IO (D is prior ?)
devlog(ifil,ifol)  NEW Q S Q=""
     NEW fil,fol,SB,PB,GB,W2B
     S fil=$G(ifil) I fil="" S fil="Log-cmd.log"
     S fol=$G(ifol) I fol="" S fol="log/"
     D IB
     S devlog=PB_fol_fil
     S Q=$$OFW^devIO(devlog)
     S D=$IO
     USE devlog
     G Q
;*
;*
deverr(ifil,ifol)  NEW Q S Q=""
     NEW fil,fol,SB,PB,GB,W2B
     S fil=$G(ifil) I fil="" S fil="Log-cmd.log"
     S fol=$G(ifol) I fol="" S fol="log/"
     D IB
     S deverr=PB_fol_fil
     S Q=$$OFW^devIO(deverr)
     USE $P
     G Q
;*     
Q    Q:$Q Q  Q:Q=""  ;falls thru
Qb   D b^dv("Err ^"_$T(+0),"zrid")
     Q:$Q Q  Q
;*

