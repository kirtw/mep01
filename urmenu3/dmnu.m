dmnu(mSysArg,mSysMRou,mpreVL,mpreLR) ;CKW/ESC   i14may16 gmsa/ rmenu3/ ; 20210720-98 ; Menu Utility run mSys=^MNU(0,"mSysCur")
;*$$Q rev add args/opt 20jul21
  ;  No locals, opt args  vs ^MNU(0,"mSysCur") etc.
  ;  See ^dmnCom(mSys) of RM() after ^dmnRT read from $T of @mnuMRou to RM(), compile Menu to ^MNU(mSys)
  ;
RE  NEW Q S Q=""
    I $zro'["rmgbFL",$zro'["rd2mg" S zro=$zro D b^dv("Depends on ^dgmg in rmgbFL* or rd2mg","zro") Q
    S mpreVL=$G(mpreVL),mpreLR=$G(mpreLR)    
    I $G(mSysArg)'="" S mSys=mSysArg,^MNU(0,"mSysCur")=mSys
    E  S mSys=$G(^MNU(0,"mSysCur")) I mSys="" DO  Q
      .D ^dvstk S Q="Had no mSys ? for Menu ^MNU(0,'mSysCur')"
      .D b^dv(Q,"mSys")
    I $G(mSysMRou)'="" DO  ;
      .D ^dmnRT(mSys,mSysMRou) ; Read $T menu source to RM()
      .I $D(RM)<9 D b^dv("Failed to fine Menu source","mSys,mnuMRou,mpreLR") 
      .D ^dmnCom(mSys,mpreVL,mpreLR)  ; compile RM() to ^MNU(mSys,
    I mpreVL'="" DO  ;
      .S mpreLR="VL^dmnDIS"
      .S ^MNU(mSys,0,"mpreLR")=mpreLR
      .S ^MNU(mSys,0,"mpreVL")=mpreVL                                                      
    KILL MU  MERGE MU=^MNU(mSys)	; See @mabFL _^MNU(mSys,0)
    D ^dmnIMG  ; msys0FL, mabFL, opFL
    D T^dws("msys0FL:mmo,curmab,mnL,mpreLR,zro_^MNU(mSys,0)")
    D GFL^dgmg(msys0FL)
    I curmab'="" S mab=curmab
    I mab="" S mab="mm"  ;default
    I mmo="" S mmo="mm"  ;default
  ;  mab  Current Set
mab    S mab=$G(mab) S:mab="" mab="mm",mmo=""
         I '$D(MU(mab)) S mab="mm"
       D Gmab I dPRP="" S dPRP="Select Option- "
       ; fall thru   mab, mmo, dPRP, MU()
PRMPT  I $G(mab)="" D b^dv("Lost mab ","mab,mmo,mSys") G RE
       I '$D(mmo)!'$D(dPRP) G RE
       U $P W:$X !
       I $G(mmo)["#" D LIS
       W mab,".  " I $G(dPR)'="" W dPRP I dPRP'[":" W ": "
       R X
RX     I X="."  G Q:mab="mm" S X=""  ;exit mm, else go to mm
       I X="h" HALT  ; debug quick out
       I X="" S mab="mm" G mab
       I X="??" G LISTall
       I X=">?" G LISmSys
       I X["?",$P(X,"?")'="" G SrchX
       I X="/" W # G PRMPT
       I X?1.2n  G OPn
       I X["." G AB
       I X'="",$D(^MNU(X))=11 S mSys=X Goto newmSys  ; Type Full mSys
       W !," ? I dont understand. '",X,"' ?",!
       G WAIT
;*  Numeric option entry
OPn    S moi=+X
       S dopLR=$G(MU(mab,moi,"dopLR"))
         I dopLR'="" Goto RUN       
       S dopMnu=$G(MU(mab,moi,"dopMnu"))   ; $ man menu or whole new mSys
       I dopMnu'="",$D(^MNU(dopMnu)) S mSys=dopMnu Goto newmSys
       I dopMnu'="" Goto RNM
       W !,"? not found.",!
       G WAIT
;*  Index abbr either op or menu
;    : mab, moi, dopLR ?
AB     S ab=$P(X,"."),abo=$G(MU(-1,"ab",ab))
       S dopLR="" I abo="" D ^dv("? Cant find ab:","ab,abo") Goto WAIT
       I $D(MU(abo)) S mab=ab  Goto PRMPT   ;new menu
       S mab=$P(abo,"."),moi=$P(abo,".",2)
       D Gop  ; : dopLR, ...
       Goto RUN
;*  either prefab oltion $EDNi  to change, eg by op#  OR type mSys, no punct
newmSys  S ^MNU(0,"mSysCur")=mSys 
         USE $P W:$X ! W "Changing mSys - diff Menu System - "
         R !,"Ret to continue:",X I X="." Goto Q
         S mnuMRou=$G(^MNU(mSys,0,"mnuMRou"))
         I mnuMRou'="" GOTO A^dmnRT  ; bypass arg, Goto to preserve place on stack
         Goto ^dmnu  ;
;Goto Q to finish
Q      Q:$Q Q I Q'="" D b^dv("Err in Menu Op not handled.","Q,dopLR")
       Q
;*  New Menu op
RNM    I dopMnu'="" S mab=dopMnu G PRMPT
       W:$X ! W " ?? Menu (",dopMnu,") " 
       G PRMPT
;*
WAIT   U $P R !,"Ret to continue:",X
         I X'="" G RX  ;option already... ?
       I $G(mab)="" G RE
       G PRMPT
RUN    I dopLR'["^" W:$X ! W " ???" G PRMPT
       I $T(@$P(dopLR,"("))="" W:$X ! W "  MCode not accessible (",dopLR,") ",!,"  in $zro=",$zro,!! G WAIT
       U $P W:$X ! W "Option ",$G(X),"  #",moi,"  ",dopLR,"-   -",!
       S rdX=$G(X)
       F f="dopLR","dopde","moi","rdX","mab" S ^MNU(mSys,0,f)=$G(@f)
       KILL MU   
       KILL mab,moi,Cmab,dopMnu,dopab,dopde,evdt,mnu,mi,mnL,mnLx,mabFL,mpreLR,dPRP,dDE,dnxt1,nxt,rdX
       D ^dmnKgp    ;KILL all but dopLR
       ;S $ETRAP="D ^dbgET"  ; not working, punt down the road...
       D @dopLR
       ;S $ETRAP=""
       ;D b^dv("Log finished Run","dopLR,moi,mab")
       U $P W:$X ! W "Finished Option...",$G(dopLR),"  ",! G WAIT
       G RE
;*
LISTall  U $P S Cmab=mab W # S mnL="mm,cp,kp,ac" D LIST^dmnList
       S mab=Cmab G WAIT
; List menu for dialog
LIS    W #,mab,".  ",$G(MU(mab,"dDE")),"  "
       I mpreLR["^" D @mpreLR  ; usu dis^*Menu  header dashboard
       F moi=1:1 Q:'$D(MU(mab,moi))  D Gop,Wop
       W !
       Q
;*
LISmSys  NEW RI  
       USE $P W:$X ! W "List all Menu System id's mSys-   in $zgl: ",$zgl,!
       S m=0 F mi=1:1 S m=$O(^MNU(m)) Q:m=""  W:$X ! W "  ",mi,") ",m,!  S RI(mi)=m
       R "Select by n (or mSys) ",X
       S mnew="" I +X S mnew=$G(RI(+X)),X=""
       I X'="",$D(^MNU(X))=11 S mnew=X
       I mnew'="" S mSys=mnew Goto newmSys
       G PRMPT
;*  Search All
SrchX  S mch=$P(X,"?"),Cmab=mab I mch="" G LISTall
       D mnL^dmnCom(mSys)  ; mnL
       F mi=1:1:$L(mnL,",") S mab=$P(mnL,",",mi) DO
         .D Gmab,L1
         .F moi=1:1 Q:'$D(MU(mab,moi))  D Gop,L2
       S mab=Cmab G WAIT
;* : L1 if not listed/matched
L1   S U="_",L1=mab_U_dDE_U_dPRP
     I L1[mch D Wmab S L1="" Q
     Q
L2   S L2=dopLR_U_dopab_U_dopde_U_dopMnu
     I L2[mch D:L1'="" Wmab D Wop
     Q
;*
Wmab W:$X ! W mab,".  ",dDE,"    {",dPRP,"}",!
     S L1=""   ; only Dis once for ops that match
     Q
;*
Wop    W:$X ! W moi,")"
       I opD'="" W "*"
       W "  "
       I dopab'="" W dopab,".  "
       DO  ;
         .I dopde'="" W ?15,dopde
         .E  W "Undescribed op "
       W "  ",?50 DO
            .I dopLR["^" W dopLR,! Q
            .I dopMnu'="" W "Menu: ",dopMnu,! Q
            .W "*** Destination ? dopLR or dopMnu",! Q
       Q
;
; Stripped Down, Custom GFL Get list of vars, two lists mabFL menu, opFL option-line
;      MU(mab)   Menu fields  @mabFL
Gmab   D T^dws("mabFL:dPRP,dDE,dnxt1_^MNU(mSys,mab)")
       S FL=$P(mabFL,"_") F vi=1:1:$L(FL,",") S vn=$P(FL,",",vi),@vn=$G(MU(mab,vn))
       Q
;   mab, moi   :  dopLR  null if undef, opD, opde/dopde op moi	  Custom GFL^dgmg (dont want to call out for Menu)
Gop    D T^dws("opFL:dopLR,dopMnu,dopab,dopde,dnxt2_^MNU(mSys,mab,moi)")	
         ;sic ref by IMG^dmnCom
       I $G(moi)="" S moi=999  ;sic
       S FL=$P(opFL,"_") F vi=1:1:$L(FL,",") S vn=$P(FL,",",vi),@vn=$G(MU(mab,moi,vn))
       S opD=$$AUop(dopLR)  ; null defined, else not ( : Lop, opde)
       Q
;*
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

;* * * * * *
