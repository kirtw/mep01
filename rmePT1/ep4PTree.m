ep4PTree ;CKW/ESC i27apr23 umep./  rmePT1/ ;20230427-74;Gen Parse tree from State Table
;  Ref table HGen in ^
;
;
;   SCF(Si,Sj), GRk ? if needed
;       successful rule to unwind Si,Sj  or 
;
;   SCF(), Sci,Scj  : 
top   D II  ;
      S Sci=10,Scj=3,itn=78
;
      Q
      ;
      F tbi=1:1 DO  ;
        .D GFL^kfm(itemFL)
        .S cs=IPe-IPs+1
        .
      
      D ^ep2HGpt("PTree.html","^"_$T(+0))
      Q
;*
;*      
;;itemFL:runa,ruab,ruid,ikey,svSSq,IPs,IPe,dot,ruLst,tokR1,tokTy,ruby,frm_SCF(Si,Sj)      
      ;*
II    KILL PTR
      Q
;*

