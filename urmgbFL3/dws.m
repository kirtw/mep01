dws   ;CKW/ESC  i29oct18 gmsa/ rmgbFL3/ ; 20181029-78 ; Sr for ^dw* Write WFL
  ; T^dws  is special, outgrew parents, WFL copy in rd2mg for T^dws
  ;
  BREAK  HALT  ; Top reserved
;*
;*  from ^qds  Test *FL variable Comment in situ
;*  Test VFL Comment inline vs actual var
T(XXXX) NEW FLna,VFL,FL,G,C1,C2,M,D S D=$IO
     S C1=$$^dvby() I $G(C2)="" B
     S FLna=$P(XXXX,"="),VFL=$P(XXXX,"=",2,99)
     I FLna[":" S FLna=$P(XXXX,":"),VFL=$P(XXXX,":",2,99)
       I FLna="" D b^dv(" Arg T^qds needs VFL=","XXXX,FLna,C2") Q
     I $D(@FLna)=0 USE $P W:$X ! DO  W M,! Q
       .S M="in "_C2_",  T^qds,  VFL '"_FLna_"' is UNDEF D ^*IMG - "
     I @FLna'=VFL USE $P W:$X ! DO  
       .W "  ",FLna," in ^",C2,"    does not match Comment XXXX -",!
       .W FLna,":",?8,@FLna,!
       .W "XXXX:",?8,VFL,!
     USE D  ; in case b^dv does USE $P
     Q
  ;
IMG   D IMG^dwWLW  ; : wanFL here eventually
     D T("wanFL=wvn,wtb,ws,wcap,wf,nwl_fa(wi)")
     Q
  ;
;* Header Line,  fa() 
hdr2   D IMG  ; : wanFL
      D GFL^dvs(wanFL)  ; wi, fa(wi) : wtb,...
      D bug^dv
      Q
;*      
hdr(wid)  I $G(wid)="" S wid=0
      W:$X ! D fa0 F wi=1:1:nwi DO
        .S tb=$G(fa(wi,"wtb")),wvn=$G(fa(wi,"wvn"))
        .W ?tb,wvn," "
      W !
      Q
hfl   W:$X !  D fa0 F wi=1:1:nwi DO
        .S tb=$G(fa(wi,"wtb")),wvn=$G(fa(wi,"wvn")),wf=$G(fa(wi,"wf"))
        .W ?tb,$E("--------------------",1,wf)," "
      W !
      Q
hfa   I $G(wid)="" S wid=0 D fa0
      S aL="wtb,wf,ws,wcap,wun"
      F ai=1:1:$L(aL,",") S an=$P(aL,",",ai) D wan
      D xl
      Q
wan      W:$X ! W ?10,an," " F wi=1:1:nwi DO
        .S tb=$G(fa(wi,"wtb")),wvn=$G(fa(wi,"wvn"))
        .S wav=$G(fa(wi,an))
        .W ?tb,wav," "
      W ! Q
;* Write $x scale
xl    W:$X ! NEW i,dn  S dn="123456789+"
      F i=1:1:11 W dn
      W ! Q
xl2    W:$X ! NEW i,d10,x
      F i=0:1:11 S d10=i*10 S:'d10 d10="00" DO  ;
        .I $X>d10 S x=$X D b^dv("Err ","d10,x,i")
        .W ?d10,"1 ",d10," 6789+"
      W ! Q
;*
;* Quickie output fa()  - zwr
wfa    W:$X ! I $D(fa)=0 W " fa() is UNDEF!",! Q
       I $G(WFL)'="" W WFL,!!
       zwr fa
       W !
       Q
;*       
;* get fa(0,  to local : 
fa0   S vn="" F fi=0:1 S vn=$O(fa(0,vn)) Q:vn=""  S @vn=fa(0,vn)
      Q
