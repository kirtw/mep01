p2Ma ;CKW/ESC i8feb24 umep./  rppar2/ ;2024-0513-51;  Profiles
;
;
GRI    KILL  ;
       D IB^mepIO  
       S Q=$$devlog^devIO("GRI-log.3.html","ww2x/")  ;HGen
         I Q'="" G Qb
       USE $G(devlog)
       D G0^ppGRI  ; : GRv, GRc, GXsq
       D ^ppWGR
       D ^ppGXU  ;Undef refs
       D ^ppGXR  ;Trace-Nesting Refs
       D clog^devlog  ; devlog implicit, tests $G(devlog)
       W:$X ! W "End of GR Analysis-  GRI^"_$T(+0),!
       Q
;*       
LMp2   NEW Q S Q=""  
       W:$X ! W "Starting LMp2^p2Ma ^p2PAR  ",!
       D IB^mepIO  S Q=$$devlog^devIO("mp3LM-log.3.html","ww2x/") G:Q'="" Qb ;HGen
       I $G(devlog)'="" USE devlog
       E  D b^dv("Err no devlog","devlog")
       D G0^ppGRI  ; mGR0a.mdk in rppar2/ : GRv...
       D ^ppITK  ; TKv()  for S X=Y eol
         ;D pze^p2s("Log LM^p2Ma","GRv,GRc,TKv")
       D ^ppTXU  ;Audit TKv  vs GRt()  etc.
       D ^ppWTK ; Write TKv()
         ;D pze^p2s("See TKv ","TKv")
       USE devlog 
       ;D ^p2PAR  ;STK, non-recursive  rppar2/ ^p2PAR One big MRou
            KILL (TKv,GRv,GRc,GRt,GXsq,Q)  ; debug
       D ^p3PAR  ; Recursive + STK, toty{T,R,E}
       I $G(devlog)'="" U $P W !,"devlog:",devlog,"  ... Completed.",!
       D ^p2HPT  ; HGen PTx(pti,tki,   @pt2FL  grid  PI
       D clog^devlog  ;devlog CLOSE 
       I $D(Q)=0 D b^dv("Err Q killed ?","Q")
       G Q
;*
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
      D ^p2PAR  ;Parse it
      Q
;*  test / debug
TXU   D G0^ppGRI
      D ^ppITK 
      D ^ppTXU
      Q
