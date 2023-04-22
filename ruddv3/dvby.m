dvby()   ;CKW/ESC  i29sep18 ; 20180929-31 gmsa/ rddv3/; Just get Caller x2 levels
  ;  RefBy: ^dws, T2DM/rTEST/ ^dwWL, T2DM/rsr/ ^qds, T2DM/rsr/ ^qder, ...
  ;
;*$$=C1 : C2
A    NEW S,STK,L
     ZSH "S":STK KILL S MERGE S=STK("S")
     S L=$ZL
     S C1=$G(S(2))
     S C2=$G(S(3))
     ;U $P W !,"$ZL=",L,!,"C1=",C1,!,"C2=",C2,!
     ;zwr S W !!  B
     Q:$Q C1  ; sic vs Error status
     Q
