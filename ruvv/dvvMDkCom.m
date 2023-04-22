dvvMDkCom(devm,devh)  ;CKW/ESC  i9Jul18 ; 20180709-01 ; MDkCompile Vers1 / Quickie code
  ;         in T2DM/  rdv/   
  ;
  ;
A    I $G(devm)="" D bug^dv Q
     I $G(devh)="" S devh=$P(devm,".MDk")_".md2.html"
     D RDF^dvs(devm) I 'RF D b^dv("Err opening devm *.MDk ","devm,devh") Q
     ;  RF()
     S TI="MDkCompile from "_devm
     S TItb="MDkCom"
     D HG1^dvh(devh)
     D guts
     D HG2^dvh(devh)
     Q
;*
;    Txmo  [ {pre,ptag }
;    
;
guts ;
     F ri=1:1:RF S L=$G(RF(ri)) D CL1
     U $P W:$X ! W "^",$T(+0)," Completed ",devh,!
     Q
;*
;*  L
CL1  S nsp=0,P1=""
     I $E(L)=" " DO
       .F nsp=1:1 I $E(L,nsp+1)'=" " S L=$E(L,nsp+1,9999) Q
     I $E(L)?1P S P1=$E(L) DO
       .F nP1=1:1 I $E(L,nP1+1)'=P1 S L=$E(L,nP1+1,9999) Q
     I P1="#" D Hn
     D WC
     Q
;*  chop and test L words (space delim)
WC   F wi=1:1:$L(L," ") S WD=$P(L," ",wi) D WW
     W !
     Q
;*
WW   S wd=$$LC^dvs(WD)
     S dwd=$G(^TD(wd)) I dwd="" W WD," " Q  ;Dictionary
     Q
;*
Hn   I (nP1'?1n)!('nP1) D bug^dv Q
     W "<h",nP1,">",L
     W "</",nP1,">"
     Q
;*
