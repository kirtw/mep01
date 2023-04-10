devlogX(M,VL)  ;CKW/ESC  i10July18 gmsa/ rd2io/ ; 20181114-50 ; Log sr  devlog  HGen ?
  ;                 Refs:  ^dv, 
  ;  temp devlogX to avoid errs to devlog^devlog NOT top  21mar19
  ;
  I $G(VL)="" S VL=""
  I $G(M)="" S M="Logging Entry nos" I VL="" D b^dv("No params for ^dvLog") Q
  S ^MNU(0,"nLG",M)=$G(^MNU(0,"nLG",M))+1
  NEW D,vi,vn,val 
      S D=$IO 
      USE $G(devlog) W:$X ! W M,!   ; If devlog null or undef -> USE 0 ($P)
  I $G(VL)'="" F vi=1:1:$L(VL,",") S vn=$P(VL,",",vi) I vn?1A.9an DO
        .S val=$G(@vn) S:$D(@vn)=0 val="UNDEF" S:$D(@vn)>2 val="ARRAY"
        .I $L(val)>60 S val="Trunc:"_$E(val,1,60)
        .W:$X ! W "  ",vn,"='",val,"' ",!
  USE D 
  Q
;
;  Depends upon devlog being defined and OPEN already
;  If not open the USE devlog crashes
;    -- recog devlog not null and not open ?
;    -- could trap error and recover gracefully ?
;
;
;*  See devlog^devIO  vs toplabel conflict !  Need ^devlog(M,VL)
zdevlog(iFil,iFol,CBc)   KILL ^MNU(0,"nLG") ; U 0 W:$X ! D ^dvstk W "devlog^devlog  init call ",! B
    I $G(iFol)="" S iFol=""
    I $G(iFil)="" S iFil=""
    I $G(CBc)="" S CBc="" S:iFil="" iFil="Log-"
    E  S iFil="dvLog-"_CBc
    S devlog=$$devlog^devIO(iFil,iFol)
    I $$devopn^dver(devlog)'="" S Q=$$OFW^devio(devlog) I Q'="" Q "Unable to Open "_devlog
    S Q=$$OFW^devio(devlog)
    USE devlog
    D HdLog
    Q ""  ; return var in caller scope and $$devlog OPEN, started
;*    
;* RefBy: devlog^devIO  
HdLog  D DOCTYPE
       D html,hd
       Q
DOCTYPE ;W "<!DOCTYPE html PUBLIC ""-//W3C//DTD HTML 5.01//EN"" ""http://www.w3.org/TR/html5/strict.dtd"">",!
        W "<!DOCTYPE html>",!   ;HTML5
	Q       
;*
html W:$X ! W "<html>",!
     Q
hd   W:$X ! W "<head>" D TI,js,css W !,"</head>",!
     W "<h1>Log File</h1>",!,"<pre>",!
     Q
TI   W "<title>","Log","</title>",!
js   Q
css  Q
;* * *
htmlq  W:$X ! W "</pre>",!,"</html>",!
     Q
ftlog  W !,"End of Log File -",devlog,"  ",$ZD($H,"24:60 DDMONYY"),!
     Q
;*   
;*  End writing to devlog  was  clog^dvlg   
clog  I $G(devlog)="" Q
      NEW M,n
      I $$CLD(devlog)="" Q  ;was not opened 
      USE devlog D WnLG,ftlog,htmlq
      I devlog'="" CLOSE devlog
      USE $P W:$X ! W "Completed Log file -",devlog,!
      I $D(^MNU(0,"nLG")) D WnLG
      Q
;* Write Log Types Summary  nLG nodes in ^MNU  Counts of each type of Message, to $P
WnLG  S M="" F  S M=$O(^MNU(0,"nLG",M)) Q:M=""  S n=^(M)  W:$X ! W n,"x ",?5,M,!
      Q
;*
;*  Detect if dev/devlog is open, ret null if it is not open
CLD(dev)  NEW A,D,i   ZSH "D":A  KILL D MERGE D=A("D") KILL A
      F i=1:1 S D=$G(D(i)) Q:D=""  I D[dev,D["OPEN" Q  ;D is not null, it was open
      Q D