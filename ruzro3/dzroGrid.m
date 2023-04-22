dzroGrid ;CKW/ESC i25may22 gmsa/ rd2zro/ ;20220525-42; HGen mpj-zro vs rdir list GridGrid
;
; Urge 25may22 use case ^GP6  vs ^dgmg  rdir/vers confusion
;
top      ;
     D ^devIB  ; PB, MB
     S devHGzro=MB_"ww2m/a-zro-rdir-Grid.2.html"
     S rdL="rMGbl3,rd2Mgb,rd2mg,rMgbl,rG"
     
     D Init^hgh
       S TItb="rdir-Grid"
     D HGS^hgh
     D guts
     D HGE^hgh
     D WH^hgh(devHGzro)
     Q
;*
guts   ;
     D ot("table")
     D ot(".rowth")
     F di=1:1:$L(rdL,",") S rdir=$P(rdL,",",di) DO
       .D ot(th),sv(rdir),ct
      D ct(".rowth")
     ;
     D ot(".rowmpj")
     F mi=1:1:$L(mpL,",") S mpj=$P(mpL,",",mi)  D mpjLine
     D ct(".rowmpj")
     D ct("table")
     Q
;*
mpjLine   ;
     D ot(".mline")
     D ot(".mlhd"),sv(mpj),ct
     F di=1:1:$L(rdL,",") S rdir=$P(rdL,",",di) DO
       .S grpt=$G(^ZWP(mpj,"xrdir",rdir))
       .I grpt="" S grpt="."
       .D ot("td"),sv(grpt),ct
     D ct(".mline")
     Q
     
     
     
;*  local aliases ot,ct to ^hgh
ot(v1) D ot^hgh($G(v1)) Q
ct(v1) D ct^hgh($G(v1)) Q
sv(v1) D sv^hgh($G(v1)) Q

;*
