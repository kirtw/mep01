kfm ;CKW/ESC  i7dec22 umbr./  rmep2/ ;20221207-42;FIle man 2 - kw GFL/SFL, *IMG *FL
; Replacement for ^dgmg  - was always a terrible mnemonic vs kfm  kirts's FileManager
;
;
top   BREAK  HALT  ; not top entry, yet ?
;
;
GFL(SFL,GFL)   NEW Q,FL,I,G,vn,vi,val S Q=""
     S GFL=$G(GFL) I $G(SFL)="" S Q="Arg GFL^"_$T(+0) D bug^dv(Q,"SFL,GFL") Goto Qb
     S FL=$P(SFL,"_")
     I GFL'="" S G=$P(GFL,"_",2)
     E  S G=$P(SFL,"_",2)
     I G="" S Q="Arg G GFL^"_$T(+0) D bug^dv(Q,"Q,SFL,GFL,G,FL") Goto Qb
     F vi=1:1:$L(FL,",") S vn=$P(FL,",",vi),@vn=$G(@G@(vn))
     G Q
;*
SFL(SFL,GFL)   NEW Q,FL,I,G,vn,vi,val S Q=""
     S GFL=$G(GFL) I $G(SFL)="" S Q="Arg GFL^"_$T(+0) Goto Qb
     S FL=$P(SFL,"_")
     I GFL'="" S G=$P(GFL,"_",2)
     E  S G=$P(SFL,"_",2)
     I G="" S Q="Arg G GFL^"_$T(+0) Goto Qb
     F vi=1:1:$L(FL,",") S vn=$P(FL,",",vi) DO  I Q'="" G Qb
       .S val=$G(@vn) I val'="" S @G@(vn)=val Q
       .I $D(@vn)=0 S Q="loc var "_vn_" is UNDEF." Q
       .I $D(@G@(vn))'="" KILL @G@(vn) Q       
     G Q
;*
NFL(SFL,GFL)   NEW Q,FL,I,G,vn,vi,val S Q=""
     S GFL=$G(GFL) I $G(SFL)="" S Q="Arg GFL^"_$T(+0) Goto Qb
     S FL=$P(SFL,"_")
     F vi=1:1:$L(FL,",") S vn=$P(FL,",",vi),@vn=""
     G Q
;*
;* Common Q
Q    Q:$Q Q Q:Q=""  ; else fall thru Q not null
Qb   D qd Q:$Q Q Q
qd   D b^dv("Err ^"_$T(+0),"Q,SFL,GFL,FL,G,vn,val") Q
;*
;*  from ^qds  Test *FL variable Comment in situ, T^dws
;*  Test VFL Comment inline vs actual var
T(XXXX) NEW FLna,VFL,FL,G,C1,C2,M,D S D=$IO
     S C1=$$^dvby() I $G(C2)="" B
     S FLna=$P(XXXX,"="),VFL=$P(XXXX,"=",2,99)
     I FLna[":" S FLna=$P(XXXX,":"),VFL=$P(XXXX,":",2,99)
       I FLna="" D b^dv(" Arg T^qds needs VFL=","XXXX,FLna,C2") Q
     I $D(@FLna)=0 USE $P W:$X ! DO  W M,! Q
       .S M="in "_C2_",  T^qds,  VFL '"_FLna_"' is UNDEF D ^*IMG - "
     I @FLna'=VFL USE $P W:$X ! DO  
       .W "  ",FLna," in ^",C2,"    does not match Comment XXXX -",!
       .W FLna,":",?8,@FLna,!
       .W "XXXX:",?8,VFL,!
     USE D  ; in case b^dv does USE $P
     Q
     
