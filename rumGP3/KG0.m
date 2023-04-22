KG0(Gna,gFil)  ;CKW/ESC ix25jul22 gmma/ rmGP3/  ; mGlobal lister, Non-interactive
;Gna syntax is zwr syntax, variable MGbl names and subscripts, * stems and a:b ranges
;  zrid/^ZWZ(zrid,  W2B 
;  %ZD was output -> devG   --Input devG not just Fil, Caller manage base ---
        NEW %in,%ZL,%ZD
        NEW Q I $$arg^mws("Gna,W2B") Goto Qbug
        ;I '$d(%zdebug) n $et s $et="zg "_$zl_":ERR^%G" u $p:(ctrap=$c(3):exc="zg "_$zl_":LOOP^%G")
        S gFil=$G(gFil) I gFil'="" DO  ;
          .I gFil'["-" S gFil="ag-MGbl-"_gFil
          .I gFil'["mg2.txt" S gFil=gFil_".mg2.txt"
        I $G(W2B)="" DO  ;
          .I $G(zrid) S W2B=$G(^ZWZ(zrid,"W2B"))
          .I $G(W2B)="" D IB^mwIpg
          .I $G(W2B)="" D ^devIB S W2B=PB_"ww2mbr/"
          .D ^dvstk,b^dv("Forced default W2B ??","W2B,zrid,PB,SB")
        ;
        D SdevG ; Gna : devG
        D base
        D CFM^devIO(devG)
Q     Q:$Q Q  Q:Q=""  D qd Q
Qbug  D qd Q:$Q Q Q
qd    D b^dv("Err %Gmod devG ","Q,devG")
      Q  
;*  Gna : devG, opened
SdevG   NEW Q S Q=""  KILL %ZD  ;safety
        I gFil="" S gFil="ag-MGbl-"_$TR(Gna,"^","")_".mg2.txt"
        S devG=W2B_gFil
        S Q=$$OFW^devIO(devG) I Q'="" Goto Qbug
        Goto Q
;*        
base    D G1
        Q
;*  Gna  MGbl or Array Name, ?node
G1      
        s:Gna="*" Gna="?.E(*)"
        s:$p(Gna,"(")="*" $p(Gna,"(")="?.E"
        s:$e(Gna)'="^" Gna="^"_Gna
        n $et s $et="ZG "_$ZL_":badzwr"
        USE devG I $D(@Gna)=0 W !,Gna," is UNDEF.",!! Q
          W !,Gna," - ",!
          zwr @Gna W !!
          USE $P
        Q
badzwr  u $p w !,$p($zs,",",3,99),!
        s $ec=""
        d EXIT
        q
help    w !,"VALID Gna values",!!
        w !,"[global name]",?16,"the MUMPS name for the global e.g. ABC, or"
        w !?16,"a MUMPS pattern to match selected globals e.g. ?1""A"".E, or"
        w !?16,"""*"" as a wildcard for all globals"
        w !?16,"the global name may be followed by: "
        w !?16,"subscript(s) in parentheses"
        w !?16,"a subscript is a MUMPS expression e.g. ""joe"",10,$e(a,1),"
        w !?16,"a ""*"" as a subscript causes all descendents to be included,"
        w !?16,"or by a range of subscripts in parentheses"
        w !?16,"expressed as [expr]:[expr] e.g 1:10 ""a"":""d""",!
        Q
ERR     u $p w !,$p($zs,",",2,99),!
        s $ecode=""
        ; Warning - Fall-through
EXIT    i $d(%ZD),%ZD'=$p c %ZD
        u $p:(ctrap="":exc="")
        q
LOOP    if 1'=$zeof d base
        q
