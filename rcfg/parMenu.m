epaMenu  ;CKW/ESC i31oct22 rcfg/ ;20221031-07; Earley Parser Menu
;
; from  tdeMenu ten8./
;
;
top    KILL  S mSys="parm"
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
  ;;mm. Select from Earley parse Main: _Main Earley parse Menu  |mm
  ;;  t.  ^parT  Test parm parser
  ;;  mbr.  mep^mwMa  HGen mumps Browsing cb data 
  ;;  fl.  audFL^epaIMG  Audit *FL in epaIMG

  ;;OBS.   Obsolete versions
  ;;test.    test menu
  ;;***
  
