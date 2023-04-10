dmnList  ;CKW/ESC  i18May16 gmsa/ rd2menu/ ; 20180921  ; List Whole Menu & HGen - Documentation
  ;
  ; from MU()  Structure
  ; Menu List - Order
  ; mmo  Modes  Pertinent Subvariables and Effects
  ;
  ; to wBase, wFol, devmnu=$$mnu^dvIpg(Mprj)
  ;       destination gmsa (all) vs Mproj www/BE/
  ;
A  S Mpj=$G(MU(0,"Mpj"))    ; vs G0 from MU   @mnuzFL
   I Mpj="" S Mpj="KA1"
   S wFil=$$mnu^dvIpg(Mpj) I wFil="" S wFil="Menu "_Mpj
   S wBase="/home/kw/km7r/gmsa/",wFol="www/BE/"
   S devmnu=wBase_wFol_wFil
   D ^dmnIMG
   U $P W:$X ! W "Creating Menu Page - ",devmnu,!!
   ;
   S mnL=$G(MU(0,"mnL")) I mnL="" S mnL="mm,cp,kp"
   ;
   S TItb="Menu",TIhd="Menu Summary - "_Mpj
   S TIft="^"_$T(+0)
   ;
A2   D HG1^dvh(devmnu)
     W !,"<pre>"
     D LIST
     W !,"</pre>"
   D HG2^dvh(devmnu)
   U $P W:$X ! W "Completed ",devmnu,!
   Q
;List all menus & ops
;  Ref by LISTall^dmnu  in response to ??    and  A2 above
; mnL first, then res of menus
LIST  MERGE MX=MU
   F mi=1:1:$L(mnL,",") S mab=$P(mnL,",",mi) I mab'="" D Wmnu KILL MX(mab)
   S mab="0" F mi=0:1 S mab=$O(MX(mab)) Q:mab=""  B:mab="."  D Wmnu KILL MX(mab)
   W !!
   Q
; One Menu mab  ; 
Wmnu D T^dws("mabFL:dPRP,dDE,dnxt1_^MNU(mSys,mab)")
  D Gmab^dmnu  ; @mabFL/MU : dDE, dPRP, dnxt1
  W !,mab,".  ",dDE,"   "
  I dnxt2'="" W " (->",dnxt2,") "
  W !,?8,"  Prompt:'",dPRP,"'  ",!
  F moi=1:1 Q:'$D(MU(mab,moi))   D Gop^dmnu D Wop
  Q
; One Line of Menu,  S opFL="dopLR,dopab,dopde,dnxt2_MU(mab,moi)"
Wop W:$X ! W moi,")  "  W:dopab'="" dopab,".  "
    W dopLR,"   "
    W ?40,dopde,"  "   I dnxt2'="" W "(->",dnxt2,")  "
    W ! 
    Q
    
