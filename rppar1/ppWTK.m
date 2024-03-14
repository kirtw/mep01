ppWTK   ;CKW/ESC i8mar24 umep./ rppar1/ ;2024-0308-48; Write TKv() Terminal Input Tokens  @tokFL
;
;
;*  Write TKv()
;;tokFL:tkcod,tks,tkcs,tkce_TKv(ti)
WTK   W !!  NEW tki,tkcod,tks,tkcs,tkce
      F tki=1:1:TKv  DO  ;
        .D GFL^kfm(tokFL)  ; TKv(tki,
        .W:$X ! W tkcod,"  ",?15,"'",tks,"'   {",tkcs,"-",tkce,"} ",!
      Q
