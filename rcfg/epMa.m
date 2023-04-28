epMa  ;CKW/ESC i14feb23 umep./ rcfg/ ;20230214-91; Profiles
;
;
;
top     BREAK  HALT  ;No top entry
;*
p01   S pxid=1
      S Ins="1+(2*3-4)"    D ^ep4IN(Ins)
      D ^epGRdemo  ; Demo Grammar
        D ^ep4RGA  ;  RS() : GRk(),     Compile Grammar
      D ^ep4go
      Q
;*
;*  Audit *FL  separately
audFL KILL   D ^epaIB ;
      D ^epaIMG ; *FL
      USE $P R !,"Did you git before Updating ? [n]:",X
      I X'="y" W " aborting..." Q
      D ^kfmUafl(PB,1)  ;  Update mrou !
      Q
;*

;*  Orig version SC()...  OBS
epG0  ;^epaG0 
