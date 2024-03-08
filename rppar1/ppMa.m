ppMa ;CKW/ESC i8feb24 umep./  rppar1/ ;2024-0208-03;  Profiles
;
;
;
LM     W:$X ! W "Starting LM^ppMa ",!
       D ^ppGRI  ; GRv...
       D ^ppITK  ; TK()  for S X=Y eol
       D WTK^ppINtk 
       D ^ppPAR
       Q
       
;*
Q      Q:$Q Q Q:Q=""
Qb     D b^dv("Err ^"_$T(+0),"Q,RUL,TOK,Rn,QRU") Q:$Q Q  Q
;*
;*  test run test data- grammar, input
;
T1    KILL
      D ^ppGRI  ;Generate GKc(gran  Runtime Grammar Table, GRk full attributes
      D WGR^ppGRI  ; Write Grammar
      D ^ppIRM   ; Gen RM() test data
      D ^ppINtk  ; Gen Tokens from RM()
      D WTK^ppINtk  ; Write TK*
      D ^ppPAR
      Q
