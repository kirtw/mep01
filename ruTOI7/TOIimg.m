TOIimg   ;CKW/ESC   i23jan18  ; 20180123-51 ; IMG for ^TOI*
  ;  in gmsa/  rTOI7/      8aug19    
  ; cp from gmsa/  rTOI3ucal/ 
  ;    See ^ddvar
  ;
A   S dtFL="d12,yr,mn,mjy,day,djw,apm,hr,min,wh,Lpr_Ddef"  ; for ^TOId Date-Time defaults
    D T^dws("dtFL=d12,yr,mn,mjy,day,djw,apm,hr,min,wh,Lpr_Ddef")
    S toiFL="sTFL,tFL,VNmode,WQP,dictL,vnd12,d8vn,vqlst,Cpx,Csx,cdL,wtL,cTS,ctxde_^TG(tsid)"    
    D T^dws("toiFL=sTFL,tFL,VNmode,WQP,dictL,vnd12,d8vn,vqlst,Cpx,Csx,cdL,wtL,cTS,ctxde_^TG(tsid)")
    Q
;*
;*  Init ^TG(0  DWL, MOL, XUw, XUv, XUl
;*  RefBy: ^TOIa
ITG  KILL ^TG(0)  NEW L,i
     D IDAT  ; Days of week, month names
     D IXU   ;Units Conversion: length, wt/mass, vol
     D IAN   ; TOI allowed vn direct set vn='value'
     D ITVN^TOIa  ; ^TOIa support
     Q
;*
IDAT NEW L,i
     S L="jan,feb,mar,apr,may,jun,jul,aug,sep,oct,nov,dec"
       F i=1:1:12 S ^TG(0,"MOL",$P(L,",",i))=i
     S L="january,february,march,april,may,june,july,august,september,october,november,december"
       F i=1:1:12 S ^TG(0,"MOL",$P(L,",",i))=i
     S L="mon,tue,wed,thu,fri,sat,sun" F i=1:1:7 S ^TG(0,"DWL",$P(L,",",i))=i
     D SDW("tues",2),SDW("thur",4),SDW("thurs",4),SDW("sa",6),SDW("su",7)
     Q
;*  Set misc day n combos
SDW(cd,n) S ^TG(0,"DWL",cd)=n
      Q
;*  Units conversion, XUm  wt/mass, XUv vol, XUl length
IXU  ;KILL ^TG(0,"XUw"),^TG(0,"XUv"),^TG(0,"XUl")  ; redundant to KILL ^TG(0)
     NEW L,i,p,u,n,x
     S L="1000 mg,.001 kg,1/454 lb,1/30 oz"  ; 1gm equivalents
     F i=1:1:$L(L,",") S p=$P(L,",",i),u=$P(p," ",2),n=$P(p," ") I u'="" S ^TG(0,"XUw",u)=$$xn(n)
     S L="1/30 T,1/30 TBSP, 1/10 tsp,1/240 cup,1/480 pint,1/960 quart,1/3840 gal"  ; 1ml equivalents
     F i=1:1:$L(L,",") S p=$P(L,",",i),u=$P(p," ",2),n=$P(p," ") I u'="" S ^TG(0,"XUv",u)=$$xn(n)
     S L=".01 m,.00001 km,1/2.54 in,12/2.54 ft,36/2.54 yd"  ; 1 mm equivalents
     F i=1:1:$L(L,",") S p=$P(L,",",i),u=$P(p," ",2),n=$P(p," ") I u'="" S ^TG(0,"XUl",u)=$$xn(n)
     Q
xn(n)   I n["/" X "S x="_n S x=x*1000000\1/1000000 Q x
     Q n
     Q  ; safety

;*  AN  qualifies TG vars for assign vn=val in sTFL for ^TOIa
IAN   KILL ^TG(0,"AN")  ;redundant
      NEW FL,ai,an
      I $G(toiFL)="" D ^TOIimg
      S FL=$P(toiFL,"_")
      F ai=1:1:$L(FL,",") S an=$P(FL,",",ai),^TG(0,"AN",an)=ai
      Q
;
dtFL  ;;
;;yr  year, ?4n  vs temporarily ?2n  (vs y2 ?2n )
;;mn  month, numerical 1-12 ?2n  saved with leading zero prn
;;     ~mjy
;;wjy wkn Week number within year, 1-53, No leading zero,
;;wh  serail week, $H analog
;;day Numerical day-of-month, 01-31,?2n (ld zero), depending on month & leapyear
;;      ~djw
;;apm am or pm, input, default in qaD("apm")
;;hr  hour 0:23
;;min minutes, 0-59
;;Lpr List of input transforms

; Not actually saved in D() - defualts
;
;;qaD()   Array of defaults values, from //  line
;;Dlst()  Prior Line values, ? default
;;Dlst Array of Values among lines, subsequent, ?usee - not yet
;;TD(vn)  temporary ^QD(lid)  read-back in ^TOItes
;;
;;
toiFL  ;;
;;tsid  subscript, mnemonic id, eg uC0, uC2  for uCal
;;sTFL  Orig Source Config List
;;pL
;;psL
;;
