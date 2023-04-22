dzZlog(M,VL)  ;CKW/ESC gmma/ rd2zro/   ; 20220509-71 ; Write menu/start Log entry
;
;
;RefBy:  
menu     D IB^dzIMG   ; PB, SB, 
         S devZLog=PB_"/dlog/MenuStart-Log.txt"
         S Ln=$ZD($H,"YYYY-MM-DD-24:60  ")_M
         OPEN devZLog:(APPEND)  ; puts ptr at end of file
         USE devZLog W:$X ! W Ln,!
         I $G(VL)'="" D WVL
         CLOSE devZLog
         USE $P
         Q
;*
WVL      USE devZLog W VL,!
         F vi=1:1:$L(VL,",") S vn=$P(VL,",",vi) I vn'="" DO
           .S val=$G(@vn),D=$D(@vn)
           .I D#2=0 S val="UNDEF."
           .I val="" S val="Null."
           .I D>9 S val=val_" and Array."
           .W "  ",vn,": '",val,"'  ",!
         Q
;*  Log $zro from Starter usually
zro(mpj) NEW PB,SB,GB,nsl
         I '$D(^ZWmpj) Q
         I $T(^devIB)="" Q
         I $G(mpj)="" DO  ;
           .D ^devIB ; :mpj from $zro
           .I $G(mpj)="" S nsl=$L(PB,"/"),mpj=$P(PB,"/",nsl-2)
         I $G(mpj)="" Q
         S ^ZWmpj(mpj,"zro")=zro
         Q
;*         
