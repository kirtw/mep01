dgmg  ;CKW/ESC i6may20 gmsa/ rmgbFL3/ ; 20220612-80 ; MGbl sr ^dgmg  SFL/GFL

;  No top entry
;
;
;Get Loc Vars via Super-FL-List ether in $P2_SFL (no G2), G2, or $P2_ of G2
;*$$Q  or D GFL^dgmg(...
GFL(SFL,G2)  NEW Q S Q="" 
  I $G(SFL)="" S Q="GFL null 1st arg" D bug^dv(Q,"SFL,G2") G QG
  NEW G,FL,vi,vn
  I $G(G2)'="" S:G2["_" G2=$P(G2,"_",2)
  S G=$P(SFL,"_",2),FL=$P(SFL,"_") 
    I G="" S G=G2 I G="" S Q="No MGbl Given" D bug^dv(Q,"Q") G QG
  I FL="" S Q="Degen SFL became null" D bug^dv(Q,"SFL,FL,G2") G QG
  F vi=1:1:$L(FL,",") S vn=$P(FL,",",vi) I vn'="" S @vn=$G(@G@(vn))
QG Q:$Q Q
  Q   ; safety/visual
;eg.  D GFL("lnfun",LineFL)  ; uses _2 of LineFL but list lnfun only
;*
;Save loc vars to MGbl via Super-FL-list
;*$$Q or D SFL^dgmg...
SFL(SFL,L2)  NEW Q S Q="" I $G(SFL)="" D bug^dv  S Q="1arg" G QS
  NEW:1 G,FL,%vi,%vn,%val,%old
  I $G(L2)="" S L2=$P(SFL,"_",2)		; sic L@ bad choice vs L, L0, L2
  E  S L2=$P(L2,"_",2)  ;uses arg2 for _2 MGbl Ref
  S G=L2,FL=$P(SFL,"_") I G="" D b^dv("Bug No _2 G","G,FL,SFL,L2")  G QS
  I FL="" D b^dv("Bug No _1 FL","G,FL,SFL,L2")  G QS
  F %vi=1:1:$L(FL,",") S %vn=$P(FL,",",%vi) DO  ;
    .I %vn="" Q  ; ignore and go on...
    .S %val=$G(@%vn) I %val'="" S @G@(%vn)=%val Q
    .I $D(@%vn)#2=0 ;D errFL("Undef Var "_%vn) Q  ; Var %vn is UNDEF Usu not, NFL^dvs ? Tx as null
    .S %old=$G(@G@(%vn)) I %old'="" KILL @G@(%vn)  ; Kill prior value ?
QS  Q:$Q Q  ; zb target
    Q  ; safety/visual
;*
;*$$Q Set local fields/@vars -  @SFL null - Initialize
NFL(SFL,L2) NEW Q S Q="" I $G(SFL)="" S Q="NFL 1st arg FL null" D bug^dv(Q,"SFL,L2") G QN
  NEW G,FL,%vi,%vn
  I $G(L2)'="" S G=$P(L2,"_",2),FL=$P(SFL,"_",1)
  E  S G=$P(SFL,"_",2),FL=$P(SFL,"_") ;I G="" S Q="Net G null" D bug^dv(,"FL,G,SFL,L2") G QN
  I FL="" S Q="Net FL null" D bug^dv(Q,"FL,G,SFL,L2") G QN
  F %vi=1:1:$L(FL,",") S %vn=$P(FL,",",%vi) I %vn'="" S @(%vn)=""
QN Q:$Q Q
   Q  ; safety/visual
;*
