dmnAUop(mSys)  ;CKW/ESC  i27feb21 gmsa/ rmenu3/ ; 20210319-58 ; Audit Menu ops, HGen List
;New in rmenu3/
;
top   I $zro'["rhgen4",$zro'["rd3hg" D b^dv("Menu Table Audit depends on HGen v3 or v4","mSys") Q
      I $G(mSys)="" S mSys=$G(^MNU(0,"mSysCur")) I mSys="" D bug^dv  Q
      I $D(^MNU(mSys))=0 D b^dv("^MNU(mSys,  is UNDEF","mSys") Q
      S Q=$$menu^mbsIpg("mSys") I Q'="" D b^dv(Q,"Q,mSys") Q  ; devmenu
        D Init^hgh  ; HT,HTS,HTE,CS, TI
        D ^dmnIMG  ; : mabFL, opFL, mab0FL
          D hcss
          S TI("hd")="Menu of "_mSys,TI("tb")=mSys_"-Menu"
          S TI("VL")="mSys,mmo,mnL,mpreLR,zro"
          D T^dws("msysFL:mmo,curmab,mnL,mpreLR,zro_^MNU(mSys,0)")
          D GFL^dgmg(msysFL) ; mSys ^MNU(mSys,0
        D HGS^hgh
        D HGE^hgh
        D guts
        D WH^hgh(devmenu)
        Q
;*
hcss    D css^hgh("mab.","background-color:yellow")
        D css^hgh("op.","background-color:pink")
        Q
;*  MNU()  or ^MNU  slightly diff merge
;    Ea Menu ($O not same as found), then ea op
; Test:  $T(@dopLR)   is $zro dependent, not clear which dir, ? in first line, not accurate
guts    ;
        D ^dmnIMG  ; mabFL, opFL
        S mnL=$G(^MNU(mSys,0,"mnL"))
        I $G(mnL)="" D b^dv("mnL is not defined","mnL,mSys") Q
        KILL MAB S m=0 F mi=0:1 S mnu=$O(^MNU(mSys,mnu)) Q:mnu=""  S MAB(mnu)=mi
        F mi=1:1:$L(mnL) S mnu=$P(mnL,",",mi) I mnu'="" DO  ;
          .S ni=$G(MAB(mnu)) I ni="" D b^dv("mnu in mnL in not in ^MNU","mSys,mnu")
          .KILL MAB(mnu)
        I $O(MAB(0))'="" S mnu="" F mi=0:1 DO  ;
          .S mnu=$O(MAB(mnu)) I mnu="" Q
          .D b^dv("mnu not in mnL ?","mnu,mSys,mnL")
        ; Now use mnL for order of menus
        F mi=1:1:$L(mnL,",") S mnu=$P(mnL,",",mi) D Hmnu(mnu)  ;
        Q
;* Audit and HGen one mnu
Hmnu(mab) I $G(mab)="" D bug^dv Q
     S dPRP=$G(^MNU(mSys,mab,"dPRP"))
     D ot^hgh(".mab"),sv^hgh(mab_": "_dPRP),br^hgh
     F moi=1:1 Q:$D(^MNU(mSys,mab,moi))=0  DO  
       .D GFL^dgmg("dopLR,dopab,dopde","_^MNU(mSys,mab,moi)")  ; literals vs *FL vars
       .S opD=$$AUop(dopLR)  ; null defined, else not ( : Lop, opde)
       .S opln=moi_") " I dopab'="" S opln=opln_" ("_mab_".) "
       .S opln=opln_"  "_dopde
       .I opD'="" S opln=opln_" / "_opD
       .I opde'="" S opln=opln_" / "_opde
       .D ot^hgh(".op"),sp^hgh(4),sv^hgh(opln),ct^hgh(".op")
     D ct^hgh(".mab")
     Q
;*
;*$$Q  : Lop first line of code, opde  ;; descr
AUop(dopLR)  NEW Q S Q="",Lop="",opde=""
     I dopLR="" S Q="No Entry Label" G QA
     S LR=$P(dopLR,"(")
     I LR'["^" S Q="Not valid without ^" G QA     ; No context for local sr ref.
     S Lop=$T(@LR)
     S opde=$P(Lop,";;",2,9)  ; null if Lop null     
     I Lop="" S Q="Undef"
QA   Q Q
;*
