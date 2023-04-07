ep2IMG ;CKW/ESC i5dec22 umbr./ rMP1/ ;20221205-52; grFL, itemFL
;
;
top    ;
itemFL S itemFL="runa,ruab,ruid,ikey,svSSq,IPs,IPe,dot,ruLst,tokR1,tokTy,ruby,frm_SCF(Si,Sj)"
grFL   S grFL="runa,ruab,ruty,ruLst,nLst,tokCL,nLCL,Lna,rde_GRk(ruid)"
       ;
       Q
;*       
FLi1   ;;itemFL:runa,ruab,ruid,ikey,svSSq,IPs,IPe,dot,ruLst,tokR1,tokTy,ruby,frm_SCF(Si,Sj)
FLg1   ;;grFL:runa,ruab,ruty,ruLst,nLst,tokCL,nLCL,Lna,rde_GRk(ruid)
       Q
;*
IKILL  KILL SCF,GRk,GRx
       KILL MEP,MExk
       S GRk=0
       Q
;*
TT   S T=$T(itemFL),FLi="itemFL:"_$P(T,"""",2)
     S LbL="FLi1^ep2IMG,FLi1^ep2PAR,FLi2^ep2PAR,FLi3^ep2PAR,FLi4^ep2PAR,FLi5^ep2PAR,FLi1^ep2W"
     D T2 ; FLi, LbL  for itemFL
     S T=$T(grFL),FLi="grFL:"_$P(T,"""",2)
     S LbL="FLg1^ep2IMG,FLg1^ep2PAR,FLg2^ep2PAR,FLg3^ep2PAR,FLg4^ep2PAR,FLg5^ep2PAR,FLg0^ep2W,FLg1^ep2G0"
     D T2 ;  for grFL  
     Q
;*
T2   F li=1:1:$L(LbL,",") S L=$P(LbL,",",li) DO  ;
       .S T=$T(@L)
       .S FLx=$P(T,";;",2)
       .I FLi'=FLx DO  ;
          ..W:$X ! W "Ref: ",FLi,!
          ..W "Inline Ref ",L,!,FLx,!!
       .W:$X !
     Q
