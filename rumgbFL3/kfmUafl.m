kfmUafl(PB) ;CKW/ESC i8apr23 gmsa./ rmgbFL3/ ;20230408-77;Audit ;; *F:: comments
; Replaces functionality of T^dws
;
;  Input is *FL values as locals, ie d ^**IMG as usual, then ^kfmUafl
;      vs VVL list or array of *FL
;      
;  Uses PB, scans all PB/r*/*.m  MRou   vs $ZRO   vs arg GB, ...
;    PB from $zro ?
top   I $G(PB)="" D bug^dv Q
      S z=$ZPARSE(PB) I z="" D b^dv("Err PB ^"_$T(+0),"PB") Q
      S z=$ZSEARCH("^X") ; reset
      S nsch=PB_"r*/*.m"
      F mi=0:1 S ru=$ZSEARCH(nsch) Q:ru=""  DO  ;
        .S Q=$$^devRM(ru) I Q'="" Q  ; : RM(), mrou
        .I 'RM Q ;No lines, empty mrou ?
        .F ri=1:1:RM S L=$G(RM(ri)) I $E(L,1,2)[";;" DO  ;
           ..I L'["FL:" Q
           ..S fn=$P(L,":"),fn=$P(fn,";;",2),vln=$P(L,":",2,99)
           ..S vfv=$G(@fn) I vfv="" Q
           ..I vln'=vfv DO ;
               ...W:$X ! W "^",mrou," ",ri,"- *FL ~ ",fn,!
               ...W "is:",vln,!
               ...W "vs:",vfv,!!
               ...S Z="vim "_ru
               ...BREAK
      USE $P W:$X ! W "^"_$T(+0)_"  Completed *FL Scan.  of ",nsch,!!
      Q
;*
