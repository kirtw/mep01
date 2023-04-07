ep4RGA ;CKW/ESC i14feb23 umep./ rmep1/ ;20230214-66;Compile Grammar RG() : 
;  From RGA^ep3/2G0  sr  after $T -> RG()  In:RG()  : GRk(ruid), 
;
;*
FLg1  ;;grFL:runa,ruab,ruty,ruLst,nLst,tokCL,nLCL,Lna,rde_GRk(ruid)
;     RG() : GRk(ruid), ? Gxi
RGA      KILL GRk,Gxi ; not GRr,Gxq, no longer GRi
      D ^ep2IMG  ; grFL
      NEW ri,L,P1,Lst,ty
      NEW ruid,T,L,na,gi,ina,ruLst,ruab,rde,dot,IPs,IPe,naLua,tokCL
       S ruid=0,GRk=0,ty="R"
       S gi=-99,ina="??"  ; vs UNDEF if in/ina not found in 1st GR table entry...
      F ri=1:1:RG S L=$G(RG(ri)) DO  ;
         .; ina is rule/token name or left hand side, not repeated in my $T table
         .I L["++.." S ty="T" Q ; fence to change ty to Terminals for rest
         .I $E(L)="#" Q
         .I $$DSP^dvc(L)="" Q
         .S ruid=ruid+1
         .S P1=$P(L,";"),Lna=$P(L,";",2),rde=$P(L,";",3)
         .S na=$P(P1," ") DO  
            ..I na'="" S ina=na,gi=1  ;else leave ina
            ..E  S gi=gi+1
            ..S runa=ina
            ..S ruab=runa_"."_gi
         .S Lst=$$DSP^dvc($P(P1," ",2,99)) ; after na, ruLst or tokCL No spaces vs $C(20)
         .S ruty=ty
         .D SFL^kfm("runa,ruab,Lna,rde,ruty",grFL) ; : GRk(ruid,
         .  S GRk=ruid ; Count
         .S Gxi(runa,gi)=ruid       
         .I ty="R" D GRR Q
         .I ty="T" D GRT Q
         .D b^dv("Err grammar ^"_$T(+0),"ruid,runa,ruab,ty,Lst,ruLst")
       KILL RG  ;Cleanup
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
