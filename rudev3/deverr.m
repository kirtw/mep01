deverrX(M,VL)  ;CKW/ESC  gmsa/ rd2io/  ; 20180916-48 ; ER sr log to deverr, nER Count
     ; Entry labels: ^, init, cler    first label temp not deverr to avoid confict refs
     ;      See deverr^devIO like other profiles
     ;
  I $G(M)="" S M="Err? "
  I $G(VL)="" S VL=""
  NEW D,vi,vn,val,C1,C2 S D=$IO
  S C1=$$^dvby()  ;C1 ^dver, C2 caller
    S M="^"_C2_" "_M
    ;I $I=$P W !!,"RefBy ",C1," and ",C2,!
  I $G(deverr)="" S deverr=""
  I $G(deverr)'="",$G(M)'=""  DO  ;
    .S ^MNU(0,"nER",deverr,M)=$G(^MNU(0,"nER",deverr,M))+1  ; sic Non-specific to process
  I deverr'="" USE deverr  ;USE:$G(deverr)'="" deverr 
  E  USE $P
  W:$X ! 
  I deverr'="" W !
  S:$G(M)="" M="Undef Error" 
  W M,!
  I $G(VL)'="" F vi=1:1:$L(VL,",") S vn=$P(VL,",",vi) I vn?1A.9an DO
        .S val=$G(@vn) S:$D(@vn)=0 val="UNDEF" S:$D(@vn)>2 val="ARRAY"
        .I $L(val)>60 S val="Trunc:"_$E(val,1,60)
        .W:$X ! W "  ",vn,"='",val,"' ",!
  USE D
  Q
;
;  Depends upon deverr  but if UNDEF, uses $P or USE 0  conveniently
;  If not null or zero, deverr must be opened already. See deverr^dver
;
; RefBy: 8mar20 km6a/
GetCaller ZSH "S":%ZSH S ZL=$ZL-2,Caller=%ZSH("S",ZL)
      U $P W !!,"^dver Caller:",Caller,!
      Q
;
;  eg.  S deverr=$$deverr^dvIpg("TA-^"_$T(+0)_"-err",,"T2DM")  ; in TA^fqSI
;         which also OPENs deverr !
;  See deverr^devIO  for init and first write top of page
Xinit(iFil,iFol,CBc) I $G(CBc)="" S CBc=""
    KILL ^MNU(0,"nER")  ; init Er Msg count, sic MGbl somewhere
    S errFil="dver-Test-Errors"_CBc I CBc="" S CBc="^?"  ;Not in deverr
    I $G(iFil)'="" S errFil=iFil
    S Q=$$err^devIO(errFil,$G(iFol))  ; : deverr
      ;I Q'="" D b^dv("Err Opening dver deverr","Q,deverr") Q
    I $$devopn(deverr)'="" S Q=$$OFW^devIO(deverr) I Q'="" Q "Unable to Open "_deverr
    USE deverr
    D HdErr
    Q ""  ; return var in caller scope and $$deverr OPEN, started
;*  Test if dev open
devopn(dev)  I $G(dev)="" D bug^dv Q
    NEW ZSH,D   ZSH "d":ZSH    MERGE D=ZSH("D")
    S dc=$G(D(dev)) I dc["OPEN" Q ""
    Q "NotOpen: "_dc
;* RefBy:  deverr^devIO
HdErr  USE deverr
       D DOCTYPE
       D html,hd
       Q
DOCTYPE ;W "<!DOCTYPE html PUBLIC ""-//W3C//DTD HTML 5.01//EN"" ""http://www.w3.org/TR/html5/strict.dtd"">",!
        W "<!DOCTYPE html>",!   ;HTML5
	Q       
;*
html W:$X ! W "<html>",!
     Q
hd   W:$X ! W "<head>" D TI,js,css W !,"</head>",!
     W "<h1>","Error Report File"
     I $G(CBc)'="" W " - ",CBc," "
     W "</h1>",!,"<pre>",!
     Q
TI   W "<title>","Err-"_$G(CBc),"</title>",!
js   Q
css  Q
;* * *
;*
htmlq  W:$X ! W "</pre>",!,"</html>",!
     Q
fterr  W !,"End of Error file -",deverr,"  at ",$ZD($H,"24:60 DDMONYY"),!
     Q
;*   
;*  End writing to deverr-  ala clog     
cler  I $G(deverr)="" Q
      I $$CLD(deverr)="" Q  ;was not open
      USE deverr D fterr,htmlq
      I deverr'="",$G(devlog)'=deverr CLOSE deverr
      USE $P W:$X ! W "  Completed Error file - "
      I '$D(^MNU(0,"nER")) W "  No Errors!  ",!
      E   DO  ;
        .S dev="" F  S dev=$O(^MNU(0,"nER",dev))  Q:dev=""  DO
           ..S M=0 F  S M=$O(^MNU(0,"nER",dev,M)) Q:M=""  S n=^(M)  W:$X ! W "   ",n,"x ",?5,M,!
      W:$X ! W "   ",deverr,!
      Q
;*  Close deverr if its open
CLD(dev)  ZSH "D":A  KILL D MERGE D=A("D") KILL A
      F i=1:1 S D=$G(D(i)) Q:D=""  I D[deverr,D["OPEN" Q
      Q D
;*

      
      
