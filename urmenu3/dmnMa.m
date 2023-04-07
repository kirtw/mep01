dmnMa(mSys,MRou)  ;CKW/ESC   i20may18 gmsa/ rd2menu/  ; 20180520-55 ; Capture *Ma Menu ops
  ;   in   T2DM dev
  ;	MRou = "qdMa.m"  for T2DM
  ;
  ;  Supplement to ^dmnCom  Compile
  ;   ^
top  I $G(mSys)="" D BUG^dv Q
     I $G(MRou)="" D BUG^dv Q
     I $D(^MNU(mSys))=0 D b^dv("mSys not in ^MNU ?","mSys,MRou") Q
     I $T(@MRou^@MRou)="" D b^dv("MRou undef?","MRou,mSys") Q
     NEW moi,mab,mi,C2,T,II,dopab,dopde,dopLR,opFL,LB
     D IMG^dmnCom  ; opFL
; access MRou via $T for now
    ;D GIX
    D RMRT(MRou)   ; : RU(ri)   whole MRou  vs sel labels
    Q
;*
;* Read $T MRou 
RMRT(MRou) I $G(MRou)="" D b^dv("Bug","MRou") S MRou="qdMa",dopMnu="qdMa"
    S moi=0,mab="ma"   S ^MNU(mSys,-1,"ab",mab)=mab  ; ?What Kludge
    F II=1:1  S T=$T(@MRou+II^@MRou)  Q:T=""  D Topt
    Q
;* T, mab, moi+,  
Topt   S C2=$P(T,";;",2) I C2="" Q
      D NFL^dvs(opFL)
      S T=$TR(T,$C(9)," "),LB=$P(T," ") I LB="" Q
      S dopLR=LB_"^"_MRou
        I $G(CBx(dopLR))'="" 
      S dopab=LB
      S dopde=C2
      S moi=moi+1
      D SFL^dvs(opFL)  ; mSys, mab, moi : @opFL  ^MNU(mab,moi)
      I dopab'="",$D(^MNU(mSys,-1,"ab",dopab))=0 DO  ;
        .S ^MNU(mSys,-1,"ab",dopab)=mab_"."_moi
      U $P W:$X ! W moi,") ",mab,"  ",?10,dopab,"  ",?20,dopde,!
    Q
;* Scan ^MNU and compose IX="cb"   in ^CBx
GIX   KILL ^CBx
      S mab="" F mi=0:1 S mab=$O(^MNU(mSys,mab)) Q:mab=""  DO  
        .F moi=1:1 S dopLR=$G(^MNU(mSys,mab,moi)) Q:dopLR=""  DO  ;
           ..I dopLR="" Q
           ..I dopLR["^" S GBx(mSys,"cb",dopLR)=mab_"."_moi
        .Q
      Q
      
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 