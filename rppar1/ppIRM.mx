ppIRM  ;CKW/ESC i7feb24 umep./ rppar1/ ;2024-0306-75; Get Input from mRou to RM()
;
;
;
;  RG()  //m
top    KILL RM  S RM=0
       NEW Q I $$arg^pps("RG") G Qb
       S gi0=0 F gi=1:1:RG S L=$G(RG(gi)) I $E(L,1,2)="//m" S gi0=gi Q
       I 'gi0 S Q="Err did not find //GR in RG("_gi G Qb
       S ri=0 F gi=gi0+1:1:RG S L=$G(RG(gi)) Q:L["//"  S ri=ri+1,RM(ri)=L,RM=ri
       Q
;*
;*
Q      Q:$Q Q Q:Q=""
Qb     D b^dv("Err ^"_$T(+0),"Q,RG,devrg,gi,grab,gran") Q:$Q Q  Q
;*

