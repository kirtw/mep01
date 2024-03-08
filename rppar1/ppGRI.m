ppGRI  ;CKW/ESC i7feb24 umep./  rppar1/ ;2024-0304-77;Gen GR*  Grammar tables for mpp
;
;
;
;  Fields of Grammar table are per grulFL  AND granFL, stem gr*
;;grulFL:grde,grnun,grri_GRv(grab)
;;grab:s mnemonic ref to rules in rulelst's (mnemonic, not gran) key in GRv
;;grde:Doc descr of grab
;;grri:link back to source in RG(gi)  grammar file
;;grnun:i Number of gran alts  explicit here vs scattered logic testing gran's
;
;;granFL:grulst,gopsr,tokL,grtt_GRc(gran)
;;grun:i 1:1 dot sfx in gran  implicit from $P(gran.2)  not needed actually vs gran
;;gran:s grab.grun eg Exp.1, "Exp.2"  subscript of GRc esp grulst- rule list
;;grulst;spdelim List of tokens, either terminal in TKv or grab  rule name (not gran)
;;toktL:special list of tokt's which may start gran, $P(tokL," ") is punct list, rest $P(sp tokt's
;;gopsr: post proc sr, in ^ppPO, def =grab, mult gran same sr ?  vs grab_grun (not dot in label)
;

;* 7mar24 ReFactor- remove gri/gki, use grab as subscr of GRv
;   GRv is not count anymore, rsq?
;* Stdize GRc for kfm, granFL
;*
top    D IRDGR 
       D CRGru ; RG() : GRv(grab),GRc(gran)->grulst
       D CRGtok
       Q
;*    Read Grammar File, multiple sections to RG()     
IRDGR  NEW Q S Q="" 
       KILL RG,GRv,GRc     S GRv=0,GRc=0,rsq=0  D ^ppIMG
       S gFil="mGR1a.mdk",gFol="rppar1/"
       D IB^mepIO ; PB umep./
       S devrg=PB_gFol_gFil
       S Q=$$^devRD(devrg,,"RG") I Q'="" G Qb
       I 'RG S Q="Empty GR grammar file " G Qb
       ;
       G Q
;*  RG() :  GRna, GRc, GXsq
;;grulFL:grde,grnun,grri_GRv(grab)
;*   GRc(gran)=grulst, space delim tokens, term[".", Punct ?1P  or grab  rule
;*
CRGru    NEW Q I $$arg^pps("RG") G Qb
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
            ..S gran=grab_"."_grun
            ..S grde=P2
            ..D SFL^kfm("grde,grri",grulFL) ; : GRv(grab
            ..S rsq=rsq+1
            ..S GXsq(rsq)=grab,GXsq=rsq
         .I Esp DO  Q
            ..;Indented line, next grun/gran
            ..S grun=grun+1,grnun=grun
            ..S gran=grab_"."_grun
            ..S grulst=L
            ..S grtt="" I grulst["/" DO  ;
                ...NEW p1
                ...S p1=$P(grulst," "),grtt=$P(p1,"/",2)
                ...S p1=$P(p1,"/")
                ...S $P(grulst," ")=p1
            ..D SFL^kfm("grulst,grtt",granFL)
            ..D SFL^kfm("grnun",grulFL)
       W:$X ! W "Completed Grammar composition CRGru^"_$T(+0)_"  GRv, GRc, GXsq ",!
       G Q
;*  GRt  :  GRt(tok)=tok  Index of terminal token names, including certain Punct
CRGtok NEW Q S Q=""  I $$arg^pps("RG") G Qb
       KILL GXtt S GXtt=0,gti=0  NEW gi,gi0,PUL,pi,P,tok,L,L1
       S gi0=0 F gi=1:1:RG S L=$G(RG(gi)) I $E(L,1,2)="//",L["tokt" S gi0=gi Q
       I 'gi0 S Q="Err did not find //GR in RG("_gi G Qb
       ; Kludge, added to grammar syntax ?Punct list
       S PUL=$P(L," ",2,999) 
         I PUL'?5.50P D b^dv("Bug PUL line //tokt Punct List","PUL,L,gi0") G Qb
         F pi=1:1:$L(PUL) S P=$E(PUL,pi) I P'=" " S GRt(P)=P  ;Literal Punct
       F gi=gi0+1:1:RG S L=$G(RG(gi)) Q:L["//"  DO  ;
         .S L1=$$DSP^dvc(L) ;L1tokt
         .S tok=$P(L1," ")
         .I tok="" Q  ;Ignore blank line
         .I tok'["." S tok=tok_"."
         .S GRt(tok)=tok
       W:$X ! W "Finished GRGtok^"_$T(+0)_"  Composing GRt  token db.",!
       G Q
;*
Q      Q:$Q Q Q:Q=""
Qb     D b^dv("Err ^"_$T(+0),"Q,RG,devrg,gi,grab,gran") Q:$Q Q  Q
;*
Aud    NEW Q S Q=""  I $D(GRv)<9 S Q="GRv is UNDEF" G Qb
       KILL GXxg  ; GXxg(grab,gran)=
       S (ng,nan)=0
       F rsq=1:1:GXsq S grab=$G(GXsq(rsq)) DO  ;
         .I grab="" D b^dv("Err grab GXsq(rsq","rsq,grab")  G Qb
         .S ng=ng+1
         .D GFL^kfm(grulFL) ; GRv(grab,         
         .I grab'?1A.10AN S Q="Err grab format 1A.10AN " G Qb
         .F nni=1:1:grnun S gran=grab_"."_nni DO  ;
            ..D GFL^kfm("grulst",granFL)  ; GRc(gran,
            ..S nan=nan+1
            ..F tki=1:1:$L(grulst," ") S tok=$P(grulst," ",tki) I tok'="" DO  ;
                ...I tki=1,tok["/" S grtt=$P(tok,"/",2),tok=$P(tok,"/")
                ...I tok?1P S tp=$G(GRt(tok)) DO  Q
                     ....I tp="" D ^dv("Undef P tok","tp,tok,tki,grulst,grab,gran") Q
                     ....Q
                ...I tok["." S tp=$G(GRt(tok)) DO  Q
                     ....I tp="" D:0 b^dv("Undef tok","tp,tok,tki,grulst,grab,gran") Q
                ...I $D(GRv(tok))=0 D pze^dv("Undef rule ","tok,tp,tki,grulst,grab,gran") Q
                ...;tok~grab is in grulst of gran
                ...S GXxg(tok,gran)=tki
        W !!,"tot  num grabs ng:",$G(ng),"   num gran's  nan:",$G(nan),!!
      G Q
;*  GXsq(rsq)=grab
;;grulFL:grde,grnun,grri_GRv(grab)
;;granFL:grulst,gopsr,grtt_GRc(gran)
WGR    W !!,"Grammar -",!
       F rsq=1:1:GXsq S grab=$G(GXsq(rsq)) DO  ;
         .D GFL^kfm(grulFL) ; GRv(grab,  
         .W:$X ! W "  ",grab," ",?10,grde,"    ln:",grri,!
         .F grun=1:1:grnun S gran=grab_"."_grun DO  ;
            ..D GFL^kfm(granFL)  ; GRc(gran 
            ..W:$X ! W ?4,gran,"- ",?15,grtt,"  ",?30,grulst,"   post:",gopsr,!
       Q
;*
