epaIMG ;CKW/ESC i5dec22 umep./ rcfg/ ;20221205-52; grFL, itemFL
;  renamed from ^ep2IMG and from rsr/ to rcfg/ 27apr23 kw
;
top    ;
itemFL S itemFL="runa,ruab,ruid,ikey,svSSq,IPs,IPe,dot,ruLst,tokR1,tokTy,ruby,frm_SCF(Si,Sj)"
grFL   S grFL="runa,ruab,rugi,ruty,ruLst,nLst,tokCL,nLCL,Lna,rude_GRk(ruid)"
       ;
grpFL  ;S grpFL="   _GRc(cran)"
       Q
;*
;*   By caller, once each startup ^cmdMenu    
audFL D ^epaIMG,^kfmUafl("umep")  ; 2nd arg Save MRou code (not yet)
      Q
;*       
FLi1   ;;itemFL:runa,ruab,ruid,ikey,svSSq,IPs,IPe,dot,ruLst,tokR1,tokTy,ruby,frm_SCF(Si,Sj)
FLg1   ;;grFL:runa,ruab,ruty,ruLst,nLst,tokCL,nLCL,Lna,rude_GRk(ruid)
       Q
;*
IKILL  KILL SCF,GRk,GRx
       KILL MEP,MExk
       S GRk=0
       Q
;*
xTT   ; See ^kfmUafl("umep" or PB)  - uses *FL loc vars and mpjD to find mrou to scan for ;; FL: lines
;*

