devRvn(RR,VL) ;CKW/ESC i1mar23 gmsa./ rdev3/ ;20330301-93;Pick vn/VL out of file/RM()
;
;
;
top   NEW Q I $D(RR)<9 S Q="arg ^"_$T(+0) G Qbug
      ; Screen for which vn to return aas local (?vs VNr
      S VL=$G(VL) KILL VNv
      I VL'="" F vi=1:1:$L(VL,",") S vn=$P(VL,",",vi) I vn'="" S VNv(vn)=vi KILL @vn
      ;
      F ri=1:1 Q:'$D(RR(ri))  S L=$G(RR(ri)) I L'="" DO
        .I L'[":" Q
        .S vn=$P(L,":"),val=$P(L,":",2,99) 
        .I vn=""!(val="")  Q
        .S VNr(vn)=val
        .I $D(VNv(vn)) S @vn=val,VNr(vn,"ri")=ri
      Goto Q
;*      
;*
Q     Q:$Q Q Q:Q=""
Qbug  D qd Q:$Q Q  Q
qd   D b^dv("Err "_$T(+0),"Q") Q
;*

        
      
