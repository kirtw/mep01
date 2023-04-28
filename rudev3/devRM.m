devRM(murl) ;CKW/ESC i8apr23 gmsa./ rdev3/ ;20230408-69;Read a ydb-mumps file to RM()
;  : RM(),  mrou
;
top   NEW Q S Q="" KILL RM S RM=0
      NEW z,nsl,mfil
      I $G(murl)="" D bug^dv Q
      S nsl=$L(murl,"/"),mfil=$P(murl,"/",nsl)
      I mfil'[".m" D b^dv("Err m file name *.m ?","mfil,murl,nsl")
      S mrou=$P(mfil,".m")
      S z=$ZPARSE(murl) I z="" D b^dv("Err murl does not exist","murl") Q
      S Q=$$^devRD(murl,,"RM")
      ;
Q     Q:$Q Q  Q:Q=""
Qb    S Q="IB Err ^"_$T(+0) D b^duv(Q,"zroA,dist,SB,PB,GB")
      Q:$Q Q Q
    
