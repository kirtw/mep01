devTdevu()  ;CKW/ESC  i28feb19  ; 20190228-49 ; Full Seq of devU Ma Tests
  ;*$$
  ;
  ;   Test Automation Sequence  devU Tests
TA()    S Qta=0
      DO  I Q'="" S Qta=Qta+1
        .NEW Qta S Q=$$^devTes
      DO  I Q'="" S Qta=Qta+1
        .NEW Qta S Q=$$^devTerr
      DO  I Q'="" S Qta=Qta+1
         .NEW Qta S Q=$$TA^fdslink
      Q Qta
;*  Menu Entry point	^fdMenu tdevu.  $test
TES  S Q=$$TA
     USE $P W:$X ! W "Testing All of devU  ^dev* in gmsa/ rudev/- "
     I Q="" W " Passed!",!
     E  W " Failed ",Q,!
     Q