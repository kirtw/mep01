p2PAR ;CKW/ESC i7feb24 umep./ rppar1/ ;2024-0404-68;mumps table, STK GOTO, mumps parser
;  TKv(tki)  Input tokenized
;  GRv(   GRt( ...
;   : PX(
;
;;tokFL:tkcod,tks,tkcs,tkce,tkri_TKv(tki)
top     NEW Q I $$arg^pps("TKv,GRv,GRc,GRt") G Qb
          KILL (TKv,GRv,GRc,GRt)  ; debug
        D ^p2IMG
        D ^p2PAinit
        S (QS,QT,QN,QB,QI,QA)="???"  ; just in case  Null pass, not null fails
        S tki=0 D Iin ; TKv(tki,  :  tki=1,  -> tkcod,tks, tkcs,tkce 
        S grab="mCmds",Rn=1,grun=1  ;Starting top rule 'mCmds', ptr Rn
        S StkP=0
        ;
        GOTO GOgrab ;grab : QB
        
        I Q'=QB D b^dv("Where is return Q","Q,QB,grab")
Qtop    I QB'="" D b^dv("Err Final/Initial grab mCmds ","QQ,QB,grab")
        ; gstr ?  
        G Q  ;top Done, line LM and TKv(tki,  -> PTx, etc. 
;*
;;pt2FL:gran,gnts,gnte_PTx(StkP,gnts)
;*
Q      Q:$Q Q Q:Q=""
Qb     D b^dv("Err ^"_$T(+0),"Q,RG,devrg,gi,StkP,grab,gran") Q:$Q Q  Q
;*
GOgrab ;CKW/ESC umep./ rppar1/ ;2024-0401-45;TRVgrab/top and TRVgran modules
;  : QB null pass, else fails grab
     I $$arg^pps("grab,StkP") G Qb
     ; Process TKv(tki, vs grab
     ;NEW grde,grri,grnun,Gn,grun,gran,grulst,gropsr,Rn,tok,toty,grts,grte ;
     S QB="??"   ;must be set by     
     S grts=tki,grte="?"
     D GFL^kfm("grnun,grde,grri",grabFL) ; GRv(grab : grde, grnun  
     D bln^dv3("InitGRAB")
     S Gn=0,grun=Gn  ;     
     D PSHb
GAloop  I Gn=grnun D grabFAIL ;...Ret
     ;F Gn=1:1:grnun D grabA  I QN="" D grabPASS G QB
     ;If finishes alt list, grun) without passing, fails grab QB still "??"
     S Gn=Gn+1,grun=Gn,gran=grab_"."_grun
grabA ;NEW gnts,gnte
      ;  S Q=$$PAgran(gran)   ; QN, gnts,gnte      
      S Rn=0,Retn="QgrabA" 
      GOTO GOgranI
;*
QgrabA  S grte=gnte
        D ^dv("Post grabA gran-grab ","gnte,grte,gran,grab,StkP")
        I gran="Karg.1",gnte'=3 D b^dv("Err gnte","gran,gnte,grte")
        I Q="",QN="" S QB=""
        GOTO GAloop     
Qgrab ;
QB   I QB="??" S Q="Err no QB set" D bug^dv(Q,"QB,grab,StkP") G Qb
     G Q
;*  grab, Gn : QB null pass, else fails Alt Gn
;*
;*gran (valid not >grnun) : QN, gnts,gnte if QN null/pass gran/grun is a successful alternative in grab
GOgranI  I $$arg^pps("grun,grab") G Qb
        ;S StkP=StkP+1  I StkP#2'=0 D b^dv("Err StkP","StkP even in gran?","StkP,gran,grab")    
        D GFL^kfm("grulst",granFL) ; gran, GRc(gran : grulst, gropsr  
        S QN="??"
        S gnts=tki,gnte="?",nlst=$L(grulst," ")
        D bln^dv3("InitGRAN")
        ;I $G(grts)'=$G(gnts) D b^dv("Mismatch *ts","grts,gnts,gran,grab,StkP")        
        ;S PTx(StkP,gnts,"gran")=gran
        I $G(gnts)="" D b^dv("Err gnts null","gnts,gnte,gran")
        D PSHn ;        
        ;D SFL^kfm("gran,gnts_PTx(StkP,gnts)")
        ;F Rn=1:1:nlst DO  I QN'="" D granFAIL G QN  ; Any tok Fail causes QN Fail
        S Rn=0
GOgran  I Rn=nlst D granPASS G Qgran  ; Any tok Fail causes QN Fail
        S Rn=Rn+1

;*  Rn, grulst, gran : 
GOtok  S gnn=gran_"."_Rn_"/"_StkP
       D toty ; grulst, Rn : tok, toty, gnn
       I toty="T" D Ttok G GOgran:QT="" S QN=QT GOTO Qgran
       I toty="R"  D Rtok  GOTO GOgrab:QN=""  Q ;
       D bug^dv ; toty not T or R
       Q
;* tok : QT
Rtok    S grab=tok
        S gnte=$G(grte)  ; also gnts?
        I gnte="" D b^dv("Err post grab","gran,tok,grte,gnte")
        Q       
;Returns (GO) here from Qgrab
Qtok I Rn<nlst S Rn=Rn+1 GOTO GOtok
     ; falls thru if passed all Rn/tok in grulst 
     D granPASS S QN="" ; ?
     GOTO Qgrab
Qgran   BREAK
        Q
QN      G Q

Ttok ; QTest, QT null pass, else fails
;  tokt, toty="T" : QT, gnte'
    I $$arg^pps("tokt,toty") G Qb
    S DD=$D(GRt(tokt)) I DD=0 S Q="Undef tokt '"_tokt_"'" G Qb    
    S QTest=(tokt=TKc)
    I 'QTest S QT="X tokt-Failed"_TKc_"'="_tokt D TermNO GOTO Qtok
    D TermMch  
    S QT="" ;QTest matches !
    ;above before bumping tki, here
    D Iin    ;Now bump tki, TKc, tk*
    I QI'="",tki=""  D b^dv("End of TKc(tki)","tki,QI")  ;No more input
    Q


;*
;* gran, Rn, grulst : toty, tok, gnn 
toty   I $$arg^pps("Rn,grulst,gran") B  G Qb
    S tok=$P(grulst," ",Rn) I tok="" D bug^dv G Qb
    I (tok?1P)!(tok[".") S toty="T",QTest=(TKc=tok)
    E  S toty="R" KILL QTest
      I tok="" S toty="X" D bug^dv S QG="tok Err null" B  G Qb
    Q
;* gran, gnts, gnte :
granPASS S QN=""
        I gran="Karg.1",gnte'=3 D b^dv("Err gnte","grte,gran,gnn")
        S nospan=gnte-gnts+1 S:nospan=1 nospan=""
        S gnC=$G(gnts)_":"_$G(gnte)_"/"_$G(nospan)   
        I $G(gnts)="" D b^dv("Err null gnts granPASS","gran,gnts,gnte,grab,grts,grte")
        D SFL^kfm("gnte,gnC","_PTx(StkP,gnts)")
        D bln^dv3("granPASS")
        ;D pze^dv("Log granPASS","QT,grulst,gnts,gnte")
tsqbFL  ;;tsqbFL:grab,grnun,grts,grte,grde,grri_HQT(StkP)
tsqnFL  ;;tsqnFL:gran,gnts,gnte,grulst_HQT(StkP)
        S HQxn(gran,StkP)=""
        D POPn
        Q
granFAIL D bln^dv3("granFAIL")
         D POPn
         D pze^dv("Log granFAIL","QN,QT,gran")
        Q
;*


;*
;* Terminal matched Input tokt=TKc~tkcod/Input tki : TKc null means finished TKv input
;  Bumps both Input, tki, and rule ptr, Rn, after finding a terminal match
TermMch   S gnte=tki
      I $D(PTx(StkP,gnts,"gnte")) ;D ^dv("Dupl PTx","StkP,gran,gnts,gnte")
      D SFL^kfm("gran,gnts,gnte","_PTx(StkP,gnts)")
      ;W:$X ! W "TermMch ",tokt," in ",gran," #",Rn,"  vs tki:",tki,"  <",tks,"> ->",grstr,!
      D bln^dv3("termPASS")
      Q
;* Terminal does not match, rule fails (or tried to use Undef term)
;*  Fails QN gran if any terminal doesnt match next TKc~tkcod
TermNO S QT="X:"_tokt_" at "_$G(gnn)
      W:$X ! W "TTX x ",gran," Failed at ",tokt,"   [",grulst,"] #",Rn,!
      D bln^dv3("termFAIL")
      D pze^pps("Log End TermNO","QT,QI,tokt,tki,TKc")
      Q
;*
p2PAsr ;CKW/ESC umep./ rppar1/ ;2024-0327-97; Increment srs Iin  tki
;*      
;;grabFL:grde,grnun,grri_GRv(grab)
;*  grab, gran (grun),    granPASS any one of alts/grans so grab PASSes
grabPASS S QB=""
        S grte=$G(gnte) 
           I grte="" D b^dv("Err grte/gnte","grab,gran,grte,gnte")
        D bln^dv3("grabPASS")    
        I grab="Karg",grte'=3 D b^dv("Err grte grabPASS","grab,gran,grte,gnte") 
        ;D pze^pps("Pop gnts","gran,grts,gnts,grte,gnte,gnn,grC")     
        ;D tse1^pps("end grabPASS",grab)   
;;sgrabFL:grab,grnun,Gn,grun,grts,grte,grde,grri_HQT(StkP)
;;sgranFL:gran,gnts,gnte,grulst_HQT(StkP)        
        D PSHb  ; : STK(StkP)
        Q
;*
grabFAIL S QB="Failed "_grab_" x"_gn 
        D bln^dv3("grabFAIL")
        D pze^pps("grabFAIL: Syntax Err?","QB,grab,gran,tki,TKc,StkP")
        Q
;*
PSH  D PSHb,PSHn Q
PSHb()  S sty="grab"
    S StkP=StkP+1 I StkP#2'=1 D bug^dv Q
    D SFL^kfm(sgrabFL)  ; Save, not actually stack function vs recursive save Tgrab/Tgran
    Q
;*      
PSHn() S StkP=SytkP+1 I StkP#2'=0 D bug^dv Q 
    S Lev=StkP,sty="gran"
    D SFL^kfm(sgranFL) ; : STK(StkP)
    Q
POPb()  ;  actually StkP=StkP-1  but dont reset loc vars ---
    I StkP<2 D b^dv("Err Stk UnderFlop pop","StkP") Q
    D GFL^kfm("sty,gnts",sgrabFL) ; STK(StkP,
    I sty'="grab" D bug^dv("Stk sync pop/push sty grab","sty,StkP,grab,gran")
    S StkP=StkP-1
    Q
POPn()  ;  actually StkP=StkP-1  but dont reset loc vars ---
    I StkP<2 D b^dv("Err Stk UnderFlop pop","StkP") Q
    D GFL^kfm("sty,gnts",sgranFL) ; STK(StkP,
    I sty'="gran" D bug^dv("Stk sync pop/push sty gran","sty,StkP,grab,gran")
    S StkP=StkP-1
    Q    
WSTK  D stb^dv3("Wstk1","StkP:3,tki:3,grab:10,grts:3,grte:3,grnun:4,grri:5,grde:20")
      D stb^dv3("Wstk2","StkP:3,tki:3,gran:10,gnts:3,gnte:3,grulst:40,Rn:4,tok:10")
    NEW grab,grri,grde,grst,grse,Gn,grun,gran,gnts,gnte,grulst,Rn,tok
    F STK=1:2:StkP DO  ;
      .S StkP=STK
      .D GFL^kfm(sgrabFL) ; STK(StkP,
      .D bln^dv3("Wstk1")
      .S StkP=STK+1
      .D GFL^kfm(sgranFL) ; STK(StkP,
      .D bln^dv3("Wstk2")      
      W ! Q
;*
;*  trq
trc(M,VL) I $$arg^pps("M,VL") D bug^dv Q
    S trq=trq+1
    I gran="KCmd.1" D b^dv("Log trc","M,StkP,trq,grab,gran,Rn,grulst")
    Q
;*
;;tokFL:tkcod,tks,tkcs,tkce,tkri_TKv(tki)
;*   Bump Input token :  QI, tki', tkcod~TKc,tks,tkcs,tkce
Iin  NEW Q I $$arg^pps("tki") G Qb
     S tki=tki+1
     I tki>TKv S tki="",QI="End of TKv(tki" D NFL^kfm(tokFL) G Q  ;Done, no more Input
     D GFL^kfm(tokFL) ; TKv(tki
     S TKc=tkcod
       I TKc="" D bug^dv("Log TKv Done.","TKc,grab,Rn,grulst,tok")
     W:$X ! W "--nxt In:",tki,"  ",tkcod," ",tks,!
     S QI=""
     G Q
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
;*
