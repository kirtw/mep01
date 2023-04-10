ep2IMG ;CKW/ESC i5dec22 umbr./ rMP1/ ;20221205-52; grFL, itemFL
;
;
top    ;
itemFL S itemFL="runa,ruab,ruid,ikey,svSSq,IPs,IPe,dot,ruLst,tokR1,tokTy,ruby,frm_SCF(Si,Sj)"
grFL   S grFL="runa,ruab,ruty,ruLst,nLst,tokCL,nLCL,Lna,rde_GRk(ruid)"
       ;
       D ^kfmUafl("umep")  ;Audit *FL comments
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
xTT   ; See ^kfmUafl("umep")  - uses *FL loc vars and mpjD to find mrou to scan for ;; FL: lines
;*

