dvIpg  ;CKW/ESC  i18May16 gmsa/ rd2io/ ; 20160518-70 ; Page Names ^dv*
  ;    vs rdv/  identical code
  ;
  ; Ref ^dmnList
;  Menu  Mpj  code  eg. "KA1"   :  $$ is wFil, devmnu
mnu(Mpj) I $G(Mpj)="" S Mpj=""
   S wFil="Menu" I Mpj'="" S wFil=wFil_"-"_Mpj
   S wFil=wFil_".html"
   S devmnu=$G(wBase)_$G(wFol)_wFil
   Q wFil
  ;*
;*  ^kuGimg   img.  HGen Summary of SuperVars
img(Mpr)  NEW f
     I $G(Mpr)="" S Mpr="dv"
     S f="IMG-Summary-"_Mpr_".html"
     Q f
;*  MRou BE Page - identical to ^kaIpg
;*  Page Name for *FL list in MProj mpj		Ref ^dvvHFL  in T2DM dev
VVVL(VVFL,mpj)  I $G(mpj)="" S mpj=""
     I $G(VVFL)="" D bug^dv Q
     S Fil="vFL-"_VVFL I mpj'="" S Fil=Fil_"-"_mpj
     S Fil=Fil_".html"
     Q Fil
;*
