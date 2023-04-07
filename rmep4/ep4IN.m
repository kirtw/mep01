ep4IN(Ins) ;CKW/ESC i14feb23 rmep4/ ;20230214-89; Expand input to 
;  from Inpre^ep*G0
;
;*  Ip : INc(Ip), INty(Ip),  Itb(i)
InPre NEW Q S Q=""  
      KILL INc,INty,Itb 
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
