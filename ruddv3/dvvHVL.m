dvvHVL(VVVL,mpj)  ;CKW/ESC   i1jul18  ; 20180701-50 ; HGen *VL var list page
  ;	dev in gmsa/rvv/  was (T2DM/ rdv/)     		sic: own $$sp, $$link
  ;
  ;     RefBy:  DVV^qdDIS, DVV^cqMa   both Menu: $doc  dvv.
  ;      Uses %VN(vn,  produced by ^ddvvr (not called here)
  ;     Depends on: ^hgh
  I $G(VVVL)="" D bug^dv Q
  I VVVL'["VL",VVVL'["FL" D b^dv("VVVL is not the name of a *FL/*VL var","VVVL")  ;Blunder on?
  I $G(mpj)="" S mpj="mpjUNK"
  S L=$G(@VVVL) I L="" D b^dv("Err *FL/*VL Var is Null","VVVL") Q
  S GBA=$P(L,"_",2),VL=$P(L,"_")
  S subn="" I GBA["(" S subn=$P(GBA,"(",2),subn=$P(subn,")")
  S TItb=VVVL,TIhd="Super Var List"
  S TIft="by ^"_$T(+0)_"  "_$ZD($H,"DDMONYY 24:60")
  S hFil=$$VVVL^dvIpg(VVVL,mpj)
  S devh=$$devh^dvIdev(hFil)  ; devh
  D HG1^dvh(devh)
  D guts
  D HG2^dvh(devh)
  Q
;*
guts  W !,"<pre>",! DO   W:$X ! W "</pre>",! Q
        .W !,"<body>",! D DVV   W:$X ! W "</body>",! Q
      Q
;* VVVL
DVV   D DV1
      D DMGB
      D VL1
      Q
;* Intro 
DV1   W:$X ! W "<div class=dv1 >",!
      W "*FL Var:",VVVL," - "
      W $G(@VVVL)   ; Needs wrap on comma delim ---
      W !,"</div>"
      Q
;*    
DMGB  W:$X ! W "<div class=dmgb >"
      W "_P2 MGbl: ",GBA
      W !,"</div>"
      Q
;*  List Vars
VL1   W:$X ! W "<div class=vl1 >"
      F vi=1:1:$L(VL,",") S vn=$P(VL,",",vi) I vn'="" DO  ;
        .S val=$G(@vn)
        .S vde=$G(%VN(vn,"vde"))
        .W "<br/>vn:",vn," - ",vde,"  "
        .I $L(val)>20 W "<br/> ",$$sp(3)
        .I val'="" W val,$$sp(3)
      Q
;*
;*  HGen TOC page
TOC(LVV,mpj)  I $G(LVV)=""!($G(mpj)="") D bug^dv Q
     S hFil="VVL-TOC.html" S devh=$$devh^dvIdev(hFil)
     S TIhd="Super Var List Doc Pages  - TOC",TIhd="xVL-TOC"
     D HG1^dvh(devh)
     F vli=1:1:$L(LVV,",") S vln=$P(LVV,",",vli) I vln'="" DO  ;
       .S Fil=$$VVVL^dvIpg(vln,mpj)
       .D wlnk(vln,Fil) W "<br/>",!
     D HG2^dvh(devh)
     Q
;*
sp(n) NEW i,sp I '$G(n) S n=4  ;undef or zero
      I n>10 S n=10  ; max
      S sp="&nbsp;&nbsp;&nbsp;" F i=n-3:1:n S sp=sp_"&nbsp;"
     Q sp
;* Write LINK <a   literal href No path adj here
wlnk(txt,href,cls) I $G(txt)="" S txt="Link?"
     I $G(href)="" D bug^dv Q
     I $G(cls)="" S cls=""
     W "<a href='",href,"' "
     I cls'="" W "class='",cls,"' "
     W ">",txt,"</a>"
     Q
     