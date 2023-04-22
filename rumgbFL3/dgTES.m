dgTES  ;CKW/ESC i6may20 gmsa/ rmgbFL3/ ; 20200506-81 ; tdm Tests for ^dgmg
;
;
;	tst.  guMenu 
Tdgmg KILL  S Qs=""
      S Q=$$T()
      USE $P W:$X ! W "Testing ^dgmg GFL, SFL, NFL - "
      I Q'="" W "Failed: ",Q,!
      I Q=""  W "Passed.",!
      Q
;*
I1    KILL a,b,c,A
      S tesFL="a,b,c_A(aid)"
      S a=1,c=3
      S aid=11
      Q
;*$$Q  Non-interactive test Pass/Fail
T(Qs) S Qs=$G(Qs) D I1
      D NFL^dgmg(tesFL)
      I $G(a)'="" S Qs=Qs+1_"NFLa?"
      I $G(c)'="" S Qs=Qs+1_"NFLc?"
      I $D(b)'=1,$G(b)'="" S Qs=QS+1_"NFLb?"
      ;
sfl   D I1
      D SFL^dgmg(tesFL)
      I $G(A(11,"a"))'=1 S Qs=Qs+1_"SFLa?"
      I $D(A(11,"b"))'=0 S Qs=Qs+1_"SFLb not del"
      ;
gfl   S a=99,b=98,c=97
      D GFL^dgmg(tesFL)
      I $G(a)'="1" S Qs=Qs+1_"GFLa?"
      I $G(b)'="" S Qs=Qs+1_"GFLb?"
      I $G(c)'=3 S Qs=Qs+1_"GFLc?"
      ;
      Q Qs
;*
      
