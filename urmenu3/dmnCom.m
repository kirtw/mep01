dmnCom(mSys,mpreVL,mpreLR)  ;CKW/ESC i28may16 gmsa/ rmenu3/;20220612-80; Compile Menu in RM() to ^MNU(mSys)
  ;;  RM(), mSys  : ^MNU(mSys,  
;Dependencies:  rd2mg/ ^dgmg  or rmgbFL3/ 
  ;  Compile Menu from TOI RM()  to ^MNU(mSys)     then MERGE MU=^MNU(mSys)  RM() Syntax Below
  I $zro'["rd2mg",$zro'["rmgbFL" S zro=$zro,Q="?zro dependency ^dgmg" D b^dv(Q,"zro")
  ;I $zro'["rd2c" S zro=$zro,Q="?zro dependency ^dvc" D b^dv(Q,"zro")  ; removed, DSP copy 17nov20
    I $G(mSys)="" S mSys="X" D b^dv("Need mSys Menu id","mSys")    ; Moved from %Com^dmnu
    I $D(RM)'>9 D b^dv("Menu needs to be in RM() array","RM,mSys") Q
    I '$G(RM) S RM=0 D b^dv("No count RM ","RM,ri") F ri=1:1 Q:'$D(RM(ri))  S RM=ri
    NEW:1 ri,L,mab,moi,dPRP,dDE,dnxt1,nsp,wi,m,W,nxt,ab
    NEW:1 mabFL,opFL,dopab,dopde,dopMnu,dopLR,dnxt2,TA,t1
    D ^dmnIMG    KILL ^MNU(mSys)  S moi=-9,mab=-8  ;In case bad syntax in RM()
    I $G(mpreLR)'="" DO  ;
      .I mpreLR'["dis^",mpreLR'["^dmnDIS" S Q="Err mpreLR" D b^dv(Q,"mSys,mpreLR,mpreVL") Q
      .S ^MNU(mSys,0,"mpreLR")=mpreLR
    I $G(mpreVL)'="" S ^MNU(mSys,0,"mpreVL")=mpreVL,^MNU(mSys,0,"mpreLR")="VL^dmnDIS"
    F ri=1:1:RM S L=RM(ri),L=$TR(L,$C(9,13)," ") I L'="" DO  ;Substitute tab, delete cr/13
      .I $E(L)'=" " D mnu Q
      .D op1L
    S mab=0 KILL ^MNU(-1,"ab")
    F mi=0:1 S mab=$O(^MNU(mSys,mab)) Q:mab=""  DO  ;
      .S ^MNU(mSys,-1,"ab",mab)=mab
      .F moi=1:1 Q:'$D(^MNU(mSys,mab,moi))  DO  ;
         ..S dopab=$G(^MNU(mSys,mab,moi,"dopab"))
         ..I dopab'="" S ^MNU(mSys,-1,"ab",dopab)=mab_"."_moi
    D mnL(mSys)  ; Create list of mab's, save it in ^MNU(0,"mnL")
    ;End sequence
    S ^MNU(0,"mSysCur")=mSys 
    S ^MNU(mSys,0,"curmab")="mm"
    S ^MNU(mSys,0,"mmo")="#"
    I $G(mpreLR)'="" S ^MNU(mSys,0,"mpreLR")=mpreLR  ;Kludge --> RM(), $T
    S ^MNU(mSys,0,"zro")=$zro
    KILL RM
    Q
;*
;* menu
;  L : @mabFL,  mab, dPRP, dDE, dnxt1, ^MNU(mSys,mab)
mnu   S nsp=$L(L," "),(mab,dPRP,dDE,dnxt1,dwd,newMenu)="",moi=0
      F wi=1:1:nsp S W=$P(L," ",wi) DO  ;
        .I W[".",$E(W,$L(W))="." S mab=$P(W,"."),$P(L," ",wi)="" Q
        .I $E(W)="$",dwd="" DO  I dwd'=""  Q
           ..S dwd=$P(W,"$",2) I dwd="" Q
           ..I $D(^MNU(dwd)) S newMenu=dwd Q
           ..
        .I W["|" S nxt=$TR(W,"|","") I nxt'="" S dnxt1=nxt,$P(L," ",wi)="" Q
      I mab="" S m=$P(L," ") I m?1A.an S mab=m,L=$P(L," ",2,99)
      I mab="" D b^dv("Menu Line Format?","L,ri") Q
      S dPRP=$P(L,"_"),dDE=$P(L,"_",2)  ; Rest split between prompt and dDE by _
      D SFL^dgmg(mabFL)
      Q
;* Option LR Label^MRou  or menu.           Custom TOI (sic)
;*  L, mab, moi' : @opFL,  ^MNU(mSys, mab,moi)
op1L  S nsp=$L(L," "),(dopab,dopLR,dopMnu,dopde,dnxt2)=""
      S moi=moi+1  ;blank if syntax error
      F wi=1:1:nsp S W=$P(L," ",wi) I W'="" DO  ;
        .I $E(W)="$" S dopMnu=$TR(W,"$.",""),$P(L," ",wi)="" Q  
        .I $E(W,$L(W))="." S ab=$P(W,".") DO  Q
           ..I ab'="",$D(^MNU(mSys,ab)) S dopLR=W,$P(L," ",wi)="" Q
           ..I ab'="" S dopab=ab,$P(L," ",wi)="" Q
        .I $E(W)="|" S W=$P(W,"|",2) I W'="" S dnxt2=W,$P(L," ",wi)="" Q
      S TA=$$DSP(L),nsp=$L(TA," ")
        I dopMnu="" S t1=$P(TA," ") DO  ;
          .I t1["^" S dopLR=t1,$P(TA," ")="" Q
          .I dopLR="" D ^dv("Failed to Find Destination Label^MRou","dopLR,ri,L,nsp,TA,t1,mab,moi")
      S dopde=TA  ;What ever's left
      D SFL^dgmg(opFL)  ; mab, moi : ^MNU(mSys,mab,moi)
      Q
;  Ref by ^dmnu
;*  mSys : mab list mnL
mnL(mSys)  I $G(mSys)="" D b^dv("Need mSys","mSys") Q
    I $D(^MNU(mSys))'=10 D b^dv("Need ^MNU(mSys)","mSys") Q
    NEW:1 MX,mnLX,mnL,mi,mab
    S mnLX=$G(^MNU(mSys,0,"mnL"))
    S mnL="mm"   S MX("mm")=1
    S mab=0 F mi=2:1 S mab=$O(^MNU(mSys,mab)) Q:mab=""  DO
      .I $G(MX(mab))'="" Q
      .D AMnu(mab)
      .F moi=1:1 Q:$D(^MNU(mSys,mab,moi))=0  DO
         ..S mnu=$G(^(moi,"dopMnu")) I mnu="" Q
         ..D AMnu(mnu) Q
    S ^MNU(mSys,0,"mnL")=mnL
    Q
AMnu(mnu)  I $G(mnu)="" D b^dv("Bug","mnu,mSys") Q
    I $D(MX(mnu)) Q  ;already done
    S mnL=mnL_","_mnu,mi=mi+1,MX(mnu)=mi
    Q    
;*
;*  Replace all dbl spaces (or more) with single, and remove starting/ending
DSP(X)	NEW i F i=0:1 Q:X'["  "  S X=$P(X,"  ")_" "_$P(X,"  ",2,9999)
	Q $$TSP(X)
;*  Remove start and end spaces (only)
TSP(X)	NEW i S X=$TR(X,$C(9)_$C(10)_$C(13),"   ")  ;replace tab,lf,cr with space
	I $E($G(X))=" " F i=1:1:$L(X) I $E(X,i)'=" " S X=$E(X,i,999) Q
	I $E(X,$L(X))=" " F i=$L(X):-1:1 I $E(X,i)'=" " S X=$E(X,1,i) Q
	I X=" " S X=""  ; Funny case all spaces  vs end i=0 second line ?
	Q X
;*
;  Syntax
;menu -  Lines with NO indent(no starting space) -> menu lines
;     ab.  menu abbreviation, ref anywhere
;     |menu  destination menu after running menu  dnxt1
;     Prompt  _  description
;  op - Lines with indentation  destination run Label^MRou (dopLR)
;     ["^"  Label^MRou  - not tested for existence here
;     $menu  Destination is another menu - use ab. with or without the period
;     abbr.  abbr for option 
;     |  menu after op is RUn  - does not loop back to same menu
;     Descr which is prompt in menu list as well (not two ?)
;
