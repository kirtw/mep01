ep2Dbg ;CKW/ESC i14dec22 umbr./ rmep2 ;20221214-97;Debug Ref db
;
;
;
;  SSq serial items
; ikey  core data   ruid~rule, dot~next, IPs~start,  and IPe~Si
;  ^epaMenu  d2.
top    KILL
       D IG00^ep2G0  ; Get GRk,Gxi Grammar
       I $G(grFL)="" D ^ep2IMG
       S Ins="1+(2*3+4)"   ; S nIns=$L(Ins)
       D IRk
       Q
;*
IRk    KILL RIQ,RIK,RIx  
       S SSq=0 F I=1:1 S T=$T(Rkeys+I),L1=$P(T,";;",2) Q:T=""  Q:T["***"  DO  ;
         .S L=$$DSP^ep2W(L1)
         .S Sij=$P(L," "),ikey=$P(L," ",2),SSq=SSq+1
         .I $L(ikey,"-")<3 D b^dv("Err in Ref TOI","SSq,ikey,L1,L,T,I")
         .S RIQ(SSq)=Sij,RIK(SSq)=ikey,RIx(Sij)=SSq
       Q
;*  Expand ikey ruid, dot, IPs, IPe  to full item, using GRk
XkItem(ikey)  I $G(ikey)="" D bug^dv Q
       S VL="ruid,dot,IPs,Ipe" F vi=1:1:$L(VL,",") S vn=$P(VL,",",vi),@vn=$P(ikeuy,"-",vi)
       D GFL^jfm(grFL)
       D getR1^ep2W ; dot, ruLst : tokTy, tokR1, tokCL
       D getIC^ep2W ; Ips,Ipe, Ins : IC

;*
;*  GRk(ruid)=@grFL,   Gxi(runa,gi)=ruid ?
FLg0   ;;grFL:runa,ruab,ruty,ruLst,nLst,tokCL,nLCL,Lna,rde_GRk(ruid)       
;*       
Rkeys  ;; Reference SSC ikey expected in SSq order     ruid-dot-IPs-IPe  
;;1.1 1-1-1-0
;;1.2 2-1-1-0
;;1.3 3-1-1-0
;;1.4 4-1-1-0
;;1.5 5-1-1-0
;;1.6 6-1-1-0
;;1.7 7-1-1-0
;;1.8 8-1-1-0
;;2.1 7-2-1-1
;;2.2 8-2-1-1
;;2.3 7-1-1-0
;;2.4 8-1-1-0
;;2.5 6-2-1-1
;; ***  end of table

