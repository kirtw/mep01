p3PAR ;CKW/ESC i7feb24 umep./ rppar1/ ;2024-0521-75;mumps table, recurse mods, mumps parser
;  TKv(tki)  Input tokenized
;
;
;;tokFL:tkcod,tks,tkcs,tkce,tkri_TKv(tki)
top     NEW Q I $$arg^p2s("TKv,GRv,GRc,GRt") G Qb
          KILL (TKv,GRv,GRc,GRt,Q)  ; debug
        D ^p2IMG
        D ^p2PAinit
        S (QT,QN,QB,QI,QG)="???"  ; just in case  Null pass, not null fails
        S tki=0 D Iin ; TKv(tki,  :  tki=1,  -> tkcod,tks, tkcs,tkce 
        S grab="mCmds"  ;Starting top rule 'mCmds', ptr Rn
        S StkP=0 KILL STK S STK=0
        I $D(Q)=0 B
        D GRAB(grab)  ;grab : QB
        I QB'="" D b^dv("Failed Parse top mCmd","QB,StkP")
        I $D(Q)=0 B        
        G Q
;*
;* * * * *
Q      Q:$Q Q Q:Q=""
Qb     D b^dv("Err ^"_$T(+0),"Q,StkP,grab,gran,QB,QN,QT") Q:$Q Q  Q
;* grab : QB null pass, else fails grab, If passes- popte, grts,grte
GRAB(grab) NEW Q I $$arg^p2s("grab") G Qb
       NEW grts,grte,grri,grde,grulst,gropsr
       D grabI
       D PSHb("GRAB")       
       F Gn=1:1:grnun S gran=grab_"."_Gn,grun=Gn D GRAN(gran) I QN="" D grabPASS G B2
       D grabFAIL ;
       S QB=QN I QB="" S QB="X?"
       D POP2("QFGRAB")  ; StkP
       G Q
B2     S popte=grte S QB=""
       D POP2("QPGRAB")  ; StkP
       G Q
;* Gn, gran, grnun : QN     
;*If finishes alt list, (Gn~grun) without passing, fails grab QB still "??"
;*
;*gran valis Gn : QN, grts,grte if QN null/pass gran/grun is a successful alt in grab
GRAN(gran)  NEW Q I $$arg^p2s("gran") G Qb
        D granI
        D PSHn("GRAN")
        FOR Rn=1:1:nlst D TOK(Rn) I QT'="" G N2
        D granPASS  ; Any tok Fail except E causes QN Fail
        G Q
N2      S QN=QT D granFAIL
        G Q
;*   
;  Print new page  fill to ln 56













;*  Rn, grulst, gran : 
TOK(Rn)  NEW Q I $$arg^p2s("Rn") G Qb
       S gnn=gran_"."_Rn_"/"_StkP
       D toty ; grulst/Rn : tok, toty, gnn
       I toty="T" GOTO GTtok
       I toty="R" GOTO GRtok
       I toty="E" GOTO GEtok
         D ^dvstk,b^dv("toty not T or R","toty,tok,Rn,grulst,gran") ; toty not T or R
         G Qb
;* Terminal tok : QT
GTtok  S tokt=tok D Ttok ; QT
       I QT="" S QN="" G Q
       ; Ttok failed, QT non-null
       G Q
GEtok  I $G(tok)="" S Q="arg-tok" G Qb
       S tokt=tok 
       ;Look ahead if fails first term, pass null
       ; t1tt same as $P(grulst," ",1) for [grab toty="E"
       S t1tt=$G(GRv(tokt,"t1tt")) 
         I t1tt="" D b^dv("GRv fail t1tok for E type [ rule","t1tt,tokt,TKc") G Qb
       I t1tt'=TKc S QT="" G Q  ;E fail first term is pass null
       GOTO GRtok  ; treat as grab      
;*  tok is grab, recurse
GRtok   ;D PSH("GRtok")  
        D GRAB(tok) S QT=QB
        I QB="" S grte=popte
        G Q
;*

;*
grabI NEW Q I $$arg^p2s("grab,StkP") G Qb
     S QB="??"   ;must be set by     
     S grts=tki,grte="???"
     D GFL^kfm("grnun,grde,grri",grabFL) ; GRv(grab : grde, grnun  
     D bln^dv3("InitGRAB")     
     G Q
;*
;*  grab, gran (grun),    granPASS any one of alts/grans so grab PASSes
grabPASS S QB=""
        I grte="" D b^dv("Err grte is null","grab,gran,grts,grte")
        D bln^dv3("grabPASS")    
        Q
;*       
;*  gran, 
granI   NEW Q I $$arg^p2s("gran") G Qb
        D GFL^kfm("grulst",granFL) ; gran, GRc(gran : grulst
        S QN="??"
        S grte="?",nlst=$L(grulst," ")
        S gropsr="",sr=$TR(grab,"[")_"^p2PSR"
          I $T(@sr)'="" S gropsr=sr ;D b^dv("Log found gropsr sr","gropsr,gran")
        S gropsyn="",sr=$TR(grab,"[")_"^p2PSYN"
          I $T(@sr)'="" S gropsyn=sr ;D b^dv("Log found gropsyn sr","gropsyn,gran")
        S grstr="???"
        D bln^dv3("InitGRAN")
        S Rn="?",tok="??"  ;for PHSn               
        G Q
;*
Ttok ;  QT null pass, else fails
;  tokt, toty="T" : QT, grte', QTest
    NEW Q I $$arg^p2s("tokt,toty") G Qb
    S DD=$D(GRt(tokt)) I DD=0 S Q="Undef tokt '"_tokt_"'" G Qb    
    S QTest=(tokt=TKc)
    I 'QTest S QT="1 tokt-Failed"_TKc_"'="_tokt D TermNO G Q
    D TermMch  
    S QT="" ;QTest matches !
    D Iin    ;Now bump tki, TKc, tk*
    I QI'="",tki=""  D b^dv("End of TKc(tki)","tki,QI")  ;No more input
    G Q
;*  Print Page Break  111    
;*
;* gran, Rn, grulst : tok, toty, QTest
toty  NEW Q I $$arg^p2s("Rn,grulst,gran") B  G Qb
    S tok=$P(grulst," ",Rn) I tok="" D bug^dv G Qb
    I (tok?1P)!(tok[".") S toty="T",QTest=(TKc=tok)
    E  I tok["[" S toty="E" 
    E  S toty="R" KILL QTest
      I tok="" S toty="X" D bug^dv S QG="tok Err null" B  G Qb
    G Q
;* gran, grts, grte :
granPASS S QN=""
        I '$G(grts) D b^dv("Err grts","gran,grts,grte")
        I '$G(grte) D b^dv("Err grte","gran,grts,grte")
        ;S nospan=grte-grts+1 S:nospan<2 nospan=""
        ;S gnC=$G(grts)_":"_$G(grte) I nospan S gnC=gnC_"/"_$G(nospan)   
        I $G(grts)="" D ^dv("Err null grts granPASS","gran,grts,grte,grab")
        I $G(gropsr)'="" DO   D @gropsr ;post pass process
          .D b^dv("Log gropsr","gropsr,gran,grts,grte,tki,tks")
        ;D SFL^kfm("grte,gnC,gropsr","_PTx(StkP,grts)")
;
      D der2
      I $D(PTx(StkP,grts,"grte")) ;D ^dv("Dupl PTx","StkP,gran,grts,grte")
      D SFL^kfm("gran,grts,grte,grstr,grulst,gropsr,gropsyn,colspan,gnC","_PTx(StkP,grts)")
        D bln^dv3("granPASS")
        ;D ^dv("Log granPASS","QT,grulst,grts,grte")
        Q
;*  grts,grte, TKv() : grstr, colspan, gnC      
der2  S grstr="'" F tkx=grts:1:grte DO  
        .S grstr=grstr_$G(TKv(tkx,"tks"),"|")
      S grstr=grstr_"'"
      S colspan=grte-grts+1
      I colspan'>1 DO  S colspan="" 
        .I colspan=1 Q
        .D b^dv("Err colspan","colspan,grts,grte,gran")
      S gnC=$G(grts)_":"_$G(grte)
      I colspan>1 S gnC=gnC_"/"_colspan
      Q
;*
granFAIL D bln^dv3("granFAIL")
        D pze^p2s("Log granFAIL","QN,QT,gran")
        Q
;*
;* Terminal matched Input tokt=TKc~tkcod/Input tki : TKc null means finished TKv input
;  Bumps both Input, tki, and rule ptr, Rn, after finding a terminal match
TermMch   S grte=tki  ;was gn te
      D bln^dv3("termPASS")
      Q
;*

;* Terminal does not match, rule fails (or tried to use Undef term)
;*  Fails QN gran if any terminal doesnt match next TKc~tkcod
TermNO S QT="X:"_tokt_" at "_$G(gnn)
      W:$X ! W "TTX x ",gran," Failed at ",tokt,"   [",grulst,"] #",Rn,!
      D bln^dv3("termFAIL")
      D pze^p2s("Log End TermNO","QT,QI,tokt,tki,TKc")
      Q
;*
p2PAsr ;CKW/ESC umep./ rppar1/ ;2024-0327-97; Increment srs Iin  tki
;*      
;;sgrabFL:grab,sty,grnun,Gn,grun,grts,grte,grde,grri_STK(StkP)
;;sgranFL:gran,sty,grulst,nlst,Rn,tok,gropsr_STK(StkP)
;;stokFL:gnn,sty,gtki_STK(StkP)
;*
grabFAIL S QB="Failed "_grab_" x"_$G(gnn) 
        D bln^dv3("grabFAIL")
        D pze^p2s("grabFAIL: Syntax Err?","QB,grab,gran,tki,TKc,StkP")
        Q
;*
xPSH(M) S M=$G(M,"argPSH") D PSHb(M),PSHn Q  ; ,PSHt  
POP2(M) S M=$G(M,"argPOP") ;D POPn,POPb(M)   Q  ; POPt,
       S StkP=StkP-2
       Q
;*
PSHb(M)  S sty="grab" S M=$G(M)
    S StkP=StkP+1 
    D SFL^kfm(sgrabFL)  ; Save
    W:$X ! W "PSHb- grab:",$G(grab),"#",StkP,!
    Q
;*      
PSHn(M) S sty="gran"  S M=$G(M)
    S StkP=StkP+1 
    S Lev=StkP
    D SFL^kfm(sgranFL) ; : STK(StkP)
    W:$X ! W "PSHn-",M," gran:",$G(gran),"#",StkP,!
    Q
;;stokFL:gnn,sty,gtki_STK(StkP)
xPSHt(M)   S M=$G(M) S sty="tok" S gtki=$G(tki)
    S StkP=StkP+1
    D SFL^kfm(stokFL)
    W:$X ! W "PSHt-",M," gnn:",$G(gnn),"#",StkP,!    
    Q
;*  
;;sgrabFL:grab,sty,grnun,Gn,grun,grts,grte,grde,grri_STK(StkP)
;;sgranFL:gran,sty,grulst,nlst,Rn,tok,gropsr_STK(StkP)
;;stokFL:gnn,sty,gtki_STK(StkP)
;*
xPOPb(M)   S M=$G(M)
    I StkP<1 D b^dv("PSHb Sync-StkP not odd ","StkP")
    D GFL^kfm(sgrabFL) ; STK(StkP,
    W:$X ! W "POPb-",M," grab:",$G(grab),"#",StkP,!
    I sty'="grab" D bug^dv("Stk sync pop/push sty grab","sty,M,StkP,grab,gran")
    S StkP=StkP-1
    Q
xPOPn(M)  S M=$G(M) ;  actually StkP=StkP-1  but dont reset loc vars ---
    I StkP<2 D b^dv("Err Stk UnderFlop pop","StkP") G Qb
    D GFL^kfm(sgranFL) ; STK(StkP,
    W:$X ! W "POPn-",M," gran:",$G(gran),"#",StkP,!    
    I sty'="gran" D ^WSTK,^dvstk,b^dv("Stk sync pop/push sty gran","M,sty,StkP,grab,gran")
    S StkP=StkP-1
    Q   
xPOPt(M)  S M=$G(M,"argPOPt")
    I StkP<2 D b^dv("Err Stk UnderFlop pop","StkP") G Qb
    D GFL^kfm(stokFL)
    W:$X ! W "POPt-",M," gnn:",$G(gnn),"#",StkP,!
    I sty'="tok" D ^dvstk,b^dv("Err POPt sty ","sty,M,StkP,gnn")
    S StkP=StkP-1
    Q      
;*  STK(), StkP, sgrabFL, sgranFL 
WSTK  NEW tbs 
      D stb^dv3("Wstkb","StkP:3,sty:5,tki:3,grab:10,grts:3,grte:3,grnun:4,grri:5,grde:20")
      D stb^dv3("Wstkn","StkP:3,sty:5,tki:3,gran:10,grts:3,grte:3,grulst:40")
      D stb^dv3("Wstkt","StkP:3,sty:5,tki:3,gnn:10")
      NEW PS S PS=StkP
    NEW sty,StkP,grab,grri,grnun,grde,grts,grte,Gn,grun,gran,grulst,gropsr,Rn,tok,gnn,gtki
    NEW T,L,xFL,SKx,sgrabFL,sgranFL,stokFL
    F xFL="sgrabFL","sgranFL","stokFL" S T=$T(@xFL^p2IMG),L=$P(T,";;",2),L=$P(L,":",2),@xFL=L
    D hdr^dv3("Wstkb"),hdr^dv3("Wstkn"),hdr^dv3("Wstkt")
    F SKx=1:1 DO  I $D(STK(SKx))=0,$O(STK(SKx))=""  Q  ;
      .S StkP=SKx
      .D GFL^kfm("sty_STK(StkP)")
      .I StkP=PS W:$X ! W "StkP:",StkP,"  *** ",!
      .I sty="grab" DO  Q
        ..D GFL^kfm(sgrabFL) ; STK(StkP,
        ..D bln^dv3("Wstkb")
      .I sty="gran" DO  Q
        ..D GFL^kfm(sgranFL) ; STK(StkP,
        ..D bln^dv3("Wstkn")     
      .I sty="tok" DO  Q
        ..D GFL^kfm(stokFL) ; STK(StkP,
        ..D bln^dv3("Wstkt")          
      W ! Q
;*
;;tokFL:tkcod,tks,tkcs,tkce,tkri_TKv(tki)
;*   Bump Input token :  QI, tki', tkcod~TKc,tks,tkcs,tkce
Iin  NEW Q I $$arg^p2s("tki") G Qb
     S QI="" I tki'<TKv S QI="End of TKv(tki" D NFL^kfm(tokFL) G Q  ;Done, no more Input
     S tki=tki+1
     D GFL^kfm(tokFL) ; TKv(tki
     S TKc=tkcod
       I TKc="" D pze^p2s("Log TKv Done.","tki,TKc,grab,Rn,grulst,tok") G Qb
     W:$X ! W "--nxt In:",tki,"  ",tkcod," ",tks,!
     G Q
;* 
