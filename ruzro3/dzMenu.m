dzMenu  ;CKW/ESC i25aug20 gmsa/ rd2zro/ ; 20200825-60 ; zro Utility Menu - Directly callable
;
;
    S mSys="dzMenu"
    I ($zro'["/rd2zro"),($zro'["/rzro"),($zro'["/rzro3") DO  G Q   ; one or other
           .D b^dv("Need access to rzro3 or rd2zro or rzro","zro,mSys")
    D COMM  ;Always compile
          S m=$G(^MNU(0,"mSysCur"))
          I m'=mSys D b^dv("Why not cur?","mSys") S ^MNU(0,"mSysCur")=mSys
    D ^dmnu  ; ^MNU(0,"mSysCur")
Q   Q:$Q ""
    Q
;*
Menu   	;Text for 
        ;LineSyntax:  No-indent is mnu, Indent is an option
        ;mab. dPRP_dDE  
        ;  op.  dopLR  dopDE	# where dopLR contains ^  or menu mab./exists
        ;  dnxt1  or dnxt2 Syntax: | pipe prefix
        ;  $prefix is transfer to other Menu ($mab)
  ;;mm. Select from zro Menu  |mm
  ;;  a.    ^dzs     Display zdir/zro  readably, rdNSL, D2abs, with DupMRou-ck
  ;;  gp6.  GP6^mwMa  Revised GP6  of Mgbl ZWlk
  ;;  ns.   ns^dzMa   NameSpaces
  ;;  olf.  olf^dzMa  Edit sequence of rd2zro/ OLF file
  ;; xtest.    Test rd2zro/ Menu
  ;;   tdz. TAll^dzTest All rd2zro/  tests
; ***
;*  Compile Menu $T -> RM(), then Compile  ^dmnucom
COMM   KILL RM   S RM=0   NEW ri,L
       F I=1:1 S L=$T(Menu+I) Q:L["***"   Q:L=""  I L[";;" DO
         .S RM=RM+1,RM(RM)=$P(L,";;",2,9)
       ;
       D ^dmnCom(mSys)  ;Compile RM() to ^MNU(mSys  and make mSysCur
       Q
;*
dis    Q
;*
