ppGRI  ;CKW/ESC i7feb24 umep./  rppar1/ ;2024-0304-77;Gen/TOIcustom from RG() GR* GRv,GRc,GRt  Grammar tables
;
; ReFactor maybe:  tkcod  vs tokt  in tokgrFL, et. al
;
;  Fields of Grammar table are per grabFL  AND granFL, stem gr*
;;grabFL:grde,grnun,grri_GRv(grab)
;;grab:s mnemonic ref to rules in rulelst's (mnemonic, not gran) key in GRv
;;grde:Doc descr of grab
;;grri:link back to source in RG(gi)  grammar file
;;grnun:i Number of gran alts  explicit here vs scattered logic testing gran's
;
;*   needed actually vs grabFL
;;granFL:grulst,gropsr,grtt_GRc(gran)
;;gran:s grab.grun eg Exp.1, "Exp.2"  subscript of GRc esp grulst- rule list
;;grulst;spdelim List of tokens, either terminal in TKv or grab  rule name (not gran)
;;
;;grtklst: sp-delim list of start chars (or term-toks (eg Vna.)  dbl colon TOI
;;   vs derived from traversal and term-1st
;;toktPUL:special list of tokt's which may start gran, $P(tokL," ") is punct list, rest $P(sp tokt's
;;gropsr: post proc sr, in ^ppPSR/^p2PSR - not in GRc, derived later,  see granI^p2PAR
;

;* 7mar24 ReFactor- remove gri/gki, use grab as subscr of GRv
;   GRv is not count anymore, rsq?
;* Stdize GRc for kfm, granFL
;*
;*  RG() with //GG marker for grammar source, //tokt  marker for terminal token ids, //m for mumps code
top    NEW Q I $$arg^pps("RG") G Qb
       D ^p2IMG
       D CRGru ; RG() : GRv(grab),GRc(gran)->grulst, GXsq(rsq)=grab
       ;devlog still open for caller continuation  CFW^devlog(devlog)
       D XTG  ;Compil GXtg Index  start term to select Gn: GXtg(grab,TKc,Gn)=""
       G Q
;*
Q      Q:$Q Q Q:Q=""
Qb     D b^dv("Err ^"_$T(+0),"Q,RG,devrg,gi,grab,gran") Q:$Q Q  Q
;* op no params
G0x     S gFil="mGR0a.mdk",gFol="rpgr1/"
        S tFil="PAR-tok1a.mdk",tFol="rpgr1/"
       D IRDGR(gFil,gFol,tFil,tFol) 
       D ^ppGRtok  ; RT() : GRt  terminal database       
       D ^ppGRI  ; RG() : GRv...
       Q
;*
G1     S gFil="mPAR-GR1a.mdk",gFol="rpgr1/"
       S tFil="mPAR-TERM1a.mdk",tFol="rpgr1/"
       D IRDGR(gFil,gFol,tFil,tFol) ; RG(), RT()
       D ^ppGRtok  ; RT() : GRt  terminal database
       D ^ppGRI  ; RG() : GRv(), GRc(), ...
       Q
;*
G3x     S gFil="mGR0a.mdk",gFol="rpgr1/"   ;
       S tFil="mPAR-TERM1a.mdk",tFol="rpgr1/"
       D IRDGR(gFil,gFol,tFil,tFol) 
       D ^ppGRI  ; RG() : GRv...
       Q
;*    Read Grammar File, multiple sections to RG()    and RT() 
IRDGR(gFil,gFol,tFil,tFol)  NEW Q,D I $$arg^pps("gFil,gFol,tFil,tFol") G Qb 
       S D=$IO
       KILL RG,GRv,GRc     S GRv=0,GRc=0,rsq=0
       D IB^mepIO ; PB umep./
       S devrg=PB_gFol_gFil
       S Q=$$^devRD(devrg,,"RG") I Q'="" G Qb
       I 'RG S Q="Empty GR grammar file " G Qb
       ;
       S devrt=PB_tFol_tFil
       S Q=$$^devRD(devrt,,"RT") I Q'="" G Qb
       I 'RT S Q="Empty tok grammar file " G Qb
       USE D G Q
;*  RG() :  GRna, GRc, GXsq
;;grabFL:grde,grnun,grri_GRv(grab)
;*   GRc(gran)=grulst, space delim tokens, term[".", Punct ?1P  or [grab] or grab  rule
;*   GRnt(gran)=tklst, space delim, :: piece 2 after grulst
;*
CRGru  NEW Q I $$arg^pps("RG") G Qb
       KILL GRv,GRc S grun=1,grab="?",grri="?"
       S gi0=0 F gi=1:1:RG S L=$G(RG(gi)) I $E(L,1,4)="//GR" S gi0=gi+1 Q
       I 'gi0 S Q="Err did not find //GR in RG("_gi G Qb
       I $G(devrg)'="" S GRv(0,"devrg")=devrg
       F gi=gi0:1:RG S L=$G(RG(gi)) Q:L["//"  DO  ;
         .I $E(L)="#" Q ;skip comment # first char of line only
         .S Esp=$E(L)=" "
         .S L=$$DSP^dvc(L)
         .I L="" Q
         .S P1=$P(L," "),P2=$P(L," ",2,99)     
         .I 'Esp DO  I Q'="" G Qb
            ..; No indentation, new grab
            ..S grab=$P(P1,":"),grun=0,grri=gi
            ..I grab="" D b^dv("Err grab grab","grab,gi,P1,P2,L") Q
            ..I grab'?.1"["1A.10AN.1"]" D b^dv("Err format of grab in grammar file","grab,gi,L") Q
            ..S D=$D(GRv(grab)) I D D b^dv("Dupl grab:","D,grab,grri") Q
            ..S grde=P2
            ..S rsq=rsq+1
            ..S grnun=grun
            ..D SFL^kfm("grde,grnun,grri,rsq,grun",grabFL) ; : GRv(grab
            ..S GXsq(rsq)=grab,GXsq=rsq
         .I Esp DO  Q
            ..;Indented line, next grun/gran
            ..S grun=grun+1,grnun=grun
            ..S gran=grab_"."_grun
            ..   ;  esp end spaces
            ..;I L[" #" S L0=L,L=$P(L," #"),L=$$DSP^dvc(L) ;D b^dv("gran end-of-line comment","L0,L")
            ..S grulst=$$DSP^dvc($P(L,"::"))      ;DSP after :: pieces  
            ..S grtklst=$$DSP^dvc($P(L,"::",2))
            ..I grtklst'="" ;D pze^p2s("Log grtklst ::2 ","grtklst,gran,grulst,L") ; pze^p2s
            ..S gr0=$TR(grab,"[]"),gropsr="" S glab=gr0_"^p2PSR",z=$T(@glab)
            ..  I z'="" S gropsr=glab
            ..S grsyn="" S glb2=gr0_"^p2PSYN",z=$T(@glb2)
            ..  I z'="" S grsyn=glb2
            ..S t1tt="" I gran["[" S t1tt=$P(grulst," ")
            ..D SFL^kfm("grulst,grtklst,gropsr,grsyn",granFL)  ; Note grulst and grtklst are filed under gran now
            ..D SFL^kfm("grnun,t1tt",grabFL)
       S grab=0 F  S grab=$O(GRv(grab)) Q:grab=""  DO  ;
         .S grn=$G(GRv(grab,"grnun")) 
         .D GFL^kfm("grnun",grabFL)
         .I grnun Q
         .D GFL^kfm("grri,grde",grabFL)
         .D b^dv("Err grab without any grans","grab,grnun,grri,grde")
       W:$X ! W "Completed Grammar composition CRGru^"_$T(+0)_"  GRv, GRc, GXsq ",!
       G Q
;*  Compile grtklst to GXtg(grab,tokt,Gn)=""
XTG    KILL GXtg S GXtg=0   
       W:$X ! W "Starting term to Gn Index  GXtg from grtklst  XTG^"_$T(+0),!
       S gran=0 F  S gran=$O(GRc(gran)) Q:gran=""  DO  ;
         .D GFL^kfm("grtklst",granFL)
         .I grtklst="" Q
         .S grab=$P(gran,".")
         .S Gn=$P(gran,".",2)
         .  I 'Gn D b^dv("Err Gn from gran ","gran,grab,Gn") Q
         .F tj=1:1:$L(grtklst," ") S TLc=$P(grtklst," ",tj) DO  ;
            ..I TLc="" D b^dv("Err in grtklst null TLc","grtklst,tj,TLc,gran,Gn") Q
            ..S Gnx=$G(GXtg(grab,TLc))
            ..  I Gnx'="" D b^dv("Err Dupl GXtg Index","grab,TLc,Gnx,Gn") Q
            ..S GXtg(grab,TLc)=Gn,GXtg=GXtg+1
      W:$X ! W "Completed Compile TK   GXtg  XTG^"_$T(+0)_"   x",GXtg," entries.",!
      Q
         

 
