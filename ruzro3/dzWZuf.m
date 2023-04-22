dzWZuf(zrid)  ;CKW/ESC i29dec22 gmsa./ rzro3/ ;20220=1229-41;Write ^ZWZ(zrid to file(zrid)
;   to common file in 0uzro./ dzrid/
;
;  proto: mad umad alias mam, ^madgoMenu  zrid:mad, mpj:umad
;  proto: 1zro devy-fcf3/cfg/ zrid:cf  fcf3  cf cf.sh cfa cfMenu 
;       mbr cf. KAcf^mwMa  
;  proto: fin3./ 1zro is devy-  ^fina ^dzWZuf  save for mbr
;
;  zrid Filename key and ^ZWZ(zrid
;  File Format:  #E1 comment,  var:value  
;  var in { zzro,czro,d12/dh, zrid also in filename, mpjDir, mpjAl, mpjRou, kwsys, W2B}
;  key here is zrid (not mpj as with ^dzWzro)
;  zrid:   ^ZWZ  mbr system id
;  d12: d12 timestamp
;  dh:  $H timestamp
;
top    NEW Q S Q="" I $G(zrid)="" S Q="arg zrid ^"_$T(+0) Goto Qbug
       I $D(^ZWZ(zrid))=0 S Q="Err ZWZ(zrid UNDEF" G Qbug
       NEW zzro,mpjDir,mpjAlias,mpjSRou,kwsys,kwmpj,dh,d12
       D III  ;devuz, dh, d12
       D OFW(devuz)  ;local copy
       USE devuz W "# ",devuz,"  zrid  $zro log file-",!
       D WVL
       CLOSE devuz
       ;USE $P W:$X ! W "Completed ",devuz,!!
       Goto Q
;*
;* Shared exit
Q     Q:$Q Q I Q="" Q
Qbug  D qd  Q:$Q Q  Q
qd    D ^dvstk,b^dv("Err ^"_$T(+0),"Q,zrid,czro,kwsys,kwmpj,mpjDir,mpjAlias")
      Q
;*  kwmpj, kwsys : devuz, dh
;RefBy ^dzRzro also
;*  zrid : devuz, d12, dh
III    NEW zFil,zFol
       S zFil=zrid_"-ZWZzrid.mdk"
       S zFol="0uzro/dzrid/"
       S devuz="/home/kw/km3a/"_zFol_zFil
       S dh=$H,d12=$ZD(dh,"YYYYMMDD2460")
       Q
;*  to devuz
WVL    KILL WZ MERGE WZ=^ZWZ(zrid)
       S vn=0 F vi=1:1 S vn=$O(WZ(vn)) Q:vn=""  DO  
         .S val=$G(WZ(vn))
         .I val="" S val="Null."
         .W:$X ! W vn,":",val,!
       W:$X ! W "d12:",d12,!
       W !!  ;end with blank lines
       Q
;*  * * * * *       
;*  Avoid rdir Dependency on rdevIO/   copy local OFR 30dec22
;*  opt 2nd arg Array to write and close
OFW(devww,WER) NEW Q S Q="?OFW"
       I $G(devww)="" S Q="Bug devww " D b^dv(Q,"devww") Q Q
       CLOSE devww  ; debug safety
       ; S x=$ZSEARCH(devww) I x'="" S Q="File Exists " D b^dv(Q,"x,devww")  ; Q Q
       OPEN devww:(newversion:exception="G ofwE1^"_$T(+0))
       USE devww:(exception="G ofwE2^"_$T(+0))
       S Q=""  ; falls thru
ofwQ   ;I $D(WER)=11 D WWER
       Q:$Q Q Q
;*
ofwE1  S Q="Error Opening file to write- " D b^dv(Q,"devww,Q") CLOSE devww
       Q:$Q Q Q
