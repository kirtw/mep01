dve  ;CKW/ESC i6aug22 ?/ ?/ ;20220806-35; Quickie Error expansion
;
;
;
top    S ZS0=$ZS D exp(ZS0)
       D ^dvstk ; write and %ZS(lev)
       I ERnam["QUITARG" D QARG
       I ERnam["UNDEF" D UNDEF
       D ASKSAV
       Q
;*   expand/parse $ZS error   
exp(ZS) I $G(ZS)="" W !,"No $ZS value?",! Q
      S ERlb=$P(ZS,",",2)
      S ERtxt=$T(@ERlb)
      S ERnum=$P(ZS,",",1)
      S ERnam=$P(ZS,",",3)
      S ERde=$P(ZS,",",4)
      S ERvalQ=$G(Q)
      Q
;*
WER   D b^dv("$ZE Error Dump","ERnam,ERlb,ERtxt,ERde,ERnum,ERvalQ")
      Q
;*
;    150373850,Ph5rd+13^mwMod5,%YDB-E-LVUNDEF, Undefined local variable: rdFL
UNDEF  D WER
       Q
;*  Specific Errors expansion
QARG  I ERnam["QUITARGREQD" DO  Q
        .W !,"Missing Q arg in ERtxt: ",!,?6,ERtxt,!
        .W "Called by ",ERlb,!
      DO  ;
        .D b^dv("Other QUITARG ","ERnam,ERlb,ERtxt,ERde,ERnum,ERvalQ")
      Q
;*
ASKSAV  R !,"Save this for later ?",X
      I X["y"!(X["Y") W "  sorry, not yet.",!
      Q
