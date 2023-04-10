dzRDMeta ;CKW/ESC i9feb23 rzro3/ ;20230209-99;Read aa-rdirMeta.toi to Rdir(rdir,"rde")
;
;
;  vs ^ZWD(zrid
;    ?   ^ZWD(zrid,-1,"rd",rdir,rdid)  IX-rdir/rdid
;
top    NEW Q,RT S Q=""  
       NEW devr,fil,ri,L,rd,rde,PB,GB
       D IB^dzsr  ;GB, PB/umbr
           ;  /home/kw/km3a/gmsa/rzro3/aa-rdir-meta.toi
       S fil="aa-rdir-meta.toi"
       S devr=GB_"rzro3/"_fil
       S Q=$$^devRD(devr,,"RT") I Q'="" G Qbug
       KILL RDir
       F ri=1:1:RT S L=$G(RT(ri)) I L'="" DO  ;
         .I L'[":" Q
         .S rd=$P(L,":"),rde=$P(L,":",2,9)
         .I rd="" Q
         .S Rdir(rd)=rde
       Goto Q
;*
Q    Q:$Q Q Q:Q=""
Qbug   D qd Q:$Q Q  Q
qd     D b^dv("Err ^"_$T(+0),"zrid,Rdir") Q
;*
