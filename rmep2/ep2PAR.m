ep2PAR  ;CKW/ESC i31oct22 ;20230112-75;Parse INc(),INty  into GRk Grammar...
;
;  GRi(ruid)
;  Gxi(<rule-name>,gi)=isq  ;  ~ left-hand-side name index, mult rules, gi

;  INc(Ip)=literal input chars, from Ins, a string of chars
;
;  SCF items or rules (aka dotted-rule, item, )
;   ruLst:   _5 is ruLst a comma list of tokens- rule-names or terminal-set-names)
;   dot:  a ptr into the current ruLst comma pieces
;   Ips   is the input start pointer, Ips, into Ins (~input)
;   IPe   is the end-ptr into Ins, implicitly==Si in Lua
;   ruby
;   frm  What function created  {PRED, SCAN, COMP, Init }
;   ruC   Input chars consumed between IPs & IPe
;    
top    W !!,"Magic:  Parsing !"
       ;; {I1,BLp1,BLp2,COM,tokR1,SSC,RejDup,SCs,SCse}
       S Wmo="SSC,RejDup,SCs,SCse"  ; "I1,BLp1,BLp2,tokR1,SSC,SCs,SCse" 
         S Sei=2,Sej=2 ; Bloop pre/post Stop
       ;     
       D main
       D Wmdk^ep2W  ; Full Table to mep-...mdk in dmep/
       I $G(devlog)'="" USE $P D WSC^ep2W  ; also to $P
       Q
       ;
main   ; loop thru INputs, Ip BUILD analog
       D initSC ; KILL Arrays, SSq=0, First two items
        ;
       F Sbi=1:1 Q:$D(SCF(Sbi))=0  DO  ;
         .I Wmo["BLp1" W !!,"BUILD Outer Loop1 [",Sbi,"] ",!
         .F Sbj=1:1 Q:$D(SCF(Sbi,Sbj))=0   D BI1  D EL2 ;
       I Wmo["BLp1" W:$X ! W "End BUILD Outer Loop1 [",Sbi,"] ",!
       Q
;*
FLg5  ;;grFL:runa,ruab,ruty,ruLst,nLst,tokCL,nLCL,Lna,rde_GRk(ruid)
FLi5  ;;itemFL:runa,ruab,ruid,ikey,SSq,IPs,IPe,dot,ruLst,tokR1,tokTy,ruby,frm_SCF(Si,Sj)
;* Si,Sj
BI1    S Si=Sbi,Sj=Sbj
       D GFL^kfm(itemFL) ; Si,Sj : ru*...
       S SSb=svSSq
         I Wmo["I1" D Witem^ep2W("BI1")
       ;D getR1^ep2W ; dot, ruLst : tokR1, tokTy
        ; rule loop, item-loop, 
        ;
       D ^dv("Log BI1+8 P-S-C choice","Sbi,Sbj,tokR1,tokTy,ruLst,dot,ruab,IPs,IPe")
       I Sbi=Sei,Sbj=Sej DO  ;
         .W !!,"Bloop2:  SeiSej-",! 
         .D PZE("Sei/Sej BLoop","Sei,Sej,tokTy,tokR1,dot,ruLst")
       I tokR1=""!(tokTy="C") S trc="C:" D COMPLETE(Sbi,Sbj,IPs,runa)  Q  ; 
       I tokTy="T" S trc="S:" D SCAN(Sbi,Sbj,tokR1)  Q  ; token with + is terminal
       ; tokTy="R"
       I tokTy'="R" D b^dv("Err tokTy","tokTy,tokR1,ruab,dot,ruLst")
       S trc="P:" D PRED(Sbi,Sbj,tokR1) Q ;inside loop chart items/rules2.9
       D b^dv("Err illegal rule.?","tokR1,Sbi,Sbj")
       Q
;*   end each inside loop
EL2    W:$X ! W "End inner Bloop ",Sbi,",",Sbj,"   trace:",$G(trc),"  "
       ;I $G(SCF(Sbi+1))="" S SCF(Sbi+1)=0 ; just do $D test now, do not store count
       I Sbi=Sei,Sbj=Sej DO  ;
         .S M="Log Bloop2 End Sel:Sei/j "_Sbi_"."_Sbj_"  "
         .D PZE(M,"tokTy,tokR1,ruLst,tokCL,IPs,IPe,dot")
       Q
;*         
;*  Sbi, Sbj        
PRED(Spi,Spj,tokP)  ;NEW Spj
       W:$X ! W "#",SSq," PRED find '",$G(tokP),"' in Gxi-> gi -> ruid",!
       I $G(tokP)="" D b^dv("Err tokR1 should not be null here","tokP,tokR1,Sbi,Sbj,Spi") Q
       I Spi'=Sbi D b^dv("Maybe Err ?","Sbi,Spi,Spj")
       I $D(Gxi(tokP))=0 D bug^dv("Err tokR1 not in Gxi(tokR1/P","tokP") Q
       ;For every grammar rule with name=tokP- runa,gi -> ruid
       F gi=1:1 Q:$D(Gxi(tokP,gi))=0   D NwP
       ;D PZE
       Q
;*  try new dot,IPs,ruid from
NwP    ; tokP, gi > ruid /GR record
       S ruid=$G(Gxi(tokP,gi))
         I ruid="" D b^dv("Err ruid from Gxi(tokR1)","ruid,tokR1,gi") Q
       D GFL^kfm("ruab,runa,ruLst,IPs",grFL)  ; ruid : ruLst, ruab  ? IPs
       S dot=1
       S ruby="PRED"         
       S frm="Pred fr:"_Spi_"."_Spj
       S IPs=Sbi  ; IPs item.start
       I IPe'=Spi-1 D ^dv("Err Inconsistenct IPe,Spi","IPe,Sci,Si,Sj")
       ;S IPe=Spi-1  ; IPe is implicit always == Si-1?
       D SSC(Spi,frm) ; save in this Sbi~Spi State (same), if not dupl, Sbi at end
       Q
;*
FLg4  ;;grFL:runa,ruab,ruty,ruLst,nLst,tokCL,nLCL,Lna,rde_GRk(ruid)
FLi4  ;;itemFL:runa,ruab,ruid,ikey,SSq,IPs,IPe,dot,ruLst,tokR1,tokTy,ruby,frm_SCF(Si,Sj)

;*
;* Sbi,Sbj  @itemGL  : mod SSC
SCAN(Ssi,Ssj,tokR1) ;I Ssi=1 D ^dv("No Input Si=1","Ssi,Ssj,tokR1") Q
       S IPc=Ssi
       S mch=$$TMch(tokR1,IPc)
       I 'mch Q  ;No match or past end, no mch
       ;Here matched terminal, C in tokCL, ITcl(tokR1)
       S dot=dot+1
       S frm="SCAN term char '"_C_"'  fr:"_Ssi_"."_Ssj
       S Ssi2=Ssi+1
       S IPe=Ssi ; ?
       I Wmo["SCs" DO  ;
         .S log="SCAN mch "_Sbi_"."_Sbj_" -> "_Ssi2_".*"
         .D ^dv(log,"IPc,C,tokCL,IPs,IPe,dot")
       D SSC(Ssi2,frm)  ; Svj
         I EQ D ^dv("SSC Rej Dupl Scan Mch","EQ,mch,Ssi2,Svj")
       I Sbi=Sei,Sbj=Sej DO  ;
         .W:$X ! W " * end scan ",Ssi,".",Ssj," -- ",Ssi2,".",Svj," ?EQ~RejDup ",EQ,!
         .D PZE("End Scan Sei/Sej","EQ,Ssi2,Svj")
       Q
;* Terminal Match
TMch(tok,IPc)  NEW ruid,ruab,tokCL
       I IPc>$L(Ins) Q 0  ; No mch, past end
       S C=INc(IPc) I C="" D b^dv("Err C ","C,IPc,Ssi,Ssj") Q
       ;
       S ruid=$G(Gxi(tok,1))  ;only one gi for terminal tokens
         I ruid="" D b^dv("Err Scan finding ruid from tokR1","tokRa,tokTy,ruid") Q 0
       S ruab=$G(GRk(ruid,"ruab"))  ;GFL^kfm("ruab",itemFL)
       S tokCL=$G(GRk(ruid,"tokCL"))  ;terminal token char list
         I tokCL="" D b^dv("Err Char tokCL","tokCL,tokR1,tok,C") Q 0
       ;
       D ^dv("Log test Scan Mch ","C,Ssi,tokR1")
       S mch=tokCL[C
       I 'mch D ^dv("Log non-match "_C_"' not in "_tokR1,"C,CL,tokR1,Ssi,Ssj")
       I mch D ^dv("Scan Matches ","tok,C,tokCL,ruid")
       Q mch
;*
FLg3  ;;grFL:runa,ruab,ruty,ruLst,nLst,tokCL,nLCL,Lna,rde_GRk(ruid)
FLi3  ;;itemFL:runa,ruab,ruid,ikey,SSq,IPs,IPe,dot,ruLst,tokR1,tokTy,ruby,frm_SCF(Si,Sj)
;*
COMPLETE(Sci,Scj,FIPs,Fna)  ;  S2i Fna~Found runa, FIPs~FOund IPs-> where to search
       ;item  finished, item Sbi~Sci . Sbj~Scj  
       I $G(Fna)="" D b^dv("Err Found runa/Fna null","Fna,runa,Sci,Scj")
       ;I Sci'=S2i D b^dv(" +++ COMP? Gotcha Sci'=S2i/(FIPs+1) ","Sci,S2i,IPs,Fna")
       I (Sci_Scj)=(Sei_Sej) DO  ;
         .W !!,"COMP SeiSej-",! 
         .D PZE("Sei/Sej COMP","Sei,Sej,FIPs,Fna")
       W:$X ! W "COMP pre process "_Sbi,".",Sbj,"  ",Fna," [",IPs,"-",IPe,"] -> ",ruLst,"  ",!
       S Sc2i=FIPs  ;1.6 init, =1 (Sci-1, 
       W:$X ! W "C Srch IPs set",Sc2i," for Fna in tokR1-"       
       I Wmo["COM" D b^dv("Log COMP to ck all of Sc2i for runa~Fna in tokR1","Sc2i,FIPs,Fna,trc")
       F Sc2j=1:1 Q:$D(SCF(Sc2i,Sc2j))=0  DO  ;  vs While, SCF(Sc2i) chgs?
         .S Si=Sc2i,Sj=Sc2j
         .D GFL^kfm("tokR1,tokTy",itemFL) ; Si,Sj : @itemFL
         .I Fna'=tokR1 DO  Q  
            ..W:$X ! W "COMP sch Rej Fna=tokR1 "_Sc2i_"."_Sc2j_"  tokR1:"_tokR1,!
         .;  Found C mch
         .D GFL^kfm("ruid,ruab,runa,ruLst,dot,IPs,IPe",itemFL) ; Si,Sj : @itemFL   / old_item    IPs from item     
         .I Wmo["COM" W:$X ! W " * + Comp st ",Sc2i,".",Sc2j," .",dot,"  ",?40,ruLst,!    
         .S dot=dot+1
         .;D getR1^ep2W ; dot, ruLst : tokR1,tokTy
         .S ruby="COMP"      
         .S Sc3i=Sci,IPe=Sc3i         
         .S frm="Cmplt fr:"_Sci_"."_Scj_"(C) sub "_tokR1_" into "_Sc2i_"."_Sc2j_",  new:"_Sc3i_".*"
         .D SSC(Sc3i,frm)  S Sc3j=Svj  ; where new stored
         .I EQ D b^dv("COMP rej Dupl ","EQ,log,ruid,dot,IPs,Svj")
         .I 'EQ DO  ;
           ..S log="COMP done: fr Sb C: "_Sci_"."_Scj_" bump "_Sc2i_"."_Sc2j_" into- "
           ..S Citem="  "_Sc3i_"."_Sc3j_" #"_SSq_"  "_ruab_"/"_ruid_" -> ."_dot_" ["_IPs_"-"_IPe_"] "
           ..I Sbi=Sei,Sbj=Sej W:$X ! W log,!,Citem,!
           ..;D ^dv("Log one new C item ","Sci,Scj,Sc2i,Sc2j,Sc3i,Sc3j,dot,ruLst")
         .W:$X ! W " * + COMP end-new ",Sci,"/",Scj," .",dot,"  ",?40,ruLst,!
       Q
;*
;*  Save in SCF
;Analog of Append and Unsafe-Append (sic,sic) functions
;  Dont duplicate, loop til empty, punt if dupl
;* @itemFL modified : SCF(Svi,Svj),  Svj, 'EQ => new at Svj/ EQ rej dupl
FLg2  ;;grFL:runa,ruab,ruty,ruLst,nLst,tokCL,nLCL,Lna,rde_GRk(ruid)
FLi2  ;;itemFL:runa,ruab,ruid,ikey,SSq,IPs,IPe,dot,ruLst,tokR1,tokTy,ruby,frm_SCF(Si,Sj)
SSC(Svi,frm)  ;no NEW Svj- returned for debugging
       ;Find end AND ck for dupl to Punt on EQ~dupl
       S EQ=0 F Svj=1:1 Q:$D(SCF(Svi,Svj))=0   DO  Q:EQ  
         .S EQ=1 F vn="ruid","dot","IPs","" Q:vn=""  I @vn'=$G(SCF(Svi,Svj,vn)) S EQ=0 Q
         .;D ^dv("Log EQ","EQ,vn,Svi,Svj,ruid,dot,IPs,frm,trc,ruby")
       ;Punt if duplicate found:
       I EQ  DO  Q  ; punt when dupl exists already
          .S log="X X X Rej Dupl "_Svi_"."_Svj_"  #"_ruid_", ."_dot_" s:"_IPs_"  frm:"_frm
          .I Wmo["RejDup" D ^dv(log,"Sbi,Sbj")
          .W:$X ! W log,!
       ; Non-duplicate, save-
       S SSq=SSq+1,svSSq=SSq ;Serial items       
       S Si=Svi,Sj=Svj
       D getR1^ep2W ; dot, rulst : tokR1, tokTy
       D MEX ; ruid,IPs,dot,IPe : ikey
       ; Svj is new empty node, ie SCF(Svi,Svj    
       D SFL^kfm("ruid,ikey,dot,IPs,IPe,runa,ruab,ruLst,frm,tokR1,tokTy,svSSq",itemFL) ; Si=Svi, Sj=Svj new at end
       D TEX
       S log=" + + SSC: q"_SSq_"  "_Si_"."_Sj_"["_IPs_"-"_IPe_"]  ."_dot_" #"_ruid_" "_frm
       W:$X ! W log,!
       ;audit-
         ;I IPe'=(Svi-1) D b^dv("Err explicit IPe vs Svi-1","tIPe,Svi,Svj")
       I Wmo["SSC" DO  ;
         .W:$X ! W "SSC New/nonDup SCF(",Svi,".",Svj,") = "
         .W ?40,ruab,"  '",ruLst,"' ",!
       Q:$Q "New:"_Svi_"."_Svj_"  "_ruab Q
;*  Index back to sources
REX    S Rex(SSq,dot,SSb)=LST
       Q
;*  ruid,IPs,IPe,dot -> ikey
;*  ikey MEP(SSq)=ikey, MExk(ikey)=SSq   ruid,IPs,dot : ikey
MEX    S ikey=ruid_"-"_dot_"-"_IPs_"-"_IPe
       S x=$G(MEP(SSq)) I x'="" D b^dv("Err Repeat SSq?","SSq,ikey")
       S MEP(SSq)=ikey
       S x=$G(MExk(ikey)) I x'="" D b^dv("Err Dupl ikey","ikey,SSq,IPe")
       S MExk(ikey,SSq)=IPe
       Q
;*  SS, wIC
TEX    NEW vi,vn,XL
       S X="",XL="ruid,dot,IPs,IPe" F vi=1:1:$L(XL,",") S vn=$P(XL,",",vi) S $P(X,"_",vi)=@vn
       S SS=Si_"."_Sj
       S DSQ(SSq)=SS
       ; part two
       S wIC="{"_$E(Ins,IPs,IPe)_"}"
       S DSQ(SSq)=Svi_"."_Svj_"  "_$G(wIC)  ;actual sequence
       Q
;*
PZE(M,VL) USE $P W !!," *****  "
      S VL=$G(VL) I VL="" S VL="mrid"
      I $G(M)'="" D ^dv(M,VL)
      R !,"Pause (ret) . for Dir Mode",!,":",X
      I $G(VL)="" S VL="Sbi,Sbj,ruid,ruab,tokR1,tokTy"
      I X["." D b^dv("Pause ",VL)
      Q
;*
FLg1  ;;grFL:runa,ruab,ruty,ruLst,nLst,tokCL,nLCL,Lna,rde_GRk(ruid)
FLi1  ;;itemFL:runa,ruab,ruid,ikey,SSq,IPs,IPe,dot,ruLst,tokR1,tokTy,ruby,frm_SCF(Si,Sj)
;*
initSC KILL SCF,MEP,MExk
       S SSq=0
       D ^ep2IMG  ; grFL, itemFL
       D TT^ep2IMG  

       D NFL^kfm(itemFL)
       S Si=1,Sj=1,ruid=1 D GFL^kfm(grFL) ; ruid, Sum.1, ruLst
       S frm="Init"  ; Initial conditions
       S dot=1,IPs=1,IPe=0
       D getR1^ep2W ; dot, ruLst : tokTy, tokR1,tokCL
       ;D SFL^kfm(itemFL)  ; Si,Sj   Alt to SSC, no need to ck dupl
       D SSC(Si,"Init "_ruab)
       ;D ^dv("Log Init 1.1","ruLst")
       S ruid=2 D GFL^kfm(grFL)
       S dot=1,IPs=1,IPe=0
       D getR1^ep2W ; dot, ruLst : tokTy, tokR1,tokCL       
       ;S Sj=2 D SFL^kfm(itemFL)
       D SSC(Si,"Init "_ruab)
       ;D ^dv("Log Init 1.2","ruLst")       
       Q
;*       
; GWUSCO
;i, Si, Sbi, Spi, Sci, Ssi, Swi,   Pass as args, dont bleed up
;j, Sj, Sbj, Spj, Scj, Ssk, Swj    Some NOT arg, just reuse, eg SSC  Svi,Svj
; i,Si~Ip ~IPc  pointer to INc()  inPointer 
;
; SC State Chart  sic 
; SCF(Si,Sj)  @itemFL 
;
