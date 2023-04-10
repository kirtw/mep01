GAIpg  ;CKW/ESC i29jun22 gmsa/ rmGP3/ ;20220629-26; GA* HGen Page-name mgmt
;
;
top    BREAK  HALT  ; No top
;
;*  ^GAIpg   quickie here 29jun22  : devHmgb
devHmgb(Gna) NEW Q I $$arg^GAs("Gna") Goto Qbug
    S fil="ag-"_Gna_".gb2.html"
    I $G(W2B)="" D ^devIB ; : W2B
    S devHmgb=W2B_fil
Q    S Q="" Q:$Q Q Q  ; No errors
Qbug  D qd Q:$Q Q  Q
qd  D b^dv("Err ^"_$T(+0),"Q,Gna,Gid,W2B,devHmgb")
    Q
;*
