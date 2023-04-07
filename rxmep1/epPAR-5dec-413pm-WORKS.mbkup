epPAR  ;CKW/ESC i31oct22 ;20221202-46;Parse INc(),INty  into Gr Grammar...
;
;  GRi(gsq)=RP  _5 part readable extras  See EXRP^epW  to expand
;  Gxi(<rule-name>,gi)=isq  ;  ~ left-hand-side name index, mult rules, gi
;
;  INc(Ip)=literal input chars, from Ins, a string of chars
;  INty(Ip)= type  {
;
;  SC items or rules have 8 _ pieces (aka dotted-rule, item, 
;   ruLst:   _5 is ruLst a comma list of tokens- rule-names or terminal-set-names)
;   Pdot:  _4 is dot, a ptr into the current ruLst comma pieces
;   Ips    _3 is the input start pointer, Ips
;   IPe   _2  is the end-ptr into Ins, implicitly==Si in Lua
;   debug who did this item, {scan, }
;    
top    W !!,"Magic  Parsing !"
       D initSC
       D main
       D WSC^epW  ; Full Table
       Q
       ;
main   ; loop thru INputs, Ip BUILD analog
       F Sbi=1:1 Q:Sbi>SC   W !!,"Build Loop1 ",Sbi,! DO  ;
         .F Sbj=1:1 Q:Sbj>$G(SC(Sbi))  DO  D EL2 ;
           ..S RPitem=$G(SC(Sbi,Sbj))  ; 
           ..   I RPitem="" D bug^dv("Err no RPitem","RPitem,Sbi,Sbj") Q
           ..S trc="?"
           ..D EXRP^epW(RPitem)  ; Sbi,Sbj expand item TokR1,dot,ruLst
           ..W !,"Build inner loop2 ",Sbi,".",Sbj,"  ",RPitem,!
           ..; rule loop, item-loop, within one SCi
           .. I Sbi=2,Sbj=9 D b^dv("Log pre 2.9 ","TokR1,dot,ruLst,IPs,IPe,RPitem")
           ..I TokR1=""  D COMPLETE(Sbi,Sbj,RPitem,IPs,runa)  Q  ; 
           ..I TokR1["+" D SCAN(Sbi,Sbj)  Q  ; token with + is terminal
           ..D PRED(Sbi,Sbj,TokR1) Q ;inside loop chart items/rules
           ..D b^dv("Err illegal rule.?","TokR1,RPi,Sbi,Sbj")
       D b^dv("Log End BUILD  ","Sbi,SC,Sbj")
       Q
;*   end each double loop
EL2    W:$X ! W "End inner ",Sbi,",",Sbj,"   trace:",$G(trc),"  "
       ;I $G(SC(Sbi+1))="" S SC(Sbi+1)=0
       I Sbi=2,Sbj=9 D b^dv("Log post 2.9 ","TokR1,dot,ruLst,IPs,IPe,RPitem")
       Q
;*         
;*  Sbi, Sbj        
PRED(Spi,Spj,TokR1)  ;NEW Spj
       I $G(TokR1)="" D b^dv("Err TokR1 should not be null here","TokR1,Sbi,Sbj,Spi") Q
       I Spi'=Sbi D b^dv("Maybe Err ?","Sbi,Spi,Spj")
       ;I $D(Gxi(TokR1))=0 D bug^dv
       ;For every grammar rule with name=TokR1-
       F gi=1:1 Q:$D(Gxi(TokR1,gi))=0  S rusq=$G(Gxi(TokR1,gi)) DO
         .I rusq="" D b^dv("Err rusq from Gxi(TokR1)","rusq,TokR1,gi") Q
         .S RPgr=GRi(rusq)  ;
         .S frm="Pred fr:"_Spi_"."_Spj
         .S $P(RPgr,"_",2)=Spi  ; IPs item.start
         .S $P(RPgr,"_",3)=Spi  ; IPe is implicit always == Si
         .S $P(RPgr,"_",6)="PRED"
         .;D ^dv("Log pred Add Item rule: ","TokR1,gi,rusq,RPgr")
         .;W:$X ! W "Pred add ",RPgr,!         
         .D SSC(Spi,RPgr,frm) ; save in this State Sbi at end
       ;D PZE
       Q
;*
RPlodash ; _1 runa.gi / rusq, _2 IPs, _3 Ipe~Si, _4 dot, _5 ruLst, _6 frm, _7 Sk, _8 IPs-IPe/chars
;* Sbi,Sbj
SCAN(Ssi,Ssj) ;I Ssi=1 D ^dv("No Input Si=1","Ssi,Ssj,TokR1,RPitem") Q
       S IPc=Ssi
       S C=INc(IPc) I C="" D b^dv("Err C ","C,IPc,Ssi,Ssj") Q
       S CL=$G(ITcl(TokR1)) 
         I CL="" D b^dv("Err Char list ITcl(TokR1)","CL,TokR1,C")
       ;I TokR1'=ty Q
       D b^dv("Log test sc ","C,Ssi,Ssj,RPitem,TokR1")
       I CL'[C  D ^dv("Log '"_C_"' not in "_TokR1,"C,CL,TokR1,Ssi,Ssj") Q  ;Punt, non-match
       ;Here matched terminal, C in CL, ITcl(TokR1)
       S RPdi=SC(Ssi,Ssj) D EXRP^epW(RPdi)        
         I dot'=$P(RPdi,"_",4) D b^dv("Err dot","dot,RPdi")
       S $P(RPdi,"_",4)=dot+1
       S $P(RPdi,"_",6)="SCAN"
       S frm="scan fr:"_Ssi_"."_Ssj
       S Ssi2=Ssi+1,IPe=Ssi2-1,$P(RPdi,"_",3)=IPe
       D SSC(Ssi2,RPdi,frm)
       ;D ^dv("Log scan MCH Ssi2 dot+1","RPdi,Ssi,Ssj,Ssi2,gti")
       W:$X ! W " * end scan ",Ssi,".",Ssj,"  ",?40,RPdi,!
       Q
;*
COMPLETE(Sci,Scj,RPic,FIPs,Fna)  ;  S2i Fna~Found runa, FIPs~FOund IPs-> where to search
       ;RPic finished
       S S2i=FIPs I $G(Fna)="" D b^dv("Err Found runa null","Fna,runa,Sci,Scj,RPic")
       I Sci'=S2i D ^dv(" +++ C Gotcha ","Sci,S2i,RPic,IPs,Fna")
       S Sc2i=S2i
       F Sc2j=1:1:SC(Sc2i)  S RPc2=SC(Sc2i,Sc2j) DO  ;  vs While, SC(Sc2i) chgs?
         .D EXRP^epW(RPc2)
         .W:$X ! W " * + Comp st ",S2i,".",Sc2j," dot=",dot,"  ",?40,RPc2,!         
         .I TokR1'=Fna Q
         .S RPc3=RPc2
         .S dot=dot+1
         .S $P(RPc3,"_",4)=dot
         .S frm="Cmplt fr:"_Sci_"."_Scj
         .S $P(RPc3,"_",6)="COMP"  ; frm  ; "complete"  ; vs frm trc         
         .S Sc3i=S2i+1,IPe=Sc3i,$P(RPc3,"_",3)=IPe
         .D SSC(Sc3i,RPc3,frm)  S Sc3j=Svj  ; where new stored
         .D ^dv("Log one new C item ","Sci,Scj,Sc2i,Sc2j,Sc3i,Sc3j,RPic,RPc2,RPc3,dot,ruLst")
         .;W:$X ! W " * + Comp end-new ",Sci,"/",Scj," dot=",dot,"  ",?40,RPc3,!
       I Sc2j'=SC(Sc2i) D b^dv("num in SC(Sc2i) bumped in loop ?","Sc2j,SC(Sc2i)")
       Q
;*
;*  Save in SC
;Analog of Append and Unsafe-Append (sic,sic) functions
;  Dont duplicate, loop til empty, punt if dupl
;*  : SC(Svi,Svj),  Svj
SSC(Svi,RPit,frm)  ;no NEW Svj- returned for debugging
       I SC<Svi S SC=Svi ;D b^dv("Log New Svi ","Svi,SC,RPit")
       ;Find end AND ck for dupl to Punt
       F Svj=1:1 S RPg=$G(SC(Svi,Svj)) Q:RPg=""   DO  Q:Q  
         .S Q=$P(RPg,"_",1,5)=$P(RPit,"_",1,5)
       ;Punt if duplicate found:
       I Q W:$X ! W "SSC rej Dupl at Svi=",Svi,".",Svj,"  ",?40,RPit  Q
       ; Non-duplicate, save-
       ; Svj is new empty node, ie SC(Svi,Svj    
       S $P(RPit,"_",7)=Svi_"."_Svj  ; me or parent ? two _slots
       S $P(RPit,"_",8)=$E(Ins,IPs,IPe)  ; ?Misplaced here
       S SC(Svi,Svj)=RPit,SC(Svi)=Svj
       ;audit-
       S tIPe=$P(RPit,"_",3) 
         ;I tIPe'=(Svi-1) D b^dv("Err explicit IPe vs Svi-1","tIPe,Svi,RPit")
       S Sfrm(Svi,Svj)=frm  ; ? Separate vs inside RP*
       W:$X ! W "SSC New/nonDup SC(",Svi,",",Svj,") = '",?40,RPit,"' "
       Q
       ;
;*
;*
PZE(M,VL) USE $P W !!," *****  "
      S VL=$G(VL) I VL="" S VL="mrid"
      I $G(M)'="" D ^dv(M,VL)
      R !,"Pause (ret) . for Dir Mode",!,":",X
      I $G(VL)="" S VL="zrid,rdid,mrid,mwCMO"
      I X["." D b^dv("Pause ",VL)
      Q
 ;*
initSC KILL SC,Sfrm
       S RP=$G(GRi(1))
       S SC(1,1)=RP,Sfrm(1,1)="init" ; Initial conditions
       S SC=1,SC(1)=1
       Q

;*
;*  RuLst vs ruL ?
WRP(RP,Swi,Swj) NEW ruL,dot
       W:$X ! W $G(Swi,"S*i?"),",",$G(Swj,"S*j?"),"  "
       S ruL=$P(RP,"_",4) W RP,"  "
       S dot=$P(RP,"_",3),$P(ruL,",",dot+1)=" * ,"_$P(ruL,",",dot+1)
       W ruL
       Q
;*       
; GWUSCO
;i, Si, Sbi, Spi, Sci, Ssi, Swi,   Pass as args, dont bleed up
;j, Sj, Sbj, Spj, Scj, Ssk, Swj    Some NOT arg, just reuse, eg SSC
; i,Si~Ip ~IPc  pointer to INc()  inPointer 
;
; SC State Chart  sic 
; RP*  Rule object, RPgr rule from grammar Place holder dot, IPs, IPc
; RPi  Rule as item, dot-item, match in progress
;
