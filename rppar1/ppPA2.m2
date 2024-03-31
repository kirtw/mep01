ppPA2.m2  OBS vs ^ppPAtok

;;granFL:grulst,gropsr,grtt_GRc(gran)
;*
;* Rn, grulst : $$/QG, toty, tok 
Gtok() NEW Q,QG,DD S QG="??" I $$arg^pps("Rn,grulst") G QG
    S tok=$P(grulst," ",Rn)
    I tok="" DO  G QG
      .I Rn S toty="",Rn=0,QN="" Q ;tok null because finished list grulst
      .D b^dv("Err why Rn already zero/null","Rn,gran,grab,grun")
      .S toty="E?",QN=""
    I tok?1P!(tok[".") S toty="T" DO  G QG
      .S DD=$D(GRt(tok)) I DD'=0 Q
      .S Q="Err undef terminal " D b^dv(Q,"Q,tok,toty,Rn,grulst,gran")
      .S toty="ErrT"
    S toty="R" DO  G QG
      .S D=$D(GRv(tok)) I D Q  ;grab exists
      .S Q="Undef rule grab/tok:"_tok D b^dv(Q,"Q,tok,D,Rn,gran,grulst")
      .S toty="ErrR"
    ;Doesnt get here...
    S QG="Err how here ?" D b^dv(Q,"QG,tok,gran,Rn,grulst")
QG  Q:$Q QG
    D bug^dv("Err $$GTok","QG,Rn, grulst")
    Q
;*
       
;* toty, tok, grstr : QT, grstr'
TestTOK() NEW QT S QT="??" I $$arg^pps("tok,toty") G QT
      NEW QN,QB
      I toty="R"  DO  G QT
        .S QB=$$TRVgrab(tok,STK+1) ; Recursive
        .S QT=QB I QT'="" Q
        .S grstr=grstr_$G(gstr)
      I toty'="T" S Q="Err toty in Ttok" D bug^dv(Q,"Q,toty,tok,Rn,grulst") G Qb
      S QTest=(TKc=tok)
      I 'QTest S QT="X" D TermNO G QT
      ;QTest matches !
      S QT="" 
      D TermMch
      D Iin          ;Now bump tki
        I TKc="" S QI="" D b^dv("Log TKv Done.","QI,TKc,grab,Rn,grulst,tok") ; prob not here 
QT    Q:$Q QT  
      D bug^dv("Err TestTOK $Q/$$ mode","QT,tok")
      Q
;*
;* Terminal matched Input tok=TKc~tkcod/Input tki : TKc null means finished TKv input
;  Bumps both Input, tki, and rule ptr, Rn, after finding a terminal match
TermMch   S grce=tki,grstr=grstr_tks
      D SFL^kfm("gran,grstr","_PTx(tkcs,STK)")
      ;W:$X ! W "TermMch ",tok," in ",gran," #",Rn,"  vs tki:",tki,"  <",tks,"> ->",grstr,!
      D bln^dv3("termPASS")
      Q
;* Terminal does not match, rule fails (or tried to use Undef term)
;*  Fails QN gran if any terminal doesnt match next TKc~tkcod
TermNO S QT="X",QN="X:"_tok
      W:$X ! W "TTX x ",gran," Failed at ",tok,"   [",grulst,"] #",Rn,!
      D bln^dv3("termFAIL")
      D pze^pps("Log End TermNO","QT,tok,tki,TKc")
      Q
      ;*
