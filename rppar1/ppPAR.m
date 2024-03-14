ppPAR ;CKW/ESC i7feb24 umep./ rppar1/ ;2024-0313-43;mumps table mumps parser
;
;
;  TKv(ti)  tokens @tokFL, 
;  GRv(grab), GRc(gran)  Grammar  start top with Scom for now (or mCmds)
;*  Parse Table - also set of Arrays, PTx(pti,tki)
;
;
;  Single stack - Push rule and ptr current next rule from list
; Pop when finish a rule
; Look at next token when terminal comes up in rule, ie ["."
;;tokFL:tkcod,tks,tkcs,tkce_TKv(tki)
top     KILL STK S STK=1  D ^ppIMG
        KILL PTx S PTx=0  S pti=1
        S (QS,QT,QN,QB,QI,QA)="???"  ; just in case  Null pass, not null fails
        D stb^dv3("L1","grab:10,gran:10,Rn:4,grulst:25,tok:8,toty:2,gropsr:10")
        ;;pt1FL:Lev_PTx(pti)
        ;;pt2FL:gran,grts,grte,grstr_PTx(pti,tki)
        S tki=0 D Iin ; tki : TKv(tki, tkcod,tks, tkcs,tkce
        S TKc=tkcod
        S grab="mCmds",Rn=1,grun=1  ;Starting top rule 'mCmds', ptr Rn
        S QQ=$$Tgrab(grab,STK)
        ;Done
        Q
        ;
        ; Process TKv(tki, vs grab  Recursive
        ; : QB null pass, else fails
Tgrab(grab,STK) NEW Q I $$arg^pps("grab") G Qb      ; grab,grun,Rn 
        NEW grde,grri,grnun,grun,gran,grulst,gropsr,Rn,tok,toty,gn
        S grun=1,Rn=1
        D Gab ; grab : grde, grnun
        S QB="X" F gn=1:1:grnun S grun=gn D Tgran I QN="" S QB=QN Q  ;Passed any one of gn/grun gran alts
        ;If finishes alt list, grun) without passing, fails grab QB still "X"
        S gstr=grstr ; pass up
        D pze^dv("Log End of Tgrab","QB,grab")
        G Q ; QB
;* grab : grde, grnun, grri
;;grabFL:grde,grnun,grri_GRv(grab)
Gab     D GFL^kfm(grabFL) ; GRv(grab
        Q
;* grun (valid not >grnun), grab : QN, if QN null/pass gran/grun is successful alt
Tgran() NEW Q I $$arg^pps("grun,grab") G Qb
        NEW Rn,gran,grulst,Rn,QT,grstr
        D Sgran ; grun, grab : gran
        S QN="",grstr="<"
        F Rn=1:1:$L(grulst," ") DO  I QT'="" S QN=QT Q  ; Any tok Fail causes QN Fail
          .D Gtok ; Rn, grulst : toty, tok
          .S QT="???" D Ttok ; : QT
          .I QT="???" D b^dv("Err Ttok vs QT out","QT,Rn,tok,toty,grstr")
        G Q
;*  tok, toty : QT, grstr'
Ttok() NEW Q I $$arg^pps("tok,toty") G Qb
      NEW QN,QB
      I toty="R" D Tgrab(tok,STK+1) S QT=QB DO:QB=""  G Q
        .S grstr=grstr_$G(gstr)
      I toty'="T" S Q="Err toty in Ttok" D bug^dv(Q,"Q,toty,tok,Rn,grulst") G Qb
      S QTest=(TKc=tok)
      I 'QTest S QT="X" D TermNO G Q
      ;QTest matches !
      S QT="" 
      D TermMch
      ;Now bump tki
      D Iin 
        I TKc="" S QI="" D b^dv("Log TKv Done.","QI,TKc,grab,Rn,grulst,tok") ; prob not here 
      G Q
;* Terminal matched Input tok=TKc~tkcod/Input tki : TKc null means finished TKv input
;  Bumps both Input, tki, and rule ptr, Rn, after finding a terminal match
TermMch   S grce=tkce,grstr=grstr_tks
      W:$X ! W "TermMch ",tok," in ",gran," #",Rn,"  vs tki:",tki,"  <",tks,"> ->",grstr,!
      D SFL^kfm("gran,grstr","_PTx(tkcs,STK)")
      Q      
;*  grun, grab, grnun : gran, grulst, (grun, )      
Sgran()  NEW Q I $$arg^pps("grun,grab,grnun") G Qb
      S gran=grab_"."_grun  ;grun pre-controlled for <=grnun here (No test, no Q*, No branch)
      D GFL^kfm(granFL) ; : grulst, gropsr
      G Q
;;granFL:grulst,gropsr,grtt_GRc(gran)
;*
;* Rn, grulst : toty, tok, ?QN  
Gtok() NEW Q I $$arg^pps("Rn,grulst") G Qb
    S tok=$P(grulst," ",Rn)
    I tok="" DO  G Q
      .I Rn S toty="",Rn=0,QN="" Q ;tok null because finished list grulst
      .D b^dv("Err why Rn already zero/null","Rn,gran,grab,grun")
      .S toty="E?",QN=""
    I tok?1P!(tok[".") S toty="T" DO  G Q
      .S t=$G(GRt(tok)) I t'="" Q
      .S Q="Err undef terminal " D b^dv(Q,"Q,tok,toty,Rn,grulst,gran")
      .S toty="ErrT"
    S toty="R" DO  G Q
      .S D=$D(GRv(tok)) I D Q  ;grab exists
      .S Q="Undef rule grab/tok:"_tok D b^dv(Q,"Q,tok,D,Rn,gran,grulst")
      .S toty="ErrR"
    ;Doesnt get here...
    S Q="Err how here ?" D b^dv(Q,"Q,tok,gran,Rn,grulst")
    G Qb      

;;pt1FL:Lev_PTx(pti)
;;pt2FL:gran,grts,grte,grstr_PTx(pti,tki)        
xSVgrab  D SFL^kfm(pt2FL) ; PTx(pti,tki)
        Q


;* Terminal does not match, rule fails (or tried to use Undef term)
;*  Fails QN gran if any terminal doesnt match next TKc~tkcod
TermNO W:$X ! W "TTX x ",gran," Failed at ",tok,"   [",grulst,"] #",Rn,!
      S QT="X",QN="X:"_tok
      D pze^pps("Log End TermNO","QT,tok,tki,TKc")
      Q

;*  Bump Rn ptr into grulst
;*  Rn', grulst : QN, Rn', toty, tok
IRn  NEW Q I $$arg^pps("Rn,grulst") G Qb
     S Rn=Rn+1,tok=$P(grulst," ",Rn),toty=""
     I tok="" S Rn="",QN="" G Q
     S toty="R" I tok?1P!(tok[".") S toty="T"
     G Q
;*  Bump grun/gran
;*  grun', grnun : QN, grun', gran, grulst
Iun  NEW Q I $$arg^pps("grun,grab,grnun") G Qb
     S grun=grun+1,QN=grun ; in progress
     I grun>grnun S QN="",grun="" G Q
     S gran=grab_"."_grun
     D GFL^kfm("grulst",granFL)
     G Q
;;tokFL:tkcod,tks,tkcs,tkce_TKv(tki)
;*   Bump Input token tki', tkcod~TKc,tks,tkcs,tkce
;;  : 'tki (null) => no more inputs, Done
Iin  NEW Q I $$arg^pps("tki") G Qb
     S tki=tki+1
     I tki>TKv S tki="",QI="" D NFL^kfm(tokFL) G Q  ;Done, no more Input
     D GFL^kfm(tokFL) ; TKv(tki
     S TKc=tkcod
     W:$X ! W "--nxt In:",tki,"  ",tkcod," ",tks,!
     G Q
;*
Q      Q:$Q Q Q:Q=""
Qb     D b^dv("Err ^"_$T(+0),"Q,RG,devrg,gi,grab,gran") Q:$Q Q  Q
;*
