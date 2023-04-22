devTes()  ;CKW/ESC  i26feb19 ; 20190226-96 ; Test ^devIO
  ;  in gmsa/  rudev/   
  ; pass/fail   RefBy:  ^fdMenu  tdu.  in $test
  ;  Needs devlog  for actual errors, test failures, issues, fixes
A  S Qn=0
  S Q=$$tdef D cQ("defaults test")
  S Q=$$targ D cQ("std args r stem")
  S Q=$$tmpj D cQ("test Mpj sr")
  S Q=$$tls D cQ("test ls Write/Read temp")
  USE $P W:$X ! W "devU Testing ^devTes - "
  I 'Qn Q ""
  Q Qn  
cQ(testid) I Q'="" D ^dv("Failed ","testid,Q") S Qn=Qn+1
     Q 
;*  ext ref no $$ return   RefBy:  ^fdMenu  tdu.  in $test
T   S Qt=$$devTes
    I Qt W "Failed: ",Qt,!
    E  W "Passed all.",!
    Q
;*
;*$$   Test defaults  Tr args are expected values  for stem:r See Tls for stem:ls
tdef()  S Qdef=""
   KILL (Qn,Qdef)   S Q=$$rRD^devIO("","")  ; rFil,rFol default
       S Q=$$Tr("","/home/kw/km6a/") I Q'="" S Qdef=Q_","
   KILL (Qn,Qdef)   S Q=$$^devIO("r","")  ; rFil,rFol default
       S Q=$$Tr("","/home/kw/km6a/")  I Q'="" S Qdef=Qdef_Q_","
   S Qr=$$devrRD^devIO(rFil,rFol)  ; : RD() test file in dbg/  4 lines
       I Qr'="" S Qdef=Qdef_"rRD:"_Qr_","
       I $D(RD)=11,RD=6,RD(1)["^devTes Tests this line." S Qr=""
       E  S Qdef=Qdef_Qr_","
   Q Qdef
;*$$
targ()  S Qarg=""
   KILL (Qn,Qarg) S Q=$$rRD^devIO("abc.txt","dbg/")  ; two args rFil,rFol
      S Q=$$Tr("",devr,rFil,rFol,rBase,"r") I Q'="" S Qarg=Qarg_Q_","
   S Qarg=$$ta1
   ; same diff entry
   KILL (Qn,Qarg) S Q=$$^devIO("r","R","abc.txt","dbg/")  ; two args rFil,rFol
      S Q=$$Tr("",devr,rFil,rFol,rBase,"r") I Q'="" S Qarg=Qarg_Q_","   
   Q Qarg
   ;  ls W then Read
ta1()   KILL (Qn,Qarg) S Q=$$lsW^devIO("","log/")  ; two args lsFil,lsFol
        I Q'="" S Qarg=Qarg_Q_"," Q Qarg
      USE devls W "Test Text into devls - ",devls,!!  ; Quickie Write to devls
      D CF^devIO(devls)
   KILL (Qn,Qarg) S Q=$$lsRLS^devIO("","log/")  ; two args lsFil,lsFol : RLS()
      I Q'="" S Qarg=Qarg_Q_"," Q Qarg
      I $D(RLS)=11,RLS,RLS(1)["Test Text" S Q=""
      E  S Q="ls Write/Read failed. ",Qarg=Qarg_Q  Q Qarg
      S Q=$$Tls(Q,devls,lsFil,"log/",lsBase) I Q'="" S Qarg=Qarg_Q_","   
   Q Qarg
;*$$  $zro : Mpj (sic) vs specify in B0^<Mpj>Idev
tmpj(); ; test sr in isolation
      ;D Mpj^devIO   ; both (same ?)
      Q ""
;*
;* Test values vs r* vec vars	why were ref by name call args ?
;  skip test if null input (not test for val="" )
Tr(Qt,dev,Fil,Fol,Base,xstem)
  S Qv=$G(Q) NEW Q  NEW Qd,Qf,Qp,Qb,Qs,Qq
  S Q=""   ; Tricky Qv= 'Q by caller', save before new Q, hides caller Q
  I $G(dev)'="" S Qd=(dev=$G(devr)) I 'Qd S Q=Q_"devErr,"
  I $G(Fil)'="" S Qf=(Fil=$G(rFil)) I 'Qf S Q=Q_"r-filErr," D b^dv("Tr Fil Err ","Fil,iFil,rFil")
  I $G(Fol)'="" S Qp=(Fol=$G(rFol)) I 'Qp S Q=Q_"r-folErr," D b^dv("Tr Fol Err ","Fol,iFol,rFol")
  I $G(Base)'="" S Qb=(Base=$G(rBase)) I 'Qb S Q=Q_"BaseErr,"
  I $G(xstem)'="" S Qs=(xstem=$G(stem)) I 'Qs S Q=Q_"stemErr,"
  I $G(Qt)'="" S Qq=(Qt=Qv) I 'Qq S Q=Q_" Diff Q Err." 
  I Q'="" S Q="Tr:"_Q
  Q Q
;*  * * *  stem:ls
;*$$
tls() S Qls=""
      KILL (Qn,Qls) S Q=$$^devIO("ls","W")  ; def lsFil,lsFol
        I Q'="" S Qls=Qls+q
        S Qt=$$Tls("",devls,,,lsBase,"ls")
          I Qt'="" S Qls=Qls+1
      Q Qls
;*      
Tls(Qt,dev,Fil,Fol,Base,xstem)
  S Qv=$G(Q) NEW Q  NEW Qd,Qf,Qp,Qb,Qs,Qq
  S Q=""   ; Tricky Qv= 'Q by caller', save before new Q, hides caller Q
  I $G(dev)'="" S Qd=(dev=$G(devls)) I 'Qd S Q=Q_"ls-devErr,"
  I $G(Fil)'="" S Qf=(Fil=$G(iFil)) I 'Qf S Q=Q_"ls-filErr,"  D b^dv("Tls Err ","Fil,iFil,lsFil")
  I $G(Fol)'="" S Qp=(Fol=$G(lsFol)) I 'Qp S Q=Q_"ls-folErr," D b^dv("Tr Err ","Fol,iFol,lsFol")
  I $G(Base)'="" S Qb=(Base=$G(lsBase)) I 'Qb S Q=Q_"ls-BaseErr,"
  I $G(stem)'="" S Qs=(xstem=$G(stem)) I 'Qs S Q=Q_"ls-stemErr,"
  I $G(Qt)'="" S Qq=(Qt=Qv) I 'Qq S Q=Q_" Diff Q Err." 
  Q Q
