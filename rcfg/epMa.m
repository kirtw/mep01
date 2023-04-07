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
