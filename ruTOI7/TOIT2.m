TOIT2  ;CKW/ESC  i11oct19  ; 20191013-04;Test ^TOI ver2  $T and TCL() driven
   ; in gmsa/  rTOI7/   No Refs... in gmsa./  30mar23
;
;
;  Menu Op  toit.  FE  fl4Menu
TOIt  S Qt=""
      S Qt=$$T1(Qt)
      S Qt=$$T2(Qt)
      USE $P W:$X ! W "Completed TOI Test Series - "
      I Qt'="" W "Failed-",!,Qt,!!
      I Qt="" W "Passed All.",!
      Q
;*$$      Basic TOIa, TOIp Tests, PATtes below
T1(Qt) S Qt=$G(Qt)
      D RTX  ; $T(+I) -> TCL()
      S Qt=$$TTOI(Qt)
      Q Qt
;*$$  PATtes^TOIT3 
T2(Qt) S Qt=$G(Qt)
      D RTX^TOIT3  ; Exhaustive TOId Tests
      S Qt=$$TTOI(Qt)
      Q Qt
;*$$  err
TTOI(Qi,Tset)  S Qt=$G(Qi)  D ITC,^TOIimg
    I $D(TCL)'>9 S Q="Failed to find Test Set" D b^dv(Q,"TCL,Tset") Q Q
    KILL Ddef,Dlst ;Std No left over defaults
    F tci=1:1:TCL S TC=$G(TCL(tci)) DO  ;
      .I TC[":" S Tvn=$P(TC,":") I Tvn'="" S v=$G(VNT(Tvn)) DO  ;
        ..I v="" DO  Q
            ...I Tvn'?2.8A.2n Q  ; Ignore, eg colon in Tin or vn val eg json
            ...D b^dv("Err Tvn: not in TvnFL ","Tvn,TvnFL,Tset,tci,TC")
        ..S Tvn=v,@Tvn=$P(TC,":",2,99)
      .I TC["!" S t=$P(TC,"!") I t'="" S Tcmd=t DO  ;
        ..S t2=$P(TC,"!",2,99),t2=$$DSP^TOIs(t2)
        ..I Tcmd="CA" D CA Q
        ..I Tcmd="TA" S Qt=$$TA(Qt) Q
        ..I Tcmd="PTL" S Qt=$$PTL(Qt) Q  ; One Liner Tin after PTL!        
        ..I Tcmd="PL" S Qt=$$PL(Qt) Q
        ..I Tcmd="TL" S Qt=$$TL(Qt) Q
        ..D b^dv("Unrecog TCmd ! ","Tcmd")
    USE $P W:$X ! W "Completed Test Series TCL, Tset:",$G(Tset),!
    Q Qt
;* Compile TOIa
CA  I t2'="" S sTFL=t2  ; sTFL on CA!line
    I $G(sTFL)="" D b^dv("Need tsidT and sTFL before CA!","tsid,tsidT,sTFL") Q
    NEW (tFL,sTFL,tsidT,toiFL)  
    S Q=$$^TOIa(sTFL,tsidT)
       I Q'="" D b^dv("Err ^TOIa","Q,tsidT") Q
    S rja1=$$jL(toiFL)
      I rja1="" D b^dv("rja1 @toiFL null?","rja1,sTFL,toiFL,")
    KILL TGs MERGE TGs=^TG(tsidT)
    I '$D(TGs) D b^dv("No ^TG, TGs tsidT")
    S rja2=$$jA("TGs")
    Q
;*$$ Test TOIa Compile vs Expected
TA(Qi)  NEW Qt S Qt=$G(Qi)
    I rja1'=eja1 S:Qt'="" Qt=Qt_"," S Qt=Qt_"errA1"
    I rja2'=eja2 S:Qt'="" Qt=Qt_"," S Qt=Qt_"errA2"
    Q Qt
;*$$ COmbined PL and TL  PTL!
PTL(Qi) S Qp=$G(Qi)
    I t2'="" S Tin=t2
    S Qp=$$PL(Qp)  ; Tin, @toiFL  TOIp
      I Qp'="" Q Qp  ; b^dv in PL
    S Qp=$$TL(Qp)
    Q Qp    
;*$$  Process Line Tin, tsidT vs @tFL from TOIp
PL(Qi) NEW Qp,t,Q  S Qp=$G(Qi)
    D NFL^TOIs(tFL)
    S Q=$$^TOIp(Tin,tsidT)
      I Q'="" S:Qp'="" Qp=Qp_"," S Qp=Qp_Q Q Qp
      I tFL="" DO   Q Qp_",NulltFL"
        .D b^dv("Must have tFL from sTFL/CA ??","tFL,sTFL")
    S rjln=$$jL(tFL)
      I rjln="" DO  S Qp=Qp_Q   Q Qp
        .S Q=" Err null rjln of tFL"
        .D b^dv(Qp,"rjln,tFL,Tin") 
    S rjdt=$$jAG(dtFL)
    S rjdlst=$$jAG(dtFL,"_Dlst")
    Q Qp
;*$$
TL(Qi) NEW Qt  S Qt=$G(Qi)
   I rjln'=ejln S Qt=Qt_"errTOIp" DO  
     .USE $P D WTOIp^TOIw
     .W:$X ! W "rjln=",$G(rjln),!,"ejln=",$G(ejln),!
     .D b^dv("Pause TOIp Error","Qp,tsidT,tci,TC,Tin,sTFL")
  I $G(ejdt)'="" I ejdt'=rjdt D b^dt("Diff *jdt","ejdt,rjdt,tci,tsidT,Tin")
   Q Qt
;*$$ FL, local vars @FL  : j  json, sgl quotes  simple list, list order
; super var list to json
jL(FL) I $G(FL)="" D ^dvstk,b^dv("jL arg FL must not be null","FL") Q "1?"
    NEW:0 G,vi,vn,v  S G=$P(FL,"_",2),FL=$P(FL,"_")
    S vn=$P(FL,",")
      I vn'?1.A.3n D b^dv("vn1 fmt in FL","vn,FL") Q "2?"
    S j=vn_":'"_$G(@vn)_"'"
    F vi=2:1:$L(FL,",") S vn=$P(FL,",",vi) I vn'="" S v=$G(@vn),j=j_","_vn_":'"_v_"'"
    Q j
;*
; super var list to json from Array or MGbl not via @vn local
jAG(FL,G2) I $G(FL)="" D ^dvstk,b^dv("jL arg FL must not be null","FL") Q "1?"
    NEW:0 G,vi,vn,v  S G=$P(FL,"_",2),FL=$P(FL,"_")
      I $G(G2)'="" S G=$P(G2,"_",2)
    S vn=$P(FL,",")
      I vn'?1.A.3n D b^dv("vn1 fmt in FL","vn,FL") Q "2?"
    S j=vn_":'"_$G(@G@(vn))_"'"
    F vi=2:1:$L(FL,",") S vn=$P(FL,",",vi) I vn'="" S v=$G(@G@(vn)),j=j_","_vn_":'"_v_"'"
    Q j    
;* Array to json
jA(A) Q ""
    S j1="{",j2="}" I $G(A)="" D ^dvstk,b^dv("Err arg jA array name","A") Q "?1" 
    S D=$D(@A) I D<9 D b^dv("Non Array arg","A,j") Q "?2"
    I D#2 S v=$G(@A),j=A_":'"_v_"'"
    S ky="" I $O(@A@(""))'="" S j1=j1_"{",j2="}"_j2
      F ki=0:1 S ky=$O(@A@(ky)) Q:ky=""  DO
      .S v=$G(@A@(ky)),d=$D(@A@(ky))
      .S:ki j1=j1_"," S j1=j1_"'"_ky_"'"_":'"_v_"'"      
      .I d<9 S j1=j1_"'"_ky_"':'"_v_"'" 
      .S ky2="",j1=j1_"{",j2="}"_j2  F kj=0:1 S ky2=$O(@A@(ky,ky2)) Q:ky2=""  DO
         ..S v2=$G(@A@(ky,ky2))
         ..S:kj j1=j1_"," S j1="'"_ky2_"':'"_v2_"'"
    S j=j1_j2
    D b^dv("Log jA ","A,D,j,j1,j2,ki,ky,kj,ky2")
    Q j   
;*  Read $T to TCL()
RTX  
   KILL TCL S TCL=0
   F iT=1:1 S T=$T(TESpat+iT) Q:T'[";;"  DO  ;
     .S L=$P(T,";;",2,9) I L="" Q
     .S TCL=TCL+1,TCL(TCL)=L
   Q
;*
ITC  KILL VNT  S TvnFL="tsidT,sTFL,eja1,eja2,ejln,Tin"
     F vi=1:1:$L(TvnFL,",") DO  ;
       .S vn=$P(TvnFL,",",vi)
       .S VNT(vn)=vn
       .S vnc=$$LC^dvs(vn),VNT(vnc)=vn
     S (rja1,rja2,rjln)=""
     S (eja1,eja2,ejln)=""
     S tsidT="??",Tset="??"
     Q
;*
;*  Test ^TOI Pattern List (Null Tset)
TESpat ;  Either vn:value or Tcmd!   vn in TvnFL  test vis VNT(vn)=vn
;;tsidT:TestTOI1
;;sTFL:tesde,tesab.,/tescat,tesd12:dts_TES(tsid)
;;CA!
;;eja1:
;;eja2:
;;TA!
;;ejln:tesde:'Test One Results',tesab:'tes.',tescat:'/cat1',tesd12:'201910011200'
;;Tin:tes. 10/1/19 12pm /cat1 Test One Results
;;PL!
;;TL!
;;PL!tes. /cat1 1oct19 12pm Test One Results
;;PL!   /cat1 1oct19 tes. 12pm Test  One   Results
;;PL!12pm   /cat1 1oct19 tes.  Test One Results  
;;PL!Test One Results  tes. /cat1 1oct19 12pm 
;;PL!tes. /cat1 1oct19 12pm Test One Results  
