p2s ;CKW/ESC i3mar24 umep./ rppar1/ ;2024-0327-97;SR for ^pp*
;
;
      
;
;*  Sets Q null or err, saves caller from having to do this, sic bug if ;out
;;  label(arg1,arg2) NEW Q I $$arg^cmds("arg1,arg3") Goto Q ;shared exit
;;    Q is set null if args ok, not returned in $$, as 0/1 returned as $$ for branching
;;  Null ok, set null if UNDEF   arg2:null   extend super list colon2 props --- ?
;*  also sets Q null or Err, returns $$ branch 0 ok, 1 Err (ie $$~ Q'="" )
arg(VL)  NEW ARY,FL,vn,vi,D S Q=""  ; Q is NOT NEWed here, but set null or returned
        I $G(VL)="" S Q="Null arg VL" Goto Qa
        S ARY=$P(VL,"_",2),FL=$P(VL,"_")  ; tolerate, not reqd
        S argFL=FL
        F vi=1:1:$L(FL,",") S vn=$P(FL,",",vi) DO  ;
          .S D=$D(@vn)
          .I D>9 Q
          .I D=0 S Q=Q_"$$arg "_vn_" UNDEF," Q
          .I $G(@vn)="" S Q=Q_vn_" Null," Q
          .;further tests ?  def vs null, ARY vs base node undef, null ?
        S argNvi=vi
Qa      S argQ=Q,argRet=(Q'=""),argDolQ=$Q,argVL=VL
        I Q'="" D ^dvstk,b^dv(Q,"Q,argVL")
        Q Q'=""  ; $$ is not Q, but 0/1 if ERR for branching I $$arg
;*
;*  Local modified vers of pze^dv 
pze(M,VL) ;
      NEW X,D,%ZSH S D=$IO
      S VL=$G(VL)
      S M=$G(M)
      zsh "s":%ZSH  S %c=$G(%ZSH("S",2)) I %c="" S %c="caller"      
      W:$X ! W " ^p2s  *** pze ***  by "_%c_"- ",M,!           
      USE $P I $G(devlog)'="" W:$X ! W "devlog:",devlog,!
      I $G(deverr)'="" W:$X ! W "deverr:",deverr,!
      I D'=$P,D'=$G(devlog) W:$X ! W "Current $IO not $P:",D,!
      W:$X ! W !," *** pze^p2s ***   ",M    
      I VL'="" D WVL(VL)
      W " Pause ( . for Dir Mode )  <ret> "
      READ ":",X,!!
      I X["." D ^dvstk,b^dv("dot Break out of pze- ",VL) ; Dir Mode Break
      USE D
      Q
WVL(VL) NEW D,d,vi,vn,val,ln   
   I $G(VL)="" Q
   ;S D=$IO USE $P
   F vi=1:1:$L(VL,",") S vn=$P(VL,",",vi) I vn?.1"%"1A.an DO  ;
     .W:$X ! W " ",vn,": "
     .S d=$D(@vn),val=$G(@vn)
     .I val="" S val="Null."
     .I d#2=0 S val="UNDEF."
     .I d=11 S val="ARRAY+Str "_val
     .I d=10 S val="ARRAY!"
     .S ln=$L(val),vw=50
     .W $E(val,1,vw)
     .I ln>50 W !,?10,"...:",$E(val,vw+1,vw+60) W:ln>vw+60 "+"
     .W !
   ;USE D 
   Q
;*
