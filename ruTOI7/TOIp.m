TOIp(Tin,tsidp)  ;CKW/ESC i31mar18 gmsa./ rTOI7/ ; 20230101-87;Parse TOI input Tin, Profile tsid/tsidp
;   rev 1jan23 for fin3/ debug,ReFactor 4oct19 8aug19  
;
; Sequence Essential:  1) FQT separate quoted values/WD's, 2)  DSP once!, pre-WD-assignment wki
;  3) px/sx  Remove/"Used" before TOId which only looks 1st 3 WD ?   4) TOId  multi-wd, 
;  5) vn to assign wds in order, 6) vqlst  the last of vn in (5)  7)  Save @vn, VN(vn) or @G
;  Error messages deverr, tied to ri of TOIin file (not explicit herein)
;
  ; cp from gmsa/  rTOI3ucal/ then rTOI6/ 
  ;RefBy: FL4/  rfr4/  ^fr4TI1  ^TOIT tests,  TOI6: by KAcf/ rcash/...  Dev
  ;
  ;  per VNmode {L,A,G}  ->@vn or VN(vn), sTFL_2 @G 
  ;
  I $G(tsidp)="" S tsidp=$G(^TG(0,"tsidCur")) I tsidp="" D bug^dv S Q="9-No-tsid in" Q
  S tsid=tsidp  ; tsid is sys var, tsidp is arrg/new
  KILL TGA MERGE TGA=^TG(tsid)  ; Use Array
    ;DI(vnty,wd)=Wr  ;by caller, Units here (later)
    ;  vs DI(wd)=vnty_Wr   combined search, one test vs mult dictionaries
    ;  or DI(wd,vnty)=Wr  for mult hits
    ;
  I $G(Tin)="" KILL WD,Wdlc,Wvn,Wtr,Wty S TER="1-No-Tin" Q   ; Q TER
  D ^TOIimg  ; toiFL, tr9FL
;;toiFL:sTFL,tFL,VNmode,WQP,dictL,vndt,d8vn,vqlst,Cpx,Csx,cdL,wtL,cTS,ctxde_^TG(tsid)
  D GFL^dvs(toiFL)  ; tsid, ^TG(tsid,  all vn null or a value
  D III
  S VL=$P(tFL,"_") F wi=1:1:$L(VL,",") S vn=$P($P(VL,",",wi),"/") DO  ;
     .I $E(vn)?1p S vn=$E(vn,2,99)
     .I $E(vn,$L(vn))?1p S vn=$E(vn,1,$L(vn)-1)
     .I vn'="" S @vn=""  ; Init null vs NFL^dvs(dtFL)?
    ;D b^dv("Log NFL","VL")  ; also dumps list in VL ! Im so cute! 27mar23
  S T1=Tin I Tin["#" D Lpre  ; Tin : T1, TCom  Comments, tabs, ctrl...
    S T2=T1
    ;WQP is quote punctuation char list possibly including " '     
  ;I $G(WQP)'="" D FQT  ;Quotes handling T2 : T2', wpn^ markers in T2, Wqt(wpn)
  S de="" I T2[";;" S wki=98,de=$P(T2,";;",2,99),T2=$P(T2,";;") D S9("de",de)
  S T2=$$DSP^dvs(T2)
  I T2="" DO    Q  ;only spaces or #
    .;D b^dv("Net Blank","T2,T1,Tin,Tcom")
  ;I Tin["#" D b^dv("Test # Com vs pfx/sfx hash","Tin,T1,T2,Tcom")
  D WCP  ; T2 : nsp, wki WD(wki),Wpnd(),Wdlc
  I vndt'="" D ^TOId2 ;Date fields picked out
  S wki=0 F wn=0:1  S wki=$O(Wpnd(wki)) Q:wki=""  DO  ;
    .S WD=WD(wki),wd=Wdlc(wki)  I WD="" D b^dv("Redundant test","WD,wd,wki") Q
    .D PxSx Q:dQ    
    .D ^TOIn(WD) Q:dQ
    .F wdty="tty","ac","cat","ven" I $G(DI(wdty,wd))'="" DO  Q:dQ
       ..S Wr=$G(DI(wdty,wd))
       ..D S9(wdty,Wr)
    .D ^TOIpat Q:dQ
   ;Now match vnty with vn
  D ^TOIpd  ;Display Status
  D ^TOIsv  ; Save WD(), Wvn() -> @vn  vs vnMode
Q S Q=""   Q:$Q "" Q   ; Schizo call D ^TOIp  vs S Q=$$^TOIp...
;*
S9(Wty,Wr)
     S Wty(wki)=Wty
     S Wr(wki)=Wr
     S Wtr(wki)=Lpr,Lpr=""
     I $D(Wpnd(wki))'=1 D b^dv("Err already done","wki,Wpnd(wki)")
     KILL Wpnd(wki)
     S dQ=1
     Q
;*

;* Tin : T1, Tcom
Lpre  I $G(Tin)="" D bug^dv Q
  NEW c1
  S T1=Tin,Tcom="" 
  I T1[" # " S Wr(100)=$P(T1," # ",2,9),T1=$P(T1," # ")
  S c1=$E(T1) I c1="#" S Tcom=T1,T1=""  ; ? vars need setting
  ;D b^dv("Log Lpre","Tin,Tcom,T1,ri")
  Q
;*  
;*  Set WD()  T2 : nsp, WD(), WDt()
WCP  I T2["$ " DO  ;
       .S T=$P(T2,"$ ",2,9)
       .F i=1:1:$L(T) I $E(T,i)'=" " S T=$P(T2,"$ ")_$E(T,i,999) Q
       .D b^dv("Log fudge $-spaces","T2,T")
       .S T2=T
     S nsp=$L(T2," ") I 'nsp D b^dv("Nothing left in T2","Tin,T2,c1") Q
     F wki=1:1:nsp DO  ; ^ is quote marker prefix to Q-name
        .S WD=$P(T2," ",wki)
	    .S WD(wki)=WD  ;may be null
	    .S wd=$$LC(WD)
	    .S Wdlc(wki)=wd  ; Save vs redo $$LC in W
	    .S Wpnd(wki)=1   ;Wpnd $O  kill when used, assigned Wty
	    .I WD="" Q
	    .I WD["^" S wqi=+WD,WD(wki)=$G(Qwd(wqi)) D b^dv("Log set from quotes","wki,wqi,WD,wd")
     Q
;*$$
LC(X) Q $TR(X,"ABCDEFGHIJKLMNOPQRSTUVWXYZ","abcdefghijklmnopqrstuvwxyz")
     Q  ; safety
; Should be no ^ in actual TOI input ???, would fake out quote marker?, inhibit processing, Test if QP'=""
;*
;* Decide from WD Syntax Type, toity
PxSx S toity=""
     S sx="",p=$E(WD,$L(WD)) I p?1P DO   Q:dQ
         .S dQ=0 I Csx'[p Q  ;Not invoked suffix punct
Sx       .S v=$G(TGA("SX",p))         
         .I v="" D b^dv("Unrecog suffix","sx,v,WD,wki,T2,L0") Q
         .S sx=p,vn=v,toity="sx"
         .S WD=$E(WD,1,$L(WD)-1)
         .D S9(toity,WD)
         .S Wvn(wki)=v
     S px="",p=$E(WD) I p?1p DO  Q:dQ
         .S dQ=0 I Cpx'[p Q  ;Not invoked prefix punct  
Px       .S v=$G(TGA("PX",p))         
         .I v="" D b^dv("Unrecog prefix","sx,v,WD,wki,T2,L0") Q
         .S Wvn(wki)=v  ; 
         .S px=p,vn=v,toity="px"
         .S WD=$E(WD,2,999)     
         .D S9(toity,WD)
         .D b^dv("Log px ","wki,ri,p,WD,wd")         
     Q
;*
;*  Init sequence
III   KILL Wqt,WD,Wdlc,Wr,WDm,Wpnd,Wvn,Wtr
      I $G(devlog)="" S Q=$$Ilog() I Q'="" D b^dv("Error Opening devlog,deverr ","devlog")
      Q
;*$$ err : devlog, deverr
Ilog()  S Q=$$devlog^devIO("TOIp-log.html")
        I Q'="" D b^dv("Unable to Open devlog","devlog") Q 1
      S Q=$$deverr^devIO("TOIp-err.txt")
        I Q'="" D b^dv("Unable to Open deverr","Q,deverr,devlog") Q 2
      Q ""
;*
;*  T2 : T2', wqi # found, usu zero quoted values -> QW(-wqi), Replace in T2 with Marker ^Q1, ^Q2
; will NOT handle nested quotes, even diff or dbl quotes or escaped quotes...
FQT  S wqi=0,pN="?"
     I T2["^" D b^dv("Input text should not include ^ -used as suffix quote marker","T2,T2") Q
     F qi=1:1:$L(QP) S P=$E(QP,qi) I T2[P DO
       .S nQ=$L(T2,P) I nQ#2=0 D ER("Unmatch Quotes P","P,nQ,T2,T2") Q
       .F iq=2:2:nQ S wqi=wqi+1,Wqt(wqi)=$P(T2,iq),$P(T2,P,iq)=wqi_"^"
     Q     
;*
ER(M,VL) I $G(deverr)'="" D ^dver($G(M),$G(VL)) Q
     D ^dv($G(M),$G(VL))
     D ^dvstk,b^dv("Log ER","M,VL")
     Q
