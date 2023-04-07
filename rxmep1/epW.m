epW  ;CKW/ESC i31oct22 rMP1/ ;20221031-60;Write sr for parser data structures
;
;
;
;*
;*  GRi(gsq)=RPgr,   Gxq(runa,gi)=gsq
;  RPgr =1 is ruab, _2 is IPs, _3 is IPc, GRde(ruab)=rude  comment, for what ?
; This is all static after init setup by IG
WGR    W !!,"Grammar GRr() rules-"
       NEW gsq,ruab,ina,gi,ruab,ti,RPgr,rde,runa,ruLst,tok
       F gsq=1:1:GRi S RPgr=GRi(gsq)   DO  ;
         .W:$X ! W RPgr
         .D EXRP(RPgr)
         .W:$X ! W:$P(ruab,".",2)=1 runa,"  "
         .W ?10
         .F ti=1:1:$L(ruLst,",") S tok=$P(ruLst,",",ti) DO  ;
            ..S Tna=$G(WNa(tok)) I Tna="" S Tna=tok D b^dv("Err msg Lna ;4 ","tok,Tna")
            ..W Tna," "
       W ?40,"(",IPs,") ",!
       Q
;*
RPlodash ; _1 runa.gi / rusq, _2 IPs, _3 Ipe~Si, _4 dot, _5 ruLst, _6 frm, _7, _8
;*  Expand RP to locals
EXRP(RP,Swi,Swj)  I $G(RP)="" D bug^dv("Arg RP ","RP") Q
       S nRP=$L(RP,"_") I nRP'>4 D b^dv("Err _len RP 5 or 6","RP") Q
       S Swi=$G(Swi),Swj=$G(Swj)
       NEW P1
       S P1=$P(RP,"_",1)
       S ruab=$P(P1,"/")  ;runa.gi
       S runa=$P(ruab,".")  ; ~ left-hand side, name (no .ri ?)
       S rugi=$P(ruab,".",2)
       S rusq=$P($P($P(RP,"=",1),"/",2)," ")  ; grammar index number, gsi~gsq~rusq
         I rusq'=+rusq D b^dv("Err rusq should be integer","rusq,RP")
       S ruLst=$P(RP,"_",5)  ; comma list
       S dot=$P(RP,"_",4)  ; dot ptr into ruLst
       S IPs=$P(RP,"_",2)
       S IPe=$P(RP,"_",3)  ; = Si redundant
       S INse=$E($G(Ins),IPs,IPe)  ; Ins is input string
       S TokR1=$P(ruLst,",",dot+1)  ; may be null if done
       S rde=$G(GRde(ruab))
       ; audit
       I Swi'="",Swi'=IPe D b^dv("Err Swi not eq IPe_3","Swi,IPe,IPs,RPd")
       Q
;*
;*  Write one item ala Lua Loup format for comparison
; WNa substitutes full Lua name
; RP and rula, ruLst, dot, IPs
WKRP(RPd,Swi,Swj)  I $G(RPd)="" D bug^dv Q
       NEW runa,IPs,ruLst,dot,Lna,ti,tok
       S Swi=$G(Swi),Swj=$G(Swj)
       D EXRP(RPd,Swi,Swj)
       ;W:$X ! S Lna=$G(WNa(runa)) I Lna="" D b^dv("Missing Lna","runa") S Lna=runa
       ;W Lna," ",?8," -> "
       F ti=1:1:$L(ruLst,",")+1 S tok=$P(ruLst,",",ti) DO
         .I (dot+1)=ti W "  *  "
         .I tok="" Q  ; no more tok, extra to do dot at end
         .S Lna=$G(WNa(tok)) I Lna="" DO  ;
            ..D b^dv("Err Missing Lna of tok","tok,WNa,ti,rulst")
            ..S Lna=" ??? "
         .W Lna,"  "
       W ?50,"(",IPs-1,")",!
       Q
;*  SC()  Write all, Lua Loup Compatible output lines
WSC    W:$X !,"Complete Table-",!!
       NEW Si,Swi,Swj
       F Si=1:1:SC  Q:$D(SC(Si))=0  D WS(Si)
       W !!
       Q
;*  SC(Swi,Swj)
WS(Swi)  W:$X ! W !,"     ====== ",Si-1," ====== Sbi=",Swi," ",!
       F Swj=1:1 Q:$D(SC(Swi,Swj))=0  S RPw=$G(SC(Swi,Swj)) DO  ;
         .I RPw="" D bug^dv Q
         .D WRP(RPw)
       W !
       Q
;*  Write one item ala Lua Loup format for comparison
; WNa substitutes full Lua name
; RP and rula, ruLst, dot, IPs
WRP(RPd)  I $G(RPd)="" D bug^dv Q
       NEW runa,IPs,ruLst,dot,Lna,ti,tok
       S runa=$P(RPd,"."),ruLst=$P(RPd,"_",5),IPs=$P(RPd,"_",2),dot=$P(RPd,"_",4)
       W:$X ! S Lna=$G(WNa(runa)) I Lna="" D b^dv("Missing Lna","runa") S Lna=runa
       W Lna," ",?8," -> "
       F ti=1:1:$L(ruLst,",")+1 S tok=$P(ruLst,",",ti) DO
         .I (dot+1)=ti W "  *  "
         .I tok="" Q  ; no more tok, extra to do dot at end
         .S Lna=$G(WNa(tok)) I Lna="" DO  ;
            ..D b^dv("Err Missing Lna of tok","tok,WNa,ti,rulst")
            ..S Lna=" ??? "
         .W Lna,"  "
       W ?50,"(",IPs-1,")",!
       Q
;*
;*   INc(), INty()   Itb()
WIN   W:$X ! W !,"Inputs-"   NEW wi
      I $G(Ins) W !,"In str '",Ins,"'  "
      W !,"Ip: " F wi=1:1:INc W ?Itb(wi),wi," "
      W !,"lit " F wi=1:1:INc W ?Itb(wi),INc(wi)," "
      W !,"ty: " F wi=1:1:INc W ?Itb(wi),INty(wi)," "
      W !
      Q
;* Copy from ^dvs  same as ^dvc
	;Replace all dbl spaces (or more) with single, and remove starting/ending
DSP(X)	NEW i F i=0:1 Q:X'["  "  S X=$P(X,"  ")_" "_$P(X,"  ",2,9999)
	Q $$TSP(X)
	; Remove start and end spaces (only)
TSP(X)	NEW i S X=$TR(X,$C(9)_$C(10)_$C(13),"   ")  ;replace tab,lf,cr with space
	I $E($G(X))=" " F i=1:1:$L(X) I $E(X,i)'=" " S X=$E(X,i,999) Q
	I $E(X,$L(X))=" " F i=$L(X):-1:1 I $E(X,i)'=" " S X=$E(X,1,i) Q
	I X=" " S X=""  ; Funny case all spaces  vs end i=0 second line ?
	Q X
;*	
