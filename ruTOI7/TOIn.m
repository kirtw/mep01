TOIn(WDa)  ;CKW/ESC i14mar23 gmsa./ rTOI7/ ;20230314-88;Process numbers,amts, dollars ?units
;
;
;  wki, WD(wki) 1:1:nsp
;
;  WD, wki  : num, nty {int,num,neg,zero,dol"}
top   NEW Q S Q="" 
      S W2=$G(WDa),C=$E(W2),nty="" I C="-" S nty="neg",W2=$E(W2,2,999),C=$E(W2)
      I C="$" DO  ; SHould do this with quote processing, vs KLUDGE here
        .S W2=$E(W2,2,999),nty="dol,"_nty,C=$E(W2)      
        .I W2="" S W2=$G(WD(wki+1)),C=$E(W2) KILL Wpnd(wki+1) ;disappear next, combine
      I C="(",$E(W2,$L(W2))=")" S nty=nty_",neg",W2=$E(W2,2,$L(W2)-1),C=$E(W2)
      I 'W2,C'="0" S Q="Log non-num" D b^dv(Q,"C,W2,WD,wki") Goto Q  ; not a number ?
      I 'W2 S nty="num,int,zero" Goto Q  ; zero
      I W2["," S W2=$TR(W2,",") ;strip commas
      I +W2=W2 S nty="num,"_nty,num=+W2 S:nty["neg" num=-num Goto Q
      S num=+W2 S:nty["neg" num=-num
      D S9^TOIp(nty,num)
      Goto Q
;*
Q     Q:$Q Q Q:Q=""
Qbug  D qd Q:$Q Q  Q
qd   D b^dv("Err "_$T(+0),"Q") Q
;*
;* * * * tn.
test  S T2="-123|-123" D T(T2)
      S T2="123|123" D T(T2)
      Q
;
T(T2) S TWD=$P(T2,"|") D ^TOIn(TWD) I num'=$P(T2,"|",2) D b^dv("Err ","T2,WD,num")
      Q
;*

      
