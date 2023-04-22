dvc  ;CKW/ESC  i23jan20 gmsa/ rd2c/ ; 20200123-78 ; Char based sr
;
    BREAK  HALT  ;No fall -through
  ;
;*  Replace all dbl spaces (or more) with single, and remove starting/ending
DSP(X)	NEW i I $G(X)="" Q X
    S X=$TR(X,$C(9)_$C(10)_$C(13),"   ")  ;replace tab,lf,cr with space
    F i=0:1 Q:X'["  "  S X=$P(X,"  ")_" "_$P(X,"  ",2,9999)
	Q $$TSP(X)
;*  Remove start and end spaces (only)
TSP(X)	NEW i S X=$TR(X,$C(9)_$C(10)_$C(13),"   ")  ;replace tab,lf,cr with space
	I $E($G(X))=" " F i=1:1:$L(X) I $E(X,i)'=" " S X=$E(X,i,999) Q
	I $E(X,$L(X))=" " F i=$L(X):-1:1 I $E(X,i)'=" " S X=$E(X,1,i) Q
	I X=" " S X=""  ; Funny case all spaces  vs end i=0 second line ?
	Q X
;*$$ Actually DSP already does both calls TSP in 2nd line	
LTDSPtb(X) NEW i
        S X=$TR(X,$C(9)_$C(10)_$C(13),"   ")  ;replace tab,lf,cr with space
        F i=0:1 Q:X'["  "  S X=$P(X,"  ")_" "_$P(X,"  ",2,9999)
	; Remove start and end spaces (only)
	I $E($G(X))=" " F i=1:1:$L(X) I $E(X,i)'=" " S X=$E(X,i,999) Q
	I $E(X,$L(X))=" " F i=$L(X):-1:1 I $E(X,i)'=" " S X=$E(X,1,i) Q
	I X=" " S X=""  ; Funny case all spaces  vs end i=0 second line ?
	Q X	
  ;*  Case & Canonic
LC(X) Q $TR(X,"ABCDEFGHIJKLMNOPQRSTUVWXYZ","abcdefghijklmnopqrstuvwxyz")
UC(X) Q $TR(X,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
UC1(X) Q $$UC($E(X))_$$LC($E(X,2,9999))   ; Cap 1st, rest LC
  ;
can(X) Q $$LC(X)
  ;*
;*  20aug20  stdize   RefBy:  mdk  
EOL     S ECR=$C(13),ELF=$C(10),EFF=$C(14),tab=$C(9),EVT=$C(11)
	S EOL=ELF,EOF=EFF
	Q
;*
;*    ******
;*  Tests
