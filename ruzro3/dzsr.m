dzsr ;CKW/ESC i9feb23 gmsa./ rzro3/ ;20230210-01;sr for ^DZ*
;
;
;
top   BREAK  BREAK  HALT   ; No top
;
;*  ; : SB, PB, GB,    kwsys,kwmpj, mpjDir,LUser
IB(ampj)  ;
      S mpjDir="umbr" I $G(ampj)'="" S mpjDir=ampj
      S kwsys="km3a"
      S LUser="kw"
      S SB="/home/"_LUser_"/"_kwsys_"/"
      S PB=SB_mpjDir_"/"
      S GB=SB_"/gmsa/"
      Q
;*
