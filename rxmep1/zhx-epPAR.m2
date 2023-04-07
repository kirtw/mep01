epPAR  ;CKW/ESC i31oct22 ;20221031-56;Parse IN(),INty  into Gr Grammar...
;
;  Gr(<rule-name>  ~ left-hand-side
;   Gr(<rule-name>, ri 1:1  multiple (sub) rules
;  INc(Ip)=literal input chars
;  INty(Ip)= type  {
;
;  SC items or rules have 3 _ pieces  or dotted-rule
;   ruL:   _1 is ruL a comma list of rule-names
;   Pdot:  _2 is dot, a ptr into the current ruL comma pieces
;   Ips    _3 is the input start pointer, Ips
;    
top    W !!,"Magic  Parsed !"
       KILL SC
       S SC(1,1)="s_0_0_gamma"  ; Initial conditions
       ;
main   ; loop thru INputs, Ip
       F Ip=1:1:IN  D ParOneIN(Ip)
       Q
;*
ParOneIN(Ip)
       ;
       ; rule loop, item-loop, within one SCi
       S Si=Ip
       F ri=1:1 Q:$D(SC(Si,ri))=0  D ParRu  ;inside loop chart items/rules
       F ri=1:1 Q:$D(SC(Si,ri))=0  D scan  ;inside loop chart items/rules
       F ri=1:1 Q:$D(SC(Si,ri))=0  D complete  ;inside loop chart items/rules       
       D ^dv("Log End ParOne","Si,ri,SC")
       Q
;*   Si,ri     
ParRu  S RPi=SC(Si,ri)
       S ruL=$P(RPi,"_")  ; comma list
       S dot=$P(RPi,"_",2)  ; ptr into ruL
       S IPs=$P(RPi,"_",3)
       S fr=$P(RPi,"_",4) ; left hand side 
       S TokR1=$P(ruL,",",dot+1)
       D ^dv("Log Parsing ParRu ","Si,ri,RPi,TokR1,dot,IPs,ruL,fr")
pred   F gi=1:1 Q:$D(Gr(TokR1,gi))=0  DO
         .S RPgr=Gr(TokR1,gi)  ;
         .D ^dv("Log pred new Gr rules","TokR1,gi,RPgr")
         .D SSC(Si,RPgr) ; save in this State Si at end
       Q
       ; falls thru for Si,ri
scan   S ty=INty(Si),C=IN(Si)
       S RPdi=SC(Si,ri)
       D EXRP(RPdi)
       I TokR1=ty D MCH(RPdi)
       Q
;*
complete  S RPc=SC(Si,ri) D EXRP(RPc)
       I dot'=$L(ruL,",") Q
       ;
       D b^dv("Log complete ","Si,ri,RPc,dot,ruL")
       Q
;*  TokR1 = ty, Si, ri
MCH(RPsi)    S RPs2=RPsi
       S $P(RPs2,"_",2)=dot+1
       D SSC(Si+1,RPs2)
       D ^dv("Log MCH scan","RPsi,RPs2,Si,ri,sci")
       Q
;*  Expand Item to vars
EXRP(RP)  S runfr=$P(RP,"_",4),ruL=$P(RP,"_",1)
          S dot=$P(RP,"_",2),IPs=$P(RP,"_",3)
          S TokR1=$P(ruL,",")
          D WRP
          Q
;*
WRP    W:$X ! W Si,",",ri,"  ",RP,"  ",ruL," "
       Q
;*  Save in SC
SSC(Si,RPit)
       S $P(RPit,"_",2)=0
       S $P(RPit,"_",3)=0
       S $P(RPit,"_",4)=TokR1_"-"_gi
       F ni=1:1 S RPg=$G(SC(Si,ni)) Q:RPg=""  S Q=(RPg=RPit) Q:Q  
       ; ni at new emoty node of SC       
       I 'Q DO  ;
         .S SC(Si,ni)=RPit
         .W !,"SSC New SC(",Si,",",ni,") = '",RPit,"' "
       I Q W !,"SSC rej Dupl ",Si," ",ni,"  ",RPit,!
       D ^dv("Log save from new Gr","Q,RPit,ni")
       Q
       ;
      
       
     
; GWUSCO
; pointer to IN()  inPointer 
;
