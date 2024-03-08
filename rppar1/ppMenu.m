ppMenu  ;CKW/ESC i31oct22 rcfg/ ;20221031-07; mumps table Parser Menu ^pp*
;  @mpp mpp.sh ^ppGo   ppIBzro^mepIO
;
;*  from ^tdeMenu ten8./ ; td Tennis Draw  Menu Source
;
;
top    KILL  S mSys="mpp"
       S ^MNU(mSys,0,"mpreLR")="dis^"_$T(+0)  ;tdMenu"  ; "VL^dmnDIS"
       S ^MNU(mSys,0,"mpreVL")="mSys,evdt"
       D audFL^ppIMG
       D ^dmnu(mSys,$T(+0),"mSys,evdt,gid,prid")  ; ^MNU(0,"mSysCur")  and go with menu
       D bug^dv  Q  ; this effectively goes back to tda and its quit halts
;
;*
dis     ;pre-Menu Status  of pridCur  etc.
        W:$X ! W "Event Date(evdt?d8):",$G(evdt),"    ;,  gid=",$G(gid),!
        W:$X ! W "  evFol:",$G(evFol),!   ;
        W:$X ! W "  devrg:",$G(devrg),!
        KILL devr W !
        Q
;*
Menu	;Text for Menu  	Compile  RM()
        ;  No-indent mnu, Indent option
        ;mab. dPRP_dDE  
        ;  op.  dopLR  dopDE	# where dopLR contains ^  or menu mab./exists
        ;  dnxt1  or dnxt2 Syntax: | pipe prefix
;;mm. Select from pp Parse mumps Main: _Main pp Menu  |mm
;; t.   T1^ppMa Init, Parse
;;     ^ppGRI  Generate GM(rgan  Grammar Table
;;     Aud^ppGRI  Audit refs
;;     WGR^ppGRI  Write Grammar
;;     la^dv  List Arrays
;;     LM^ppMa  Test Parser on pre-fab TK() S X=A
;;     ^ppIRM  Gen RM() test data
;;     ^ppINtk Gen Tokens from RM()
;;     WTK^ppINtk  Writ TK*
  ;;OBS.   Obsolete versions
  ;;test.    test menu
  ;;***
  
