devIO(stem,uFN,iFil,iFol)   ;CKW/ESC  i25feb19 gmsa/ rdev3/ ;20220619-48; devU master subroutine
;;$$~Q  NS: ^dev*
  ;
  ; Entry labels (stem uFN,iFil,iFol):  top, rRD, mR, hW, wW, mdrR,mdwW, lsW,lsR,lsWzsy, 
  ;         log, err  vs init^deverr, init^devlog (same) 
  ; stem(*) vector of vars dev*=*Base_[<mpj>/ ] _ *Fol _ *Fil
  ;    <mpj> / is included in *Base of some stems or nowhere
  ;Tests:  
  ;
  ; Special cases ^devlog, ^deverr   cross between dev  and var-list management
  ;   and debugging  ^dv variant
  ;
A  NEW Q S Q="?"
  I $G(stem)="" S Q="Bug stem calling ^"_$T(+0) D b^dv(Q,"stem,iFil,iFol") Goto Q
  I ",r,w,h,ls,md,mr,"'[(","_stem_",") S Q="Unrecog stem '"_stem_"' " D b^dv(Q,"Q,stem") Goto Q
  D SNull
  I stem="r" B  D rVD S devr=$$dev(rFil,rFol,rBase) S Q=$$RD(devr,.RF) Goto Q
  I stem="w" D VD(.wFil,.wFol,.wBase,"WRITEme.txt","www/BE/",$$kmpBase) S devw=$$dev(wFil,wFol,wBase) D OFW(devw) Goto Q
  I stem="ls",uFN'["W" D lsVD S devls=$$dev(lsFil,lsFol,lsBase) S Q=$$OFW(devw) Goto Q
  I stem="ls",uFN["W" D lsVD S devls=$$dev(lsFil,lsFol,lsBase) S Q=$$RD(devls,.RLS) Goto Q
  I stem="h",uFN["W" D hVD S devh=$$dev(hFil,hFol,$$kmpBase) S Q=$$OFW(devh) Goto Q
   S Q="Bug: Failed to find stem '"_stem_"' " D b^dv(Q,"stem")
Q   Q:$Q Q
    Q
;* Set vars Null if undef for inputs to ^devIO
SNull  I $G(uFN)="" S uFN=""
       I $G(iFil)="" S iFil=""
       I $G(iFol)="" S iFol=""
       Q
;Set Defaults, vec vars exist on output, val if any in iF*   dev arg by Ref!
VD(xFil,xFol,xBase,dFil,dFol,dBase,dev)
  S xFil=$G(xFil),xFol=$G(xFol),xBase=$G(xBase)
  I $G(iFil)'="" S xFil=iFil
   E  S iFil=$G(xFil) S:iFil="" iFil=$G(dFil) I iFil="" D b^dv("Bug no iFil default","iFil,rFil") Q
   I iFil["/" D b^dv("Err: iFil [ /  ","iFil,xFil,xFol,xBase") Q
  I $G(iFol)'="" S xFol=iFol
   E  S iFol=$G(xFol) S:iFol="" iFol=$G(dFol)  ;iFol may be null (no /)
   S:xFil="" xFil=iFil ;S:xFol="" xFol=iFol
  ;S xBase=$G(dBase) I xBase="" D b^dv("Bug No default Base","xBase,dBase")  S xBase=$$kmBase
  I $G(iBase)'="" S xBase=iBase
   E  S iBase=$G(xBase) S:iBase="" iBase=$G(dBase) I iBase="" D b^dv("Bug Base ?","iBase,xBase,dBase")
  S dev=$$dev(xFil,xFol,xBase)
  ;D b^dv("Log VD ","dev,xFil,xFol,xBase,rFil,rFol,rBase")
  Q
;*
dev(xFil,xFol,xBase) Q xBase_xFol_xFil Q
;*  * * * *  
  ; Master stem list  -- stem determines vars, Array, R/W, ...
  ; Retro stems:  devr, devw, devh, devm {r,w,h,m}  and {err, log}
  ; Newer stems  {mdr,mdw,ls,


wVD D VD(.wFil,.wFol,.wBase,"WRITE.txt","www/BE/",$$kmpBase,.devw) Q
hVD D VD(.hFil,.hFol,.hBase,"Temp-html-Page.html","log/",$$HBase,.devh) Q
mVD D VD(.mFil,.mFol,.mBase,"devIO.m","gmsa/rudev/",$$kmBase,.devm) S uFN="R" Q
lsVD D VD(.lsFil,.lsFol,.lsBase,"temp-ls-"_$J,"log/",$$kmpBase,.devls)
     ;D b^dv("Log ","lsFol,lsFil,lsBase")
     Q
mdrVD D VD(.mdrFil,.mdrFol,.mdrBase,"MDgenDemo.MDk","mdk/",$$kmpBase,.devmdr) Q
mdwVD D VD(.mdwFil,.mdwFol,.mdwBase,"MDgenDemo.html","www/BE/",$$kmpBase,.devmdw) Q
errVD D VD(.errFil,.errFol,.errBase,"Err.txt","www/BE/",$$kmpBase,.deverr) Q  ;See ^deverr
logVD D VD(.logFil,.logFol,.logBase,"Log.txt","www/BE/",$$kmpBase,.devlog) Q  ;See ^devlog
;*
;*   Single function per stem Read File to RF()  1st letters of label is stem, then uFN
;*$$ Entry  RefBy- test ^devTes, ^barQ1   :$$=Q-nullOK, deva, rFil,rFol,rBase,  RF()
devrRD(iFil,iFol,iBase) NEW Q,ir  S stem="r",uFN="RD"
   S Q=$$VD2(.rFil,.rFol,.rBase,.devr,.RF)
     I Q'="" D b^dv("devrRD file open failed.","Q,devr") Q Q
   S Q=$$RD(devr,.RF)
   Q Q
   
;*   i* explicitly
VD2(xFil,xFol,xBase,dev,RF)  ;x* is stem var
  I $G(iBase)="" S iBase=$G(xBase) I iBase="" S iBase=$$kmpBase
  i $G(iFol)="" S iFol=$G(xFol) I iFol="" ; ok to be null
  I $G(iFil)="" S iFil=$G(xFil) I iFil="" S iFil="README.txt" 
  S dev=$$dev(iFil,iFol,iBase)
  S Q=$$RD(dev,.RF)
  Q Q
;*  dev  
rVD D VD(.iFil,.iFol,.iBase,.devr,.RF)
    I $G(rBase)["//" D b^dv("Debug ?","rBase,dBase,xBase")
    Q
;*$$  usu Read M Rou (*.m)
mRM(iFil,iFol)  NEW Q  S Q="",mBase=$$kmpBase,stem="m",uFN="R"
  D mVD  S devm=$$dev(iFil,iFol,mBase)
  S Q=$$RD(devr,.RM)
  Q Q
;*$$  Hgen 
hW(iFil,iFol,iBase)  NEW Q  S Q="",stem="h",uFN="Wh" 
  I $G(iBase)'="" S hBase=iBase
  D hVD  S devh=$$dev(iFil,iFol,hBase)
  S Q=$$OFW(devh,.WH)  
  ; vs S Q=$$HG1^devHGen(devh, TI*, VVL ?
  Q Q
;*$$  MDk Read 
mdrR(iFil,iFol)  NEW Q  S Q="",mdrBase=$$kmpBase,stem="mdr",uFN="WMDgen"
  D mdrVD  S devmdr=$$dev(iFil,iFol,mdrBase)
  S Q=$$OFR(devmdr,.MDK)  
  Q Q  
;*$$  MDgen 
mdwW(iFil,iFol)  NEW Q  S Q="",mdwBase=$$kmpBase,stem="mdw",uFN="WMDgen"
  D mdwVD  S devmdw=$$dev(iFil,iFol,mdwBase)
  S Q=$$OFW(devmdw,.WMD)  
  ; vs S Q=$$HG1^devMDGen(devmdw, TI*, VVL ?
  Q Q  
;*$$
lsRLS(iFil,iFol)  NEW Q  S Q="",lsBase=$$kmpBase,stem="ls",uFN="R"
  D lsVD
  S devls=$$dev(iFil,iFol,lsBase)  ; not lsFil, lsFol  usu default
  S Q=$$RD(devls)
  Q Q
;*$$
lsW(iFil,iFol)  NEW Q  S Q="",lsBase=$$kmpBase,stem="ls",uFN="W"
  D lsVD
  S devls=$$dev(iFil,iFol,lsBase)  ; not lsFil, lsFol  usu default
  S Q=$$OFW(devls)
  Q Q
lsC  D CF(devls)  Q:'$Q  Q ""
;*$$  Write results of zsy to devls
lsWzsy(iFil,iFol,zsy)  NEW Q  S Q="",lsBase=$$kmpBase,stem="ls",uFN="Wzsy"
     I $G(zsy)="" S Q="Bug zsy missing" D b^dv(Q,"zsy,iFil,iFol") Q Q
     USE $P W:$X ! W "ZSY:",zsy,!
     I $E(zsy,1,3)'="ls " W "? Expecting ls cmd ??",!
     ZSY zsy_">"_devls
     D CFM(devls)  ;Close with message
     Q
;*$$
devw(iFil,iFol,iBase)  NEW Q  S Q="",wBase=$$kmpBase,stem="w",uFN="W"
  D wVD
  S devw=$$dev(iFil,iFol,wBase)  ; not wFil, wFol  usu default
  S Q=$$OFW(devw)
  Q Q
;*$$  cBD eliminated - caller should put in iFil, implied W uFN
deverr(iFil,iFol)  NEW Q  S Q="",errBase=$$kmpBase,stem="err",uFN="W"
    D errVD  S deverr=$$dev(iFil,iFol,errBase)
    S Q=$$OFW(deverr) I Q'="" Q Q
        I $$devopn(deverr)'="" S Q=$$OFW^devIO(deverr) I Q'="" Q "Unable to Open "_deverr
    D HdErr^deverr  ; write top of HGen page deverr
    Q Q
    Q
;*$$  implied W : devlog, devBase, devFol,devFil    RefBy: ^devlog^devlog, many
devlog(iFil,iFol)  NEW Q  S Q="",logBase=$$kmpBase,stem="log",uFN="W"
    I $G(iFil)="" S iFil="LogFile"
    DO  ; devlog one of two methods
      .I $G(iFol)="",$E(iFil,1,5)="/home" S devlog=iFil Q  ; iFil is full url
      .D logVD  S devlog=$$dev(iFil,iFol,logBase)
    S x=$ZSEARCH(devlog) I x'="" DO               ;replace devlog; dont stop in OFW
       .ZSY "rm "_devlog
       .S x2=$ZSEARCH(devlog)
       .I x2'="" D b^dv("Err cant remove devlog","devlog,x2,x")
    S Q=$$OFW(devlog) I Q'="" D b^dv("Error Failed to Open devlog","devlog") Q Q
    KILL ^MNU(0,"nLG")
    USE devlog
    D HdLog^devlog
    Q Q  ; Q is null
;*   *****  General, non stem-specific code
;*  Test if dev open	--dupl in ^deverr  - in case optional nested mRou using devlog
devopn(dev)  I $G(dev)="" D bug^dv Q
    NEW ZSH,D   ZSH "d":ZSH    MERGE D=ZSH("D")
    S dc=$G(D(dev)) I dc["OPEN" Q ""
    Q "NotOpen: "_dc
;*  :  kmBase, HBase, homeBase ( implicit outvars)  RefBy:  various ^<ns>Idev
;  See ^devIB  calc from $zro
B0     D ^devIB  ; SB, PB
       S homeBase=SB,kmBase=PB
       S HBase=SB_"H7r2/"
       ;D ^dv("Log No H7r2 equiv in hp5 and hp6; See ^devIB","zro,SB,PB")
       Q 
;*  RefBy:  ^fdIO proto
BASE(mpj)   D B0
       I $G(mpj)="" S mpj=""
       S kmpBase=$$kmpBase(mpj)
       Q
;*$$            --- See ^devIMG  or ^devIB
kmBase() D B0 Q kmBase
;*$$  mpj : mpj', kmpBase=$$ 
kmpBase(mpja) NEW zro D B0
	I $G(mpja)'="" DO  ;
	   .S zro=$zro 
	   .I zro[(mpja_"/o") S mpj=mpja Q
	   .D b^dv("Bug arg mpj(a) not in $zro with o/","mpja,kmBase,zro")
	I $G(mpja)="" D Mpj I mpj["//" D b^dv("Debug ","mpja,mpj,zro,len,z3,z2")
	S kmpBase=kmBase I mpj'="",kmpBase'[("/"_mpj_"/") S kmpBase=kmBase_mpj_"/" 
	Q kmpBase ; & var kmpBase
HBase()  D BASE Q HBase
homeBase() D BASE Q homeBase
;*
;*  $zro : mpj, hB ck eq homeBase;   mpj does NOT end in "/"
Mpj    NEW z2,z3,zro,len
       S z2=$P($zro," ",2),z3=$P(z2,"o(")
       I $E(z3)="/",z3["km",z3["/o" S hB=$P(z3,"/o")_"/" DO  
         .I hB'=HomeBase D b^dv("Err homeBase ","hB,homeBase,mpj")
       S len=$L(z3,"/"),mpj=$P(z3,"/",len-1)  ;Derive mpj from $zro
       ;D ^dv("Log Mpj^devIO  vs dbl KAcf mpj in Base","mpj,len,z3,z2")
       S zro=$zro I zro'[homeBase D B0err
       Q
B0err  D ^dvsch,b^dv("B0^devIO ?mpj vs $zro","zro,homeBase,kmBase,HBase")
       Q
;*  OPEN File AND Read if Array given  --- Confusing, Looping ?  $D and Call by Ref
OFR(devrr,RAo) NEW Q  S Q="?OFR" 
       I $G(devrr)="" S Q="Bug devrr" D b^dv(Q,"devrr") Q Q
       CLOSE devrr  ; safety for debugging
       OPEN devrr:(readonly:exception="G ofrE1^"_$T(+0))
       USE devrr:(rewind:exception="G ofrE2^"_$T(+0))
       S Q=""
ofrQ   I $G(RAo)'="",$D(RAo) S Q=$$RD(devrr,.RAo)  ; Caller should SET RX=0 so $D detects it sic
       Q:$Q Q   Q       
;*
ofrE1 S Q="Err Opening file- " D b^dv(Q,"devrr,exc") G ofrQ
ofrE2 S Q="Err Reading file- :" D b^dv(Q,"devrr") G ofrQ
;*
CF(devcls)  USE $P CLOSE devcls
        Q:$Q ""   Q
;* Close with message to $P
CFM(devcls) D CF(devcls) W:$X ! W "Completed ",devcls,!
        Q:$Q ""   Q
;*
;*$$  Open to Append
OFA(devwa,WER)  NEW Q S Q="?OFA"
       I $G(devwa)="" S Q="Bug devwa " D b^dv(Q,"devwa") Q Q
       OPEN devwa:(append:exception="G ofaE1^"_$T(+0))
       USE devwa:(exception="G ofaE2^"_$T(+0))
       S Q=""  ; falls thru
ofaQ   I $D(WER)=11 D WWER       
       Q Q
;*
ofaE1  S Q="Error Opening file to write- " D b^dv(Q,"devww,Q") CLOSE devww
       Q Q
ofaE2  S Q="Error Writing to devww " D b^dv(Q,"devww")
       G ofwQ       
;*  opt 2nd arg Array to write and close
OFW(devww,WER) NEW Q S Q="?OFW"
       I $G(devww)="" S Q="Bug devww " D b^dv(Q,"devww") Q Q
       CLOSE devww  ; debug safety
       ; S x=$ZSEARCH(devww) I x'="" S Q="File Exists " D b^dv(Q,"x,devww")  ; Q Q
       OPEN devww:(newversion:exception="G ofwE1^"_$T(+0))
       USE devww:(exception="G ofwE2^"_$T(+0))
       S Q=""  ; falls thru
ofwQ   I $D(WER)=11 D WWER
       Q Q
;*
ofwE1  S Q="Error Opening file to write- " D b^dv(Q,"devww,Q") CLOSE devww
       Q Q
;*
CFW(devww)  I $G(devww)="" Q
       CLOSE devww
       USE $P
       Q:'$Q  Q ""
;*
ofwE2  S Q="Error Writing to devww " D b^dv(Q,"devww")
       G ofwQ
;* Write WER() to cur dev (deverr or $P)
WWER    ;
       S wv="" F wi=0:1 S wv=$O(WER(wv)) Q:wv=""  W:$X ! W $G(WER(wv)),!
       W !
       D CFM(deverr)
       Q
;*$$ devrd is opened, =$I   rRF by dot-pfx-byreference
; fiddling 29dec22 NEW Q
RD(devrd,rRF) NEW Q,ri,ZEOF  
       S Q=$$OFR(devrd) I Q'="" Q "RD/OFR "_Q
       KILL rRF S rRF=0 USE devrd:(exception="G rdE2")
       F ri=1:1 R X S ZEOF=$ZEOF Q:ZEOF  S rRF(ri)=X,rRF=ri
       D b^dv("Q on ZEOF","ZEOF,ri,devrr")
rdE2   CLOSE devrd USE $P  ; EOF exception ? others
       Q ""
       
;*
