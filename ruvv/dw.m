dw   ;CKW/ESC  i4sep20 gmsa/ rvv/ ; 20201029-87 ; ZWR  in organized fashion
;
;
;
A    NEW %vi,%vn,%val  KILL %VV
     D ka^dv  ;List and kill Arrays
     ZSH "V":%VZ
     F %vi=1:1 S %L=$G(%VZ("V",%vi)) Q:%L=""  DO  ;
       .S %vn=$P(%L,"="),%val=$P(%L,"=",2,999)
       .I %vn["FL",$P(%vn,"FL",2)="" S %VFL("FL",%vn)=%val ; ? and in %VV
       .I $E(%vn,1,3)="dev" S %VFL("dev",%vn)=%val
       .;   et. al.
       .S %VV(%vn)=%val
     ;KILL %VZ
     ;D sFL  ; Find *FL vars
     zwr %VFL
     zwr %VV
     Q
     
     
;*  %VFL { *"FL"    dev*   
;*  DO ZWR od Array to pipe, modify format in Z(i)
Z(An)  S dev="ZW" OPEN dev:(newversion:exception="G OER^"_$T(+0))
       USE dev zwr @An W ! CLOSE dev
       USE $P W 123,!
       OPEN dev:(rewind:exception="G OER2^"_$T(+0))
       USE $P W 456,!
       F i=1:1 DO  Q:ZEOF  Q:Z2  Q:X=""   ; Q:(X'["(")&(i'=1)  ;
         .USE dev R X 
         .S ZEOF=$ZEOF,Z2=$T 
         .USE $P W !,i," ",X,"  ",$L(X)," ZEOF:",ZEOF," Z2:",Z2,!
         .I ZEOF Q
         .I Z2 B  Q
         .S Z(i)=X,Z=i
       G Z2
UER    U $P I $ZS["EOF" G Z2       
       D b^dv("Err besides EOF","ZS,zi")
       Q
OER    B  
       Q
OER2   B
       Q
;* cont after Read loop Z() : Z()'       
Z2     F si=1:1:9 S SS(si)=""
       F zi=1:1:Z S L=Z(zi) DO  ;
         .S PS=$P(L,"(",2,9),PS=$P(PS,")")
         .I PS="" Q  ; No subscr,eg head node
         .S ncp=$L(PS,",")
         .F si=1:1:ncp S S(si)=$P(PS,",",si)
         .S T=1 F si=1:1:ncp DO  
            ..I T,S(si)=SS(si) D ssi Q
            ..I SS(si)="" S SS(si)=S(si) Q
            ..S SS(si)=S(si),T=0
         .S L2=$P(L,"(")_"("_PS_")"_$P(L,")",2,9)
         .W:$X ! W zi," ",?5,L2,!
         .S Z(zi)=L2  ; or Z@(zi)=L2   and PS null copy above
       Q

;* set sub si in PS to spaces
;*  si, L, PS : PS'
ssi    S ns=$L(S(si)),sp=$E("                    ",1,ns)
       S $P(PS,",",si)=sp
       Q

;*    tdw. navMenu
TZ    KILL ARt  
      F i=2,4,6 F j=2*i,2*i+1 S ARt(i,j)=$R(100)
      F i=1:1:6 S ARt(2,4,i)=$R(100)
      S ARt=6
      zwr ARt
      D Z("ARt") ; : Z(i)
      W !! zwr Z W !
      Q