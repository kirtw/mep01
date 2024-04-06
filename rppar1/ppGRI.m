ppGRI  ;CKW/ESC i7feb24 umep./  rppar1/ ;2024-0304-77;Gen GR*  Grammar tables for mpp
;
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
;;   1st sp piece may have term after / from grammar file,  gran may be attached to _2
;;toktPUL:special list of tokt's which may start gran, $P(tokL," ") is punct list, rest $P(sp tokt's
;;gropsr: post proc sr, in ^ppPO, def =grab, mult gran same sr ?  vs grab_grun (not dot in label)
;

;* 7mar24 ReFactor- remove gri/gki, use grab as subscr of GRv
;   GRv is not count anymore, rsq?
;* Stdize GRc for kfm, granFL
;*
;*  RG() with //GG marker for grammar source, //tokt  marker for terminal token ids, //m for mumps code
top    NEW Q I $$arg^pps("RG") G Qb
       D CRGru ; RG() : GRv(grab),GRc(gran)->grulst, GXsq(rsq)=grab
       D CRGtokt ; GRt(tokt, GXtsq(tsq)=tokt
       ;devlog still open for caller continuation  CFW^devlog(devlog)
       G Q
;*
Q      Q:$Q Q Q:Q=""
Qb     D b^dv("Err ^"_$T(+0),"Q,RG,devrg,gi,grab,gran") Q:$Q Q  Q
;* op no params
G0     S gFil="mGR0a.mdk"   ; in rppar1/ !
       D IRDGR(gFil) 
       D ^ppGRI  ; RG() : GRv...
       Q
;*
G1     S gFil="mGR1a.mdk"
       D IRDGR(gFil) 
       D ^ppGRI
       Q
;*    Read Grammar File, multiple sections to RG()     
IRDGR(gFil)  NEW Q,D I $$arg^pps("gFil") G Qb 
       S D=$IO
       KILL RG,GRv,GRc     S GRv=0,GRc=0,rsq=0  D ^ppIMG
       S gFol="rppar1/"
       D IB^mepIO ; PB umep./
       S devrg=PB_gFol_gFil
       S Q=$$^devRD(devrg,,"RG") I Q'="" G Qb
       I 'RG S Q="Empty GR grammar file " G Qb
       ;
       USE D G Q
;*  RG() :  GRna, GRc, GXsq
;;grabFL:grde,grnun,grri_GRv(grab)
;*   GRc(gran)=grulst, space delim tokens, term[".", Punct ?1P  or grab  rule
;*
CRGru  NEW Q I $$arg^pps("RG") G Qb
       KILL GRv,GRc S grun=1,grab="?",grri="?"
       S gi0=0 F gi=1:1:RG S L=$G(RG(gi)) I $E(L,1,2)="//",L["GR" S gi0=gi Q
       I 'gi0 S Q="Err did not find //GR in RG("_gi G Qb
       F gi=gi0+1:1:RG S L=$G(RG(gi)) Q:L["//"  DO  ;
         .I $E(L)="#" Q ;skip comment # first char of line only
         .S Esp=$E(L)=" "
         .S L=$$DSP^dvc(L)
         .I L="" Q
         .S P1=$P(L," "),P2=$P(L," ",2,99)     
         .I 'Esp DO  I Q'="" G Qb
            ..; No indentation, new grab
            ..S grab=$P(P1,":"),grun=0,grri=gi
            ..I grab="" D b^dv("Err grab grab","grab,gi,P1,P2,L") G Qb
            ..I grab'?1A.10AN D b^dv("Err format of grab in grammar file","grab,gi,L") G Qb
            ..S D=$D(GRv(grab)) I D D b^dv("Dupl grab:","grab,grri") G Qb
            ..S gran=grab_"."_grun
            ..S grde=P2
            ..D SFL^kfm("grde,grri",grabFL) ; : GRv(grab
            ..S rsq=rsq+1
            ..S GXsq(rsq)=grab,GXsq=rsq
         .I Esp DO  Q
            ..;Indented line, next grun/gran
            ..S grun=grun+1,grnun=grun
            ..S gran=grab_"."_grun
            ..S grulst=L
            ..D SFL^kfm("grulst",granFL)
            ..D SFL^kfm("grnun",grabFL)
       W:$X ! W "Completed Grammar composition CRGru^"_$T(+0)_"  GRv, GRc, GXsq ",!
       G Q
;*  GRt  :  GRt(tokt)=tokt  Index of terminal token names, including certain Punct
;;tokgFL:ttde,ttri_GRt(tokt)
CRGtokt NEW Q S Q=""  I $$arg^pps("RG") G Qb
       NEW gi,gi0,PUL,tsq,P,tokt,L,L1
       KILL GRt,GXtsq,GXtt S GXtt=0,gti=0,GXtsq=0 
       S gi0=0 F gi=1:1:RG S L=$G(RG(gi)) I $E(L,1,2)="//",L["tokt" S gi0=gi Q
       I 'gi0 S Q="Err did not find //GR in RG("_gi G Qb
       ; Kludge, added to grammar syntax ?Punct list
       S PUL=$P(L," ",2,999) 
         I PUL'?5.50P D b^dv("Bug PUL line //tokt Punct List","PUL,L,gi0") G Qb
         F tsq=1:1:$L(PUL) S P=$E(PUL,tsq) I P'=" " S GRt(P)=P,GXtsq(tsq)=P  ;Literal Punct
         S GRt(0,"PUL")=PUL
       F gi=gi0+1:1:RG S L=$G(RG(gi)) Q:L["//"  Q:L["***"  DO  ;
         .S L1=$$DSP^dvc(L) ;L1 tokt
         .S tokt=$P(L1," ")
         .S ttde=$P(L1," ",2,9) I ttde="" S ttde=tokt
         .S ttri=gi
         .I tokt="" Q  ;Ignore blank line
         .I tokt'["." S tokt=tokt_"."
         .D SFL^kfm("ttde,ttri",tokgrFL) ; GRt(tokt, 
         .S tsq=tsq+1,GXtsq(tsq)=tokt,GXtsg=tsq
       W:$X ! W "Finished CRGtok^"_$T(+0)_"  Composing GRt(tokt,  Terminal token db.",!
       G Q
;*

