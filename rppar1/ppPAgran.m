ppPAgran(gran)  ;CKW/ESC umep./ rppar1/ ;2024-0327-97;Parse gran
;
;* $$Q, gran (valid not >grnun) : QN, if QN null/pass gran/grun is a successful alternative in grab
TRVgran NEW Q I $$arg^pps("grun,grab") G Qb
        NEW Rn,grulst,Rn,QT,grstr S Rn=1
        D GFL^kfm("grulst,gropsr",granFL) ; : grulst, gropsr        
        D PSH^ppPAsr(StkP)
        S QN="??",grstr="<",nlst=$L(grulst," ")
        D bln^dv3("InitGRAN")
        F Rn=1:1:nlst DO  I QN'="" D granFAIL G QN  ; Any tok Fail causes QN Fail
          .D toty ; grulst, Rn : tok, toty, gnn
          .I toty="T" S Q=$$^ppPAtokt(tok) S QN=QT Q
          .I toty="R" S Q=$$^ppPAgrab(tok,StkP+1) S QN=QB Q
          .D bug^dv
        ; falls thru if passed all in grulst 
        D granPASS
        S StkP=StkP-1 ; POP
QN      G Q
;*
;* gran, Rn, grulst : toty, tok, gnn 
toty   I $$arg^pps("Rn,grulst,gran") G Qb
    S tok=$P(grulst," ",Rn) I tok="" D bug^dv G Qb
    I (tok?1P)!(tok[".") S toty="T",QTest=(TKc=tok)
    E  S toty="R"
      I tok="" S toty="X" D bug^dv S QG="tok Err null" G Qb
    S gnn=gran_"."_Rn
    Q
;*
granPASS S QN=""
        D bln^dv3("granPASS")
        ;D pze^dv("Log granPASS","QT,Rn,grulst,tok,toty")        
        Q
granFAIL D bln^dv3("granFAIL")
         D pze^dv("Log granFAIL","QN,QT,gran")
        Q
;*
Q      Q:$Q Q Q:Q=""
Qb     D b^dv("Err ^"_$T(+0),"Q,StkP,STK") Q:$Q Q  Q
;*
