kfm ;CKW/ESC  i7dec22 umbr./  rmep2/ ;20221207-42;FIle man 2 - kw GFL/SFL, *IMG *FL
;  Replaces ^dgmg - a terrible mnemonic  vs Kirt's FileManager is perfect
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
qd   D b^dv("Err ^"_$T(+0),"Q,SFL,GFL,FL,G,vn,val,vi") Q
;*

     
