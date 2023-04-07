GAH(Gna) ;CKW/ESC i29jun22 gmsa/ rmGP3/ ;20220630-47; HGen Gna MGbl Page vn Analysis
;
;
;
top    NEW Q I $$arg^GAs("Gna") Goto Qbug
       ;
    S nmr=0,ncb=0
    S Q=$$devHmgb^GAIpg(Gna) ; : devHmgb  destination html page
    D Init^hgh  ; Init Buffers
    S TItb=Gna
    S TIhd="Mgbl field/vn Analysis - "_Gna
    S TIft="by ^"_$T(+0)_"  "_$ZD($H,"YY MM DD 12:60AM")
    D Hcss
    D HGS^hgh
    D guts
    D HGE^hgh
    D WH^hgh(devHmgb)
Q      Q:$Q Q I Q'="" D qd
       Q
Qbug   D qd Q:$Q Q  Q
qd     D b^dv("Err ^"_$T(+0),"Q,Gna,gFLna,gFL,FL,Gna,Gid")
       Q
;*
Hcss    D css^hgh(".line","font-size: 1.2em; background-color: lightblue;")
        D css^hgh(".line","write-space: pre-wrap;")
        D flexrow^hgh(".line",".h1td:1 .h2td:1 .h3td:4")
        D css^hgh(".lnFL","font-size: 1.4em; background-color: lightyellow;")
        ;
        Q
       Q
       ;
guts  ; VNgv(
       D mgHrow ; Line of Mgbl Links
       S nid=$G(^ZWG(Gna,"nid")) I nid="" S nid="zero"
       D br^hgh,sp^hgh(4),sv^hgh("Records in "_Gna_" - "),sv^hgh($G(nid)),br^hgh,br^hgh
       ;D b^dv("Log ","VNgv")
       S gNa="" F gi=0:1 S gNa=$O(VGN(Gna,gNa)) Q:gNa=""  S gFLna=gNa DO  ;
         .D hgFL(gFLna)
       D Stray
       Q
       ;
Stray  D br^hgh,sp^hgh(4),sv^hgh("Stray fields in "_Gna_"  -not in any *FL -"),br^hgh
       S D=$D(VNcv("Stray")) 
         I D DO  ;
         .S vn="" F vi=0:1 S vn=$O(VNcv("Stray",vn)) Q:vn=""  DO  ;
            ..D h1vn(vn)
         I 'D D sp^hgh(9),sv^hgh("No strays."),br^hgh
       ;
       Q
;*  

;*  HGen  each *FL string and its list of vn's 
;  gFLna, Gna 
hgFL(gFLna) NEW Q I $$arg^GAs("gFLna,Gna") Goto Qbug
       S gFL=$G(@gFLna) I gFL="" S Q="UNDEF @gFLna string" Goto Qbug
       S FL=$P(gFL,"_")  ; Caller either FL or gFL
       I FL="" D b^dv("Err FL","FL,Gna") Q
       D ot^hgh(".lnFL"),sv^hgh(" @"_gFLna),sp^hgh(3),sv^hgh(FL)
       D ct^hgh
       F fi=1:1:$L(FL,",") S fn=$P(FL,",",fi) I fn'="" D h1vn(fn)  ;
       Goto Q
;*
mgHrow  NEW G,gi,Gna,devHmgb
       D ot^hgh(".mgll")
       D tocLINK,sp^hgh(3)
       D HereLINK("Index ./"),sp^hgh(3)
       S G="" F gi=0:1 S G=$O(VGN(G)) Q:G=""  DO  ;
         .S Gna=G S Q=$$devHmgb^GAIpg(Gna) ; devHmgb
         .;D b^dv("Log Mgb LINK","G,Gna,devHmgb")
         .D LINK^hgh(Gna,devHmgb),sp^hgh(4)
       D ct^hgh(".mgll")
       Q
;*
h1vn(vn)   ;
       S vde=$G(^ZWV(vn,"vde")) S:vde="" vde="_" ; visible
       S VC=$G(VCgv(Gna,vn)) S:VC="" VC="0"
       S VA=$G(VAgv(Gna,vn)) S:VA="" VA="A?"
       D ot^hgh(".line"),ot^hgh(".h1td")
       D sv^hgh(" vn: "),sv^hgh(vn),sp^hgh(3),ct^hgh
       D ot^hgh(".h2td"),sv^hgh(VC),ct^hgh
       D ot^hgh(".h3td"),sv^hgh(vde),ct^hgh
       D ct^hgh(".line")
       Q
;*
;*
wdLINK(wd) I $G(wd)="" Q
       S href=$G(^ZWlk(wd)) I href="" Q
       D LINK^hgh(wd,href)
       Q
;*
HereLINK(txt) I $G(txt)="" S txt="ww2m/* "
       D LINK^hgh(txt,"./")
       Q
;*
tocLINK(M) I $G(M)="" S M="TOC Message ?"
       S Q=$$devFil^mwIpg("aa-TOC-All") ; : devFil
       S txt="MRou TOC List ",href=devFil
       D LINK^hgh(txt,href)
       Q
