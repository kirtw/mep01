epaG0  ;CKW/ESC i31oct22  km3a/ umbr./ rmw1/ ;20221202-48;Start mep mumps earley Parser, Compile Grammar
;  Compile Grammar  $T (No Array intermediate yet) -> GRi(gsi)=RPgr, Gxi(
;  RP is structure, init in GRi and then State Tables SC()
;
top   D IG00  ; Init Demo Grammar GRi(rusq)= RPgr -_-> ru*  
        D ^dv("Log post IG00","GRi,Gxi,GRde")
        D In2  ;Wna(tok)=LNa to match Lua Output in W
        D WGR^epW  ;Display Grammar GRi(gsi), Gxi(runa,gi)
       S Ins="1+(2*3-4)"
       D InPre(Ins)  ; : INc(Ip),INty(Ip)
       D WIN^epW  ; Display Ins, INc(), INty()
      D ^epPAR  ; Parse INc vs Gr grammar
      ;D PT^epW   ; Dis parse tree
      Q
;*      
;*  Ip : INc(Ip), INty(Ip),  Itb(i)
InPre(Ins)  KILL INc,INty,Itb 
      NEW w,ci,C,Ip,ty
      S Itb=3,Ip=0
      F ci=1:1:$L(Ins) DO  ; Chars, special case here for demo
        .S C=$E(Ins,ci)
        .I C=" " Q
        .;  ci and Ip almost identical, but for spaces/wsp not used, ...
        .S Ip=Ip+1
        .D sty ; C : ty, INty(Ip)=ty    ;now optional vs ITC,IRCIT
        .S w=$L($G(ty))+2 I w<5 S w=5
        . S Itb(Ip)=Itb,Itb=Itb+w
        .S INc(Ip)=C
        .S INc=Ip
      Q
;* C : ty   Treat input chars by lex -> Classify each input (Assumes only one per char)
;      using INty
;   vs test C vs Ttok in ITcl  where Ttok name ["+" triggering terminal tests
sty   S ty="?"  ; default
      DO  ;
        .I "+-"[C S ty="Psum+" Q
        .I "*/"[C S ty="Pfac+" Q
        .I C?1N S ty="Cdig+" Q
        .I C="(" S ty="Cop+" Q
        .I C=")" S ty="Ccp+" Q
        .D b^dv("Err Unrecog C ty","C,ty,Ip")
      S INty(Ip)=ty
      Q
;*      
ITC   NEW I KILL RC
      F I=1:1 S T=$T(Terminals+I) Q:T["***"  Q:T=""  S L=$P(T,";;",2,9) S RC(I)=$$DSP^epW(L),RC=I
      Q
;*   RC(1:1) and RC=n   
IRCIT NEW Q,I,CL,tokna S Q=""
      KILL ITcl I $D(RC)'=11 D bug^dv Q
      F I=1:1 Q:$D(RC(I))=0  S L=RC(I) DO
        .S tokna=$P(L," "),CL=$P($P(L," ",2),";")
        .S ITcl(tokna)=CL
      Q
;*  : GRi(gsi) Grammar Array  rule/item  RP: ruab => [_IPs_IPc/Si_]_dot_ruLst
;   : Gxi(runa,gi)=gsi
IG00   KILL GRi,Gxi,GRde  ; not GRr,Gxq
      NEW K1,K2,K3
      S K1=$T(LPlodash),K2=$T(LPlodash^epPAR),K3=$T(LPlodash^epW)
      I K1'=K2!(K1'=K3) D b^dv("RPlodash Visible _RP ?","K1,K2,K3")
      D ITC,IRCIT  KILL RC ; : ITcl(Ttok)=charList
       NEW I,T,L,na,gi,ina,ruLst,ruab,rde,gsi,dot,IPs,IPe,RPg
       S gsi=0,Gxq=0
       S gi=-99,ina="??"  ; vs UNDEF if in/ina not found in 1st GR table entry...
       F I=1:1 S T=$T(G00+I) Q:T["***"  Q:T=""  DO   ; ina persists between iterations
         .S L=$P(T,";;",2),rde=$P(L,";",2),L=$P(L,";")
         .; ina is rule/token name or left hand side, not repeated in my $T table
         .S na=$P(L," ") D:0 ^dv("Log na","na") I na'="" DO  
            ..S ina=na,gi=1  ;else leave ina
            ..S ruab=ina_"."_gi
         .S runa=ina
         .I na="" S gi=gi+1,ruab=runa_"."_gi
         .S gsi=gsi+1
         .S rusq=gsi
         .S ruLst=$P(L," ",2,99),ruLst=$TR(ruLst," ") ;remove spaces, ruLst ~ right hand side
         .I ; ?
         .I runa="" D b^dv("Err ina null","runa,ina,I,na,ruLst") Q
         .S ruab=runa_"."_gi     
         .S IPs=0,IPe=0,dot=0  ; def, Init value when copied from GRi to SC(Si,end+1)
         .S wna=ruab_"/"_rusq,wna=wna_$E($J("",10),$L(wna),10)
         .  I $L(wna)'=11 D b^dv("Err left just len wna","wna")
         .S RPg=wna_"=> [_"_IPs_"_"_IPe_"_"_dot_"_"_ruLst    ; _"_       ; "_rde
         .S GRi(gsi)=RPg,GRi=gsi
         .S Gxi(runa,gi)=gsi
         .S Gxi(runa)=gi     ; num gi entries   
         .I rde'="" S GRde(gsi)=rde  ; dupl, only if specified, sparse
       Q
;*
RPlodash ; _1 runa.gi / rusq, _2 IPs, _3 Ipe~Si, _4 dot, _5 ruLst, _6 frm
;*  ;4 of G00 
In2    KILL Wna  NEW tok,LNa,I,T
       F I=1:1 S T=$T(G00+I) Q:T'[";;"  DO  ;
         .I T["***" Q  ; Ignore, do Terminals too
         .S tok=$P($P(T,";",3)," ") 
         .I tok="" Q
         .S LNa=$P(T,";",4)
         .I LNa'="" S WNa(tok)=LNa
       ; Supplemental tok/rule names to match Lua Output of S in WS
       Q
;*
;  After a new rule-name, eg s, p  may be multiple rules/items for one rule-name
;    which are alternatives - OR means of matching the rule-name 00 is Init case...
;
;;gamma sum  ;Whole parse, init condition of SC()   not done in Loup-Lua
;;  it looks for 
G00   ;;GRammar  rule-name & comma list of rule-names|tokenNa|char
;;sum sum,Psum+,prod  ;Sum;sum is sum rule +/-
;;  prod
;;prod prod,Pfac+,fac  ;Product; prod is product
;;  fac
;;fac Cop+,sum,Ccp+      ;Factor;  f vs (,s,)  with the literal char as its own name
;;  num
;;num Cdig+,num      ;Number;
;;  Cdig+
;;***   end
Terminals  ;;terminal token names;Chars;Lua-name
;;Cdig+ 0123456789;[0-9];
;;Cop+ (; '(' ;
;;Ccp+ ); ')' ;
;;Psum+ +-;['+-'];
;;Pfac+ */;class('*/')
;; ***
