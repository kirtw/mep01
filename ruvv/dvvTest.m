dvvTest  ;CKW/ESC  i10Aug17 ; 20170810-86 ; Test ^dvv and WLL
  ;
;
T      ; Set Up %VA, %VL temp for testing
     KILL %VA,%VL
     S Lvn="iaVL",Lva="CCL,FmL,FTL,ORL,ORLp,ORLn,xFN,xCF,xTYn,xFB,xBC,xBN"
     S %VL(Lvn,"Lva")=Lva
     S %VL(Lvn,"Lde")="Std Conversion Strings by ^rbIA"
     S VLLx="iaVLx",iaVLx="CCL,xFB,xFN"
     D VLL^dvv("VLLx")
     W !,"***",!
     S vn="CCL",%VA(vn,"vde")="Color List, Caps, in order   WYORBG"
     S CCL="WYORBG"
     D VLL^dvv("VLLx")
     W !,"***",!
     D ^rbIA   S VLLx="iaVL,ia2VL"
     D VLL^dvv("VLLx")
     Q
;*  val, L, vn, vde
TWLL  S vn="XXX",vde="Test var XX in TWLL^dvvTest"
     S val="short" D S
     S val="This is  a fairly long lllllllllllllllllllllllllllllll Word1  word2,word3" D S
     S val="This is  a fairly long lllllllllllllllllllllllllllllll much longer longer longer longer longer Word1  word2,word3" D S     
     Q
;*
S   S L=$L(val) D WLL^dvv 
    Q