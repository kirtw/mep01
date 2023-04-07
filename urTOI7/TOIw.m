TOIw  ;CKW/ESC  i3oct19 ; 20191013-04 ; Display Parse Arrays
  ; in gmsa/  rTOI7/     new in v7
;
;$I by caller, <pre> if HGen
;   TIn,T2,L2,   Ins, nsp, nvi   wi, Wu, WD, Wd, WDm, Wvq, Wvn, Wtr
;
;Arrays  (wi) each
;   Wpnd
;   WD raw word
;   Wd  $$lc   ?ctrl/tab clean/sub ?
;   Wr Modified val Result
;   Wvn  var name destination
;   Wtr  Trace logic
; Also: Wind, nsp, nvi
A   D WTOIa
    D WTOIp
    D WFL
    Q
;*  ^TOIa Write  Compiled-Config Result  ^TG(tsid
;   sTFL list of vn/vty  with punct
;   vTFL list of vn only, vki order
;*  var tsid  or list tsidL arg  (sic)
WTOIa(tsidL)  
    NEW (tsidL,tsid)  ; Leave Everything alone, incl @vn, @toiFL, call to debug mid processes
    D ^TOIimg
    I $G(tsidL)="" S tsidL=$G(tsid)
    F tI=1:1:$L(tsidL,",") S tsid=$P(tsidL,",",tI) I tsid'="" D Wts
    Q
;*   tsid, ^TG,    
Wts 
;*
Wts0    D GFL^dvs(toiFL)  ; tsid, ^TG(tsid) @toiFL x10?
    D T^dws("toiFL=sTFL,tFL,VNmode,WQP,dictL,vnd12,d8vn,vqlst,Cpx,Csx,cdL,wtL,cTS,ctxde_^TG(tsid)")
    W:$X ! W !,"TOIa Compiled Config, of '",$G(tsid),"'  - ",!
    S FL=$P(toiFL,"_") F ti=1:1:$L(FL,",") S an=$P(FL,",",ti) DO    ; GFL ?
      .S v=$G(@an) I v="",$D(@an)#2=0 S v="UNDEF."
      .W:$X !,an,"='",v,"' ",!
    W "sTFL:",sTFL,!
    MERGE TG=^TG(tsid)  
    W !!,"^TG(tsid)- as TG - ",!
    I $D(TG) zwr TG W !
    MERGE TGA=^TG(tsid)    
    W !!,"^TG(tsid)- as TGA - ",!
    I $D(TGA) zwr TGA W !
    W:$X !
    Q
    
;*  ^TOIp results, One Line parse
WTOIp  
    NEW (tci,tI,Tin,L2,T2,tFL,sTFL,Wind,nsp,nvi,tsid,Wpnd,WD,Wd,WDm,Wvn,Wty,Wtr,Wvq)
    ;NEW tb,tbL,hdL,ti,wi,vki,vi,n
    W:$X ! W "^TOIp One Line Results-",!
    I $G(tci) W "tci: ",$G(tci),"   " W:$G(tI)'="" " tI:",$G(tI) W !
    W !,"Tin:'",$G(Tin),"'",!
    W "T2:'",$G(T2),"' ",!
    W "L2:'",$G(L2),"' ",!
    W:$G(Wind) "   Indt:",$G(Wind)
    W:$G(nsp) "   nsp:",$G(nsp)  
    W:$G(nvi) ",  nvi:",$G(nvi)
    W !!
    S n=$G(nsp) I 'n D b^dv("Lost nsp ?","nsp,WD") Q
    S tbL="4,4,10,10,10,5,8,8,15"
    S hdL="wd#,Used,WD,wd,WD',viq,vn,ty,trace"
    S tb=0 W:$X ! F ti=1:1:$L(tbL,",") S tb=tb+$P(tbL,",",ti) W $P(hdL,",",ti)," ",?tb
    S wki=0 F wn=0:1 S wki=$O(Wpnd(wki)) Q:wki=""  D Wr1(wki)   ;
    S vki=90 F vi=0:1 S vki=$O(WD(vki)) Q:vki=""  D Wr1(vki)
    W !
    D XREF
    I Uref'="" W "Unreferenced by TOIa *TFL: ",Uref,!
    I Uset'="" W "Un set (not found in Tin): ",Uset,!
    W !!
    Q
;*  wi is 1:1:nsp then "dts" ...
Wr1(wi)   W:$X ! S tb=0 
      W wi D wt(4)
      W $G(Wpnd(wi)) D wt(4)
      W $G(WD(wi)) D wt(10)
      W $G(Wd(wi)) D wt(10)
      W $G(WDm(wi)) D wt(10)
      W $G(Wvq(wi)) D wt(5)
      W $G(Wvn(wi)) D wt(8)
      W $G(Wty(wi)) D wt(8)
      W $G(Wtr(wi)) D wt(15)  ;tot 67    
    Q
;*  tFL
WFL NEW FL,vi,vn,v,D
    S FL=$P(tFL,"_") F vi=1:1:$L(FL,",") S vn=$P(FL,",",vi) DO  ;
      .W:$X ! W vn,"="  
      .S D=$D(@vn) I D=0 W "UNDEF.",!  ; ?vde
      .E  S v=$G(@vn) W "'",v,"' ",!
    Q
;*    
XREF  NEW VN,vn,vi,wdi  S (Uref,Uset)=""
    F vi=1:1:$L(tFL,",") S vn=$P(tFL,",",vi),VN(vn)=1
    S wdi="" F wi=0:1 S wdi=$O(Wvn(wdi)) Q:wdi=""  DO  ;
      .S vn=$G(Wvn(wdi))
      .I $G(VN(vn)) KILL VN(vn) Q
      .S Uref=Uref_","_vn
    S vn="" F vi=0:1 S vn=$O(VN(vn)) Q:vn=""  S Uset=Uset_","_vn
    S Uref=$E(Uref,2,999),Uset=$E(Uset,2,999) ; remove any leading comma
    Q
;*
wt(n) W:$X=tb "." W " " S tb=tb+n W ?tb Q  ; tricky when val was null write a dot
;*
