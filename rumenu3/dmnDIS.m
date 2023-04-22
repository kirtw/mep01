dmnDIS  ;CKW/ESC  i26sep20 gmma/ rmFL/ ; 20200926-99 ; Std dis SR for ^dmnu Pseudo DashBoard
;
;  
;
top  ;
dis  ;
hsta NEW mSys,evdt
     S mSys=$G(^MNU(0,"mSysCur"))
     S evdt=$G(^MNU(0,"evdt8"))
     I evdt="" S evdt=$ZD($H,"YYYYMMDD")
     USE $P W:$X ! W "mSys: ",$G(mSys)  W "  Event Date (evdt?d8) :",$G(evdt),"  by^",$T(+0),!
     Q
hsta3  D DIS^tdMenu
     Q
;*  alt dis^caller  pre Menu top of screen    mpreLR="VL^dmnDIS"  gets you here, 
;*    mpreVL var list,, in ^MNU(mSys,0,vn)
VL  NEW mpreVL,vi,vn,val,v
    S mpreVL=$G(^MNU(mSys,0,"mpreVL"))
      I $G(mpreVL)="" S mpreVL="mSys,evdt"
    U $P W:$X !
    F vi=1:1:$L(mpreVL,",") S vn=$P(mpreVL,",",vi) I vn'="" DO  ;
      .S val=$G(^MNU(mSys,0,vn))
      .;S @vn=val  ;This may be problem, not helpful, confusing
      .S v=vn_":"_val
      .I $L(v)+$x>96 W !,?4
      .W v,"   "
    W:$X !
    Q
;*    
