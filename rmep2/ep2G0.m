ep2G0  ;CKW/ESC i31oct22  km3a/ umbr./ rmw1/ ;20230111-50;Start mep mumps earley Parser, Compile Grammar
;  Compile Grammar  $T (No Array intermediate yet) -> GRi(ruid)=RPgr, Gxi(
;
;
top   D ^ep2IMG  ; grGL, itemFL
        ; debug later D TT^ep2IMG  ; T^dws equivalent
      S Q=$$devlog^devIO("MEP-log.html","ww2mbr/") I Q'="" D bug^dv Q
      USE devlog
      D IG00  ; Init Demo Grammar GRi(rusq)= RPgr -_-> ru*  
        D ^dv("Log post IG00","GRk")
        D WGR^ep2W  ;Display Grammar GRk(ruid)
       S Ins="1+(2*3-4)"
       D InPre(Ins)  ; : INc(Ip),INty(Ip)
       D WIN^ep2W  ; Display Ins, INc(), INty()
      ;
      D ^ep2PAR  ; Parse INc vs GRk grammar
      ;D ^ep3PAR  ;vers 3 extra IX
      ;D PT^ep2W   ; Dis parse tree
      D clog^devlog
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
        .S w=5 I w<5 S w=5
        . S Itb(Ip)=Itb,Itb=Itb+w
        .S INc(Ip)=C
        .S INc=Ip
      Q
;*      
;*  : GRi(ruid) Grammar Array  rule/item  RP: ruab => [_IPs_IPc/Si_]_dot_ruLst
;   : Gxi(runa,gi)=ruid
IG00  D TXR  ; $T to RG(ri) 
      D RGA
      KILL RG
      Q
;*
FLg1  ;;grFL:runa,ruab,ruty,ruLst,nLst,tokCL,nLCL,Lna,rde_GRk(ruid)
;*  RG() : GRk(ruid), ? Gxi
RGA      KILL GRk,Gxi ; not GRr,Gxq, no longer GRi
      D ^ep2IMG  ; grFL
      NEW ri,L,P1,Lst,ty
      NEW ruid,T,L,na,gi,ina,ruLst,ruab,rde,dot,IPs,IPe,naLua,tokCL
       S ruid=0,GRk=0,ty="R"
       S gi=-99,ina="??"  ; vs UNDEF if in/ina not found in 1st GR table entry...
      F ri=1:1:RG S L=$G(RG(ri)) DO  ;
         .; ina is rule/token name or left hand side, not repeated in my $T table
         .I L["++.." S ty="T" Q ; fence to change ty
         .S ruid=ruid+1
         .S P1=$P(L,";"),Lna=$P(L,";",2),rde=$P(L,";",3)
         .S na=$P(P1," ") DO  
            ..I na'="" S ina=na,gi=1  ;else leave ina
            ..E  S gi=gi+1
            ..S runa=ina
            ..S ruab=runa_"."_gi
         .S Lst=$$DSP^dvc($P(P1," ",2,99)) ; after na, ruLst or tokCL No spaces vs $C(20)
         .S ruty=ty
         .D SFL^kfm("runa,ruab,Lna,rde,ruty",grFL)
         .  S GRk=ruid ; Count
         .S Gxi(runa,gi)=ruid       
         .I ty="R" D GRR Q
         .I ty="T" D GRT Q
         .D b^dv("Err grammar ^"_$T(+0),"ruid,runa,ruab,ty,Lst,ruLst")
       Q
;* Gram Rule type
GRR   S ruLst=Lst
      S nLst=$L(ruLst,",")
      D SFL^kfm("ruLst",grFL)  ; ruid, GRk(ruid)
      Q
;*  Terminal tok type
GRT   S tokCL=Lst
      S nLCL=$L(tokCL) 
      I tokCL="" D b^dv("Err ty-T tokCL null","tokCL,nLCL,Lst")
      I 'nLCL D b^dv("Err ty-T tokCL","tokCL,nLCL,Lst")
      D SFL^kfm("tokCL",grFL)  ; ruid, GRk(ruid)
      ;S TYx(runa)=ty ;repeats gi but same...  tok is runa only
      Q
;*
;*  * * *
;*  $T : RG(ri) 
TXR     KILL RG S RG=0  NEW I,T,L
        S ri=0 F I=1:1 S T=$T(G00+I) Q:T["***"  Q:T=""  DO   ; 
         .S L=$P(T,";;",2,99)
         .S ri=ri+1,RG(ri)=L,RG=ri
        S ri=ri+1,RG(ri)="++..",RG=ri  ;Fence for terminals
        F I=1:1 S T=$T(Terminals+I) Q:T["***"  Q:T=""  DO  ;
         .S L=$P(T,";;",2,99)
         .S ri=ri+1,RG(ri)=L,RG=ri
        Q
;  After a new rule-name, eg s, p  may be multiple rules/items for one rule-name
;    which are alternatives - OR means of matching the rule-name 00 is Init case...
;
;;gamma sum  ;Whole parse, init condition of SC()   not done in Loup-Lua
;;  it looks for 
G00   ;;GRammar  rule-name & comma list of rule-names|tokenNa|char
;;sum sum,Psum,prod  ;Sum;sum is sum rule +/-
;;  prod
;;prod prod,Pfac,fac  ;Product; prod is product
;;  fac
;;fac Cop,sum,Ccp      ;Factor;  f vs (,s,)  with the literal char as its own name
;;  num
;;num Cdig,num      ;Number;
;;  Cdig
;;***   end Rules
Terminals  ;;terminal token names;Chars;Lua-name
;;Cdig   0123456789;[0-9]; 
;;Cop    ( ; '(' ;
;;Ccp    ) ; ')' ;
;;Psum  +- ;['+-'];
;;Pfac  */ ;['*/'];
;; ***  end Terminal tokens
