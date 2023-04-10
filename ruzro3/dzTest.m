dzTest   ;CKW/ESC  i27aug19 gmsa/ rd2zro/ ; 20190827-17 ; Test ^dz*  rd2zro
;    replaces all in rzro/  ^dz* but diff names, Breaking changes to callers
;    also rdv/  ^dvzl, ^dvstk  now in rd2vl/  with ^dv
;
;

;*    tdz.  in dzMenu, ^guMenu
TAll  NEW Qs,Q S Qs=""
      S Q=$$T(Qs)
      USE $P W:$X ! W "Testing ^gu*  gmgu All-  TAll^guTES"
      I Q'="" W "Failed: ",Q,!
      I Q=""  W "Passed.",!
      Q
;*
T(Qt) S Qt=$G(Qt)  NEW Q
      S Q="TestFail"
      ;S Q="" ;Test Pass
       I Q'="" S Qt=Qt+1_Q
      Q Qt
      