ep2SSi(ikey) ;  ? SSC replacement
;
; ruid - dot - IPs
;
top   I $L(iKey,",")'>2 D bug^dv Q
      NEW ruid,ruab,runa,IPs,IPe,IC,tokTy,tokR1
      S ruid=$P(ikey,"-")
      S dot=$P(ikey,"-",2)
      S IPs=$P(ikey,"-",3)
      D xid
      D dotLst ; dot, ruLst : tokTy,tokR1, IC
      
;*
xid   S FL="runa,ruab,tokTy,ruLst,tokCL"
      F vi=1:1:$L(FL,",") S vn=$P(FL,",",vi),@vn=$G(GRk(ruid,vn))
      Q
;* dot, ruLst : nLst, tokTy, tokR1,tokCL, IC
dotLst  S nLst=$L(ruLst,",")
      I tokTy="R" DO  ;
        .S tokR1=$P(ruLst,",",dot)
        .I dot>nLst S tokTy="C"
      I tokTy="T" DO  ;
        .S IC=$G(INc(IPc))
        .S tokCL=""
        .S tokR1=""
      Q
;*  Get item Char  IPs-IPe, Ins -> IC, wIC
getC  S IC=$E(Ins,IPs,IPe)
      S wIC="["_IPs_"-"_IPe_"] {"_IC_"}"
      Q
;*      
;*

