dzVLog  ;CKW/ESC i1jun22 gmsa/ rzro3/ ;20220601-33;Save mpj vals file
;
;
;
top     S zro=$zro
        D zroxmpj(zro)
        D WLog
        Q
;*
;*
zroxmpj(zro)
        S O2=$P(zro," ",2)
        S S2=$P(O2,"(")
        I $E(S2)'="/" BREAK
        S nsl=$L(S2,"/")
        S LUser=$P(S2,"/",3)
        S kwsys=$P(S2,"/",4)
        S mpj=$P(S2,"/",5)
        S devJlog="/home/"_LUser_"/.akw/xmpj/"_mpj_".txt"
        USE $P W:$X ! W " mpj:",mpj,"  -> ",devJlog,!
        ;
        Q
;*
WLog    ;
        S Q=$$OFW(devJlog) I Q'="" BREAK  BREAK  Q
        USE devJlog
        W "#!",!
        W !!!,"#   ",devJlog,!!
        S wjFL="mpj,LUser,kwsys,zro" D WVL(wjFL)
        S envVL="ydb_dist,ydb_routines,ydb_mgbdir,SB,PB,GB,MB"  D WEV(envVL)
        W !
        CLOSE devJlog
        USE $P
        Q
;*
WVL(VFL) ;
        W:$X !
        F vi=1:1:$L(VFL,",") S vn=$P(VFL,",",vi) W vn,":",@vn,!
        Q
WEV(VFL) ;
        F vi=1:1:$L(VFL,",") S env=$P(VFL,",",vi),V=$ZTRNLNM(env) DO  ;
          .W:$X !
          .W env,":",V,!
        Q
;*  Copy from ^devIO  - prevent dependencies yet
;*  opt 2nd arg Array to write and close
OFW(devww) NEW Q S Q="?OFW"
       I $G(devww)="" S Q="Bug devww " D b^dv(Q,"devww") Q Q
       CLOSE devww  ; debug safety
       ; S x=$ZSEARCH(devww) I x'="" S Q="File Exists " D b^dv(Q,"x,devww")  ; Q Q
       OPEN devww:(newversion:exception="G ofwE1^"_$T(+0))
       USE devww:(exception="G ofwE2^"_$T(+0))
       S Q=""  ; falls thru
ofwQ   ;
       Q Q
;*
ofwE1  S Q="Error Opening file to write- " D b^dv(Q,"devww,Q") CLOSE devww
       Q Q
       
