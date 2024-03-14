ppMa ;CKW/ESC i8feb24 umep./  rppar1/ ;2024-0208-03;  Profiles
;
;
GRI    KILL  ;
       D IB^mepIO  S Q=$$devlog^devIO("GRI-log.3.html","ww2x/")  ;HGen
         I Q'="" G Qb
       USE $G(devlog)
       D ^ppGRI  ; GRv, GRc, GXsq
       D ^ppITK
       D ^ppWTK
       D ^ppWGR
       D ^ppGXUxr  ;Undef refs
       D ^ppGXR
       D CFW^devIO(devlog)
       Q
;

;*       
LM     W:$X ! W "Starting LM^ppMa ",!
       D ^ppGRI  ; GRv...
       D ^ppITK  ; TKv()  for S X=Y eol
         ;D pze^dv("Log LM^ppMa","GRv,GRc,TKv")
       D ^ppWTK ; Write TKv()
         ;D pze^dv("See TKv ","TKv")
       D ^ppPAR
;;pt2FL:gran,grts,grte,grstr_PTx(pti,tki)
       D ^ppHPT  ; HGen PTx(pti,tki,   @pt2FL  grid  PI
       Q
;*
demo   W:$X ! W "Demo PTx Data",!
       D ^ppGRI
       D ^ppITK
       D ^ppXIpt  ;Fudge PTx() Data
       D ^ppHPT   ; HGen page results
       Q
;*
Q      Q:$Q Q Q:Q=""
Qb     D b^dv("Err ^"_$T(+0),"Q,RUL,TOK,Rn,QRU") Q:$Q Q  Q
;*
;*  test run test data- grammar, input
;
T1    KILL
      D ^ppGRI  ;Generate GKc(gran  Runtime Grammar Table, GRk full attributes
      D ^ppWGR  ; Write Grammar
      D ^ppINtk  ; Gen Tokens from RM() //m
      D ^ppWTK  ; Write TKv()
      D ^ppPAR  ;Parse it
      Q
