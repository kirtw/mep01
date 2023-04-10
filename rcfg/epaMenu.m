epaMenu  ;CKW/ESC i31oct22 rcfg/ ;20221031-07; Earley Parser Menu
;
;
;
tdeMenu	;CKW/ESC  i15nov21 ten4/ rcfg/ ; 20211119-38  ; td Tennis Draw  Menu Source
;
;
top    KILL  S mSys="mep"
       S ^MNU(mSys,0,"mpreLR")="dis^"_$T(+0)  ;tdMenu"  ; "VL^dmnDIS"
       S ^MNU(mSys,0,"mpreVL")="mSys,evdt"
       D ^dmnu(mSys,$T(+0),"mSys,evdt,gid,prid")  ; ^MNU(0,"mSysCur")  and go with menu
       D bug^dv  Q  ; this effectively goes back to tda and its quit halts
;
;*
dis     ;pre-Menu Status  of pridCur  etc.
        W:$X ! W "Event Date(evdt?d8):",$G(evdt),"    ;,  gid=",$G(gid),!
        W:$X ! W "  evFol:",$G(evFol),!   ;
        W:$X ! W "  devr:",$G(devr),!
        KILL devr W !
        Q
;*
Menu	;Text for tdDev  Menu  	Compile  RM()
        ;  No-indent mnu, Indent option
        ;mab. dPRP_dDE  
        ;  op.  dopLR  dopDE	# where dopLR contains ^  or menu mab./exists
        ;  dnxt1  or dnxt2 Syntax: | pipe prefix
  ;;mm. Select from Dev Tennis Main: _Main tdDev Menu  |mm
  ;;  zro. Czro^epaUDcp  Update zroStd and zroUcp for umep./
  ;;  cpu. ^epaUDcp Copy Revised Utilities from gmsa./ into umep./  ru*/  
  ;;  go. p01^epMa ; Std Input, Demo Grammar, ep4, Parse
  ;;  lua.  WSCLua^ep4W  Lua Equiv SCF Dump to console
  ;;  gr.   WGR^ep4W Display Grammar
  ;;  tsq.  TSQ^ep4W  write reverse trace
  ;;  hr.  ^ep2HGrp  Reverse HGen Table
  ;;  ht. ^ep2HGpt  HGen SCF state Table as HGen Table/Parse Tree
  ;;  d2.  ^ep2Dbg Gen ALL from ikey list
  ;;  t.   T^dvn  Test new debugger
  ;;  tj. TJ^jfm  Test jfm vn analyzer
  ;;      ^epaG0   Run RP versiontrial Parser  
  ;;  mbr.  mep^mwMa  HGen mumps Browsing cb data 
  ;;  c.  ^cgzro  Derive zro
  ;;OBS.   Obsolete versions
  ;;  g2.   ^ep2G0  mep Parse demo input, grammar ala Lua
  ;;  g3.   ^ep3G0  mep ^ep3* dev
  ;;test.    test menu
  ;;  tix.  tix^tdTRead test sr Xmf in Read Template
  ;;***
  
