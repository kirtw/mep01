ppPAR ;CKW/ESC i7feb24 umep./ rppar1/ ;2024-0313-43;mumps table mumps parser
;
;
;;tokFL:tkcod,tks,tkcs,tkce_TKv(tki)
top     KILL STK S STK=1  D ^ppIMG
        KILL PTx S PTx=0  S pti=1
        S (QS,QT,QN,QB,QI,QA)="???"  ; just in case  Null pass, not null fails
        D Istb  ;
        S tki=0 D Iin ; tki : TKv(tki, tkcod,tks, tkcs,tkce 
        S grab="mCmds",Rn=1,grun=1  ;Starting top rule 'mCmds', ptr Rn
        ;
        S QQ=$$TRVgrab(grab,STK)
        I QQ'="" D b^dv("Err Final/Initial grab mCmds ","QQ,QB,grab")
        Q  ;top Done, line LM and TKv(tki,  -> PTx, etc. 
;*
; Process TKv(tki, vs grab  Recursive
;*  : QB null pass, else fails
TRVgrab(grab,STK) NEW QB S QB="??" I $$arg^pps("grab") G QB      ; grab,grun,Rn 
        NEW grde,grri,grnun,grun,gran,grulst,gropsr,Rn,tok,toty,gn,grts,grte,grstr
        S grun=1,Rn=1 S QB="X" S grts=tki
        D GFL^kfm(grabFL) ; GRv(grab : grde, grnun  
        D bln^dv3("InitGRAB")
        F gn=1:1:grnun S grun=gn S QN=$$TRVgran I QN="" S QB=QN D grabPASS G QB
        ;If finishes alt list, grun) without passing, fails grab QB still "X"
        S QB="Failed "_grab_" x"_gn 
        D grabFAIL
QB      I QB="??" D b^dv("Err ","QB,grab")
        Q QB
;*  grab, gran (grun),     Passed one of alts/grans so grab PASSes
grabPASS ;
        D bln^dv3("grabPASS")
        S gstr=grstr ; pass up
        ;gropsr, grab/gran specific
        Q
;*
grabFAIL ;
        D bln^dv3("grabFAIL")
        D pze^pps("grabFAIL: Syntax Err?","QB,grab,gran,tki,TKc,STK")
        Q
;;grabFL:grde,grnun,grri_GRv(grab)
;* grab,grun (valid not >grnun), grab : QN, if QN null/pass gran/grun is successful alt
TRVgran() NEW Q I $$arg^pps("grun,grab") G GF
        NEW Rn,gran,grulst,Rn,QT,grstr S Rn=1
        D Sgran ; grun, grab : gran
        D PSH(STK)
        S QN="??",grstr="<"
        D bln^dv3("InitGRAN")
        F Rn=1:1:$L(grulst," ") DO  I QT'="" S QN=QT G GF  ; Any tok Fail causes QN Fail
          .S X=$$Gtok ; Rn, grulst : toty, tok, grstr
          .S QT=$$TestTOK ; toty,tok : QT null pass, else fail
          .I QT="???" D bug^dv("Err TestTOK vs QT out","QT,Rn,tok,toty,grstr")
        ; falls thru if passed all in grulst 
        D bln^dv3("granP")
        D POP(STK)
QN      Q:$Q QN  D bug^dv Q
GF      D bln^dv3("granF")
        Q:$Q QN  D bug^dv Q
        
        
 
    
;*  grun, grab, grnun : gran, grulst, (grun, )      
Sgran()  NEW Q I $$arg^pps("grun,grab,grnun") G Qb
      S gran=grab_"."_grun  ;grun pre-controlled for <=grnun here (No test, no Q*, No branch)
      D GFL^kfm(granFL) ; : grulst, gropsr
      G Q

;*

;;stkFL:grab,grun,gran,grulst,Rn_STK(STK)
PSH(Stk)  S Lev=Stk 
    D SFL^kfm("grab,Lev_STK(Stk)")  ; Save, not actually stack function vs recursive save Tgrab/Tgran
    Q
POP(Stk)  ;
    NEW grab,grun,gran,grulst,Rn
    D GFL^kfm("grab,Lev_STK(Stk)") ; STK(STK,
    ;
    Q
WSTK  D stb^dv3("STK","STK:4,grab:10,grun:4,gran:12,grulst:40,Rn:4")
    NEW grab,grun,gran,grulst,Rn
    F STK=1:1:STK DO  ;
      .D GFL^kfm(stkFL)
      .D bln^dv3("STK")
    W ! Q
;*
;;pt1FL:Lev_PTx(pti)
;;pt2FL:gran,grts,grte,grstr_PTx(pti,tki)        
xSVgrab  D SFL^kfm(pt2FL) ; PTx(pti,tki)
        Q
;*
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
