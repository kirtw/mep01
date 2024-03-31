ppMa ;CKW/ESC i8feb24 umep./  rppar1/ ;2024-0208-03;  Profiles
;
;
GRI    KILL  ;
       D IB^mepIO  S Q=$$devlog^devIO("GRI-log.3.html","ww2x/")  ;HGen
         I Q'="" G Qb
       USE $G(devlog)
       D G0^ppGRI  ; : GRv, GRc, GXsq
       D ^ppITK
       D ^ppWTK
         S D=$IO I D'["log" D b^dv("devlog not $IO ","D,devlog") USE devlog
       D ^ppWGR
       D ^ppGXU  ;Undef refs
       D ^ppGXR  ;Nesting Refs
       D clog^devlog  ; devlog implicit, tests $G(devlog)
       W:$X ! W "End of GR Analysis-  GRI^"_$T(+0),!
       Q
;

;*       
LM     W:$X ! W "Starting LM^ppMa ",!
       ;D IB^mepIO  S Q=$$devlog^devIO("mppLM-log.3.html","ww2x/") G:Q'="" Qb ;HGen
       USE $G(devlog)
       D G0^ppGRI  ; GRv...
       D ^ppITK  ; TKv()  for S X=Y eol
         ;D pze^pps("Log LM^ppMa","GRv,GRc,TKv")
       D ^ppTXU  ;Audit TKv  vs GRt()  etc.
       D ^ppWTK ; Write TKv()
         D pze^pps("See TKv ","TKv")
       D ^ppPAR
       D clog^devlog  ;HGS^hgh equiv, not actual refs
;;pt2FL:gran,grts,grte,grstr_PTx(pti,tki)
       D ^ppHPT  ; HGen PTx(pti,tki,   @pt2FL  grid  PI
       Q
;*
demo   W:$X ! W "Demo PTx Data",!
       D G1^ppGRI
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
      D G1^ppGRI  ;Generate GKc(gran  Runtime Grammar Table, GRk full attributes
      D ^ppWGR  ; Write Grammar
      D ^ppINtk  ; Gen Tokens from RM() //m
      D ^ppWTK  ; Write TKv()
      D ^ppPAR  ;Parse it
      Q
;*  test / debug
TXU   D G0^ppGRI
      D ^ppITK 
      D ^ppTXU
      Q
