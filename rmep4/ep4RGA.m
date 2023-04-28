ep4RGA ;CKW/ESC i14feb23 umep./ rmep1/ ;20230214-66;Compile Grammar RG() : 
;  From RGA^ep3/2G0   RG()  In:RG()  : GRk(ruid), 
;
;*
;;grFL:runa,ruab,ruty,ruLst,nLst,tokCL,nLCL,Lna,rude_GRk(ruid)
;     RG() : GRk(ruid), Gxi(runa,gi)=ruid
RGA      KILL GRk,Gxi ; not GRr,Gxq, no longer GRi
      D ^epaIMG  ; grFL
      NEW ri,L,P1,Lst,ty
      NEW ruid,T,L,na,rugi,ina,ruLst,ruab,rude,dot,IPs,IPe,naLua,tokCL
       S ruid=0,GRk=0,ty="R"
       S rugi=-99,ina="??"  ; vs UNDEF if in/ina not found in 1st GR table entry...
      F ri=1:1:RG S L=$G(RG(ri)) DO  ;
         .; ina is rule/token name or left hand side, not repeated in my $T table
         .I $E(L)="#" Q         
         .I L["++.." S ty="T" Q ; fence to change ty to Terminals for rest
         .I $$DSP^dvc(L)="" Q
         .S ruid=ruid+1
         .S P1=$P(L,";"),Lna=$P(L,";",2),rude=$P(L,";",3)
         .S na=$P(P1," ") DO  
            ..I na'="" S ina=na,rugi=1  ;else leave ina
            ..E  S rugi=rugi+1
            ..S runa=ina
            ..S ruab=runa_"."_rugi
         .S Lst=$$DSP^dvc($P(P1," ",2,99)) ; after na, ruLst or tokCL No spaces vs $C(20)
         .S ruty=ty
         .D SFL^kfm("runa,ruab,rugi,Lna,rude,ruty",grFL) ; : GRk(ruid,
         .  S GRk=ruid ; Count
         .S Gxi(runa,rugi)=ruid       
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
