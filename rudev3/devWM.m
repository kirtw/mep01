devWM(murl) ;CKW/ESC i8apr23 gmsa./ rdev3/ ;20230408-69;Write RM() asa ydb-mumps file
; murl (mrou.m) : RM(),  mrou
;
top   NEW Q S Q=""
      NEW z,nsl,mfil
      I $G(murl)="" D bug^dv Q
      I $D(RM)'=11 S Q="Err no RM()" D bug^dv(Q,"Q,RM,murl") G Qb
      S nsl=$L(murl,"/"),mfil=$P(murl,"/",nsl)
      I mfil'[".m" S Q="Err m file name *.m ?" Goto Qb
      S mrou=$P(mfil,".m")
      S z=$ZPARSE(murl) I z="" S Q="Err murl - "_z Goto Qb
      D L1 ; update time stamp, $P;3 of Ln1 
      S Q=$$^devWF(.RM,murl)
      ;
Q     Q:$Q Q  Q:Q=""
Qb    S Q="IB Err ^"_$T(+0) D b^duv(Q,"zroA,dist,SB,PB,GB")
      Q:$Q Q Q
;*
;*    Get First Line, L1 c=update 3rd ; piece timestamp replace in RM(1)
L1    S L=$G(RM(1))
      S L1=$TR(L,$C(9)," ")
      S Lb1=$P(L1," ")
      S Lp2=$P(L1,";",2),Lp3=$P(L1,";",3),Lp4=$P(L1,";",4,999)
      S DH=$H,Now=$ZD(DH,"YYYYMMDD")
      S CD=$P(DH,",",2)*100\(24*60*60)  ; centi-day
      S L1ts=Now_"-"_CD
      S $P(L1,";",3)=L1ts
      S RM(1)=L1
      Q
;*
