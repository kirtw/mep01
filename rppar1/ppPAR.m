ppPAR ;CKW/ESC i7feb24 umep./ rppar1/ ;2024-0208-01;mumps table parser
;
;
;  TKv(ti)  tokens @tokFL, 
;  GRv(grab), GRc(gran)  Grammar  start top with Scom for now (or mCmds)
;*  Parse Table - also set of Arrays, PT*()
;
;
;  Single stack - Push rule and ptr current next rule from list
; Pop when finish a rule
; Look at next token when terminal comes up in rule, ie ["."
;;tokFL:tkcod,tks,tkcs,tkce_TKv(tki)
top     KILL STK S STK=0
        S tki=1 D GFL^kfm(tokFL) ; tki : tkcod,tks, tkcs,tkce
        S TKc=tkcod
        S grabC="mCmds",RnC=1,grunC=1  ;Starting top rule 'mCmds', ptr RnC
        ;
        ; Process TK(tki, 
T1      D GRU(grabC,grunC,RnC) ; : gran,grulst, toty, tok
          I tok="" DO  G T1
            .D bug^dv("tok null","tok,grabC,grunCmRnC") 
            .D DLST 
            .I STK=1 D bug^dv("STK empty","STK") Q
            .D POP 
        I toty="T",tok=TKc D TT1 G XE:TKc="",rulDUN:'RnC G T1  ;End of TK inlut, tki/TKc=""
        I toty'="R" D bug^dv("toty R or T","toty") G Qb
stkFL  ;;stkFL:grabC,grunC,grulst,RnC_STK(STK)
        D PSH  ; 
        S RnC=1,grabC=tok,grunC=1
        G T1
XE      D b^dv("Found end of input on term match","TKc,tki,grabC,grabN,RnC")
        ;  ? what next
        Q
;*        
rulDUN  ; log grabC/grunC  tkcs,tkce  tkis,tkie, rul-str'
        ; needs gran from GRU(...      post-SR gran
        D GFL^kfm("gopsr",granFL) ; GRc(gran,
        I gopsr'="" DO  
          .I gopsr'["^" S gopsr=gopsr_"^ppPO"
          .S sr=$T(@gopsr) I sr="" D bug^dv Q
          .D @gopsr
        D POP ; restore grabC,grunC, RnC
        ;Bump RnC
        S RnC=RnC+1 I RnC>$L(grulst," ") S RnC=0 G rulDUN
        S tok=$P(grulst," ",RnC) I tok="" D bug^dv Q
        S grabC=tok,RnC=1,grunC=1 G T1
;*
DLST    ;Finished grulst
        BREAK
        Q
DUN     BREAK  ;Finished whole parse Line TK()
        Q
;*
Q      Q:$Q Q Q:Q=""
Qb     D b^dv("Err ^"_$T(+0),"Q,RG,devrg,gi,grab,gran") Q:$Q Q  Q
;*        
;*  : TKc null means finished TK input
;  Bumps both Input, tki, and rule ptr, RnC, after finding a terminal match
TT1   ;S grce=tkce
      ; push tkcs, tkce into PT(grab/gran)
      S tki=tki+1 I tki>TK S TKc=""  ;output flag Input done
      D GFL^kfm("tkcod,tks",tkFL) ; TK(tki,  tkcod,tks,tkcs,tkce
      S TKc=tkcod
      ;Bump Rule ptr RnC fwd
      S RnC=RnC+1 I RnC>$L(grulst," ") S RnC=0 ;flg rule done
      S tok=$P(grulst," ",RnC)
        I tok="" D bug^dv G Qb
      Q
        

;* : gran, grulst/gran, tok, toty
GRU(grabA,grunA,RnA) NEW Q I $$arg^pps("grabA,granA,RnA") G Qb
    S gran=grabA_"."_grunA
    D GFL^kfm("grulst",granFL) ; GRc(gran,
      ;S grulst=$G(GRc(gran))
      I grulst["/" D b^dv(" ^ppGRI should have removed","grulst,gran") G Qb
    S tok=$P(grulst," ",RnA)
    S toty="R" I tok?1P!(tok[".") S toty="T"
    G Q
;*
PSH  S stkFL="grabC,grunC,grulst,RnC_STK(STK)"
     S STK=STK+1
     D SFL^kfm(stkFL)
     Q
;*  : gran, Rn, grulst, gposr
POP  I STK<1 D bug^dv("POP too many, STK empty STK=0","STK") Q
     D GFL^kfm(stkFL) 
     S STK=STK-1
     Q

;*  Recursive sr Rule ~ Stack
;*  RN ptr into LST - grulst
;*  : QRU Pass 1/Fail 0    $$RR is Q bug
;* 1st arg TOK becomes RUL
RR(TOK,Rn,LST)  NEW Q I $$arg^pps("RUL,Rn,LST") G Qb
       S LQ=$G(GRc(RUL)) I LQ'=LST S Q="Err LST vs RUL" G Qb
R1     S TOK=$P(LST," ",Rn)
       I TOK=""  S QRU=1 Q
       I TOK["."  DO  Q  ;  terminal
         .I TKk=TOK ;matches term tok
         .I TKc=TOK ;?
         .D ERP S Q="Err" ;Parse Error
       ;Here TOK is new rule
       DO  G Q
         .S Q=$$RR(TOK,1)
         .  I 'QRU G Q
         .S Rn=Rn+1,TOK=$P(LST," ",Rn)
         .S Q=$$RR(TOK,Rn)
       S Q="Fall-to-End" 
       G Qb  ;should not get here
ERP    Q
;*
