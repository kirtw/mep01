dmnRT(mSys,mnuMRou)  ;CKW/ESC i26sep20 gmsa/ rd2menu/ ; 20200926-52 ; Read Menu $T to RM() Stage One Menu Compile
;;$$Q    then proceeds to ^dmnu via GoTo - (no additional stack levels)
;RefBy:
;  Goto A^dmnRT  mSys, mnuMRou
A     NEW Q  S Q=""
      I $G(mSys)="" S Q="Arg mSys ?" D b^dv(Q,"mSys") Goto Q
      S mpreVL=$G(mpreVL)  ; dis var list
      I $G(mnuMRou)="" D b^dv("Where ?","mnuMRou")  DO
        .I $T(^dzCallBy)'="" D ^dzCallBy DO  ;
           ..I caller["^dmn" Q
           ..S mnuMRou=caller
      I mnuMRou="" S Q="Err No menu source mnuMRou" D b^dv(Q,"Q,mSys,mnuMRou") Goto Q
      S T=$T(Menu^@mnuMRou)
        I T="" S Q="Can't find Menu^@mnuMRou" D b^dv(Q,"Q,mnuMRou,mSys") Goto Q
        D SRM  ; mnuMRou $T : RM()
        ; actually cannot override, does G ^dmnu next below
        I $G(mpreLR)="" S mpreLR="dis^dmnDIS"  ; default, caller can override in ^MNU(mSys,0,"dmnDIS")=<DashBd-entryRef>
        I mpreLR'["dis^",mpreLR'["dmnDIS"  DO   Goto Q
          .S Q="mpreLR must be <entryref  dis^ " 
          .D b^dv(Q,"mpreLR,mSys") 
        S ^MNU(mSys,0,"mpreLR")=mpreLR  ;not null
        KILL ^MNU(mSys,0,"mpreVL")
        I mpreVL'="" S ^MNU(mSys,0,"mpreVL")=mpreVL
        S ^MNU(mSys,0,"mnuMRou")=mnuMRou  ; source mrou for Menu data
        ;D ^dmnCom(mSys)  ; RM() -> ^MNU(mSys) and set "mSysCur")=mSys
        ;G ^dmnu
Q     Q:$Q Q
      Q
;*
SRM  	KILL RM NEW ri S ri=0,RM=0
        F RI=1:1 S L=$T(Menu+RI^@mnuMRou) Q:L["***"  Q:L=""  DO
          .S L=$TR(L,$C(9,13)," ")  ; tab -> space, remove cr
          .S T=$P(L,";;",2,9) I T'="" S ri=ri+1,RM(ri)=T,RM=ri
        ;D ^dvstk,b^dv("Log SRM ","RI,L,mnuMRou,RM")
        Q
        ;zwr RM  
      
