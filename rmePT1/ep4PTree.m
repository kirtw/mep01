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
      D SPT(Sci,Scj,"TOP",10)
      ; PT(), Pcs()
      D ^ep2HGpt("PTree.html","^"_$T(+0))  ; hFil in dmep/ 
      Q
;*  Recursive sr stack accumulates til popped.
SPT(yi,xi,T,cs)
      S PT(yi,xi)=T
      S Pcs(yi,xi)=cs
        D GFL^kfm(itemFL) ; Si,Sj : @itemFL, ruLst
      F li=1:1:$L(ruLst,",") DO  ;
        .S tok=$P(ruLst,",",li)
        .S SiSj=$G(Gxi(tok))  ; Really ! ?
        .S Si=yi,Sj=li
        .D GFL^kfm("ruty,ruab",itemFL) ; Si,Sj : 
        .D GFL^kfm(itemFL) ; Si,Sj 
        .D SPT(yi+1,li,ruab,IPe-IPs+1)  ; Recursive
      Q
;*


    
;*
;*      
;;itemFL:runa,ruab,ruid,ikey,svSSq,IPs,IPe,dot,ruLst,tokR1,tokTy,ruby,frm_SCF(Si,Sj)      
      ;*
II    KILL PTR
      Q
;*

