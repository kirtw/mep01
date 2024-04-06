ppPAgran(gran)  ;CKW/ESC umep./ rppar1/ ;2024-0401-45;Parse gran
;
;* $$Q, gran (valid not >grnun) : QN, gnts,gnte if QN null/pass gran/grun is a successful alternative in grab
TRVgran NEW Q I $$arg^pps("grun,grab") G Qb
        NEW Rn,grulst,Rn,QT,grstr,grts,grte S Rn=1  ;not gnts,gnte
        D GFL^kfm("grulst,gropsr",granFL) ; gran, GRc(gran : grulst, gropsr  
        D PSH^ppPAsr(StkP) ;
        S QN="??",grstr="<"
        S gnts=tki,nlst=$L(grulst," "),gnte=""
        D bln^dv3("InitGRAN")
        ;I $G(grts)'=$G(gnts) D b^dv("Mismatch *ts","grts,gnts,gran,grab,StkP")        
        ;S PTx(StkP,gnts,"gran")=gran
        I $G(gnts)="" D b^dv("Err gnts null","gnts,gnte,gran")
        D SFL^kfm("gran,gnts_PTx(StkP,gnts)")
        F Rn=1:1:nlst DO  I QN'="" D granFAIL G QN  ; Any tok Fail causes QN Fail
          .S gnn=gran_"."_Rn_"/"_StkP
          .D toty ; grulst, Rn : tok, toty, gnn
          .I toty="T"  DO  Q  ;
             ..S Q=$$^ppPAtokt(tok)  ;  : QT, gnte'
             ..S QN=QT
             ..I QT="",$G(gnte)="" D b^dv("Err ret gnte by termMCH","gran,gnts,gnte")
          .I toty="R"  DO  Q ;
             ..S Q=$$^ppPAgrab(tok,StkP+1)  ; :QB, grts,grte
             ..S QN=QB
             ..S gnte=$G(grte)  ; also gnts?
          .D bug^dv
        ; falls thru if passed all Rn/tok in grulst 
        D granPASS
QN      G Q
;*
;* gran, Rn, grulst : toty, tok, gnn 
toty   I $$arg^pps("Rn,grulst,gran") G Qb
    S tok=$P(grulst," ",Rn) I tok="" D bug^dv G Qb
    I (tok?1P)!(tok[".") S toty="T",QTest=(TKc=tok)
    E  S toty="R"
      I tok="" S toty="X" D bug^dv S QG="tok Err null" G Qb
    Q
;* gran, gnts, gnte :
granPASS S QN=""
        I gran="Karg.1",gnte'=3 D b^dv("Err gnte","grte,gran,gnn")
        S nospan=gnte-gnts+1 S:nospan=1 nospan=""
        S gnC=$G(gnts)_":"_$G(gnte)_"/"_$G(nospan)   
        I $G(gnts)="" D b^dv("Err null gnts granPASS","gran,gnts,gnte,grab,grts,grte")
        D SFL^kfm("gnts,gnte,gnC","_PTx(StkP,gnts)")
        D bln^dv3("granPASS")
        ;D pze^dv("Log granPASS","QT,grulst,gnts,gnte")        
        Q
granFAIL D bln^dv3("granFAIL")
         D pze^dv("Log granFAIL","QN,QT,gran")
        Q
;*
Q      Q:$Q Q Q:Q=""
Qb     D b^dv("Err ^"_$T(+0),"Q,StkP,STK") Q:$Q Q  Q
;*
