TOIpd  ;CKW/ESC i24mar23 rTOI7/ ;20230324-75;Debug Display TOIp results
;
;  See ^TOIpvn
;
;  L~Tin,  wki~i words WD,wd, wd2
;
top   NEW tb,FL,i,vn,v
      USE $P W:$X ! W $G(TOIsyn),!,$G(Tin),!!
      D WW
      Q
;*
WW    D itb S FL="wi,WD(wi),Wdlc(wi),Wpnd(wi),Wty(wi),Wr(wi),Wvn(wi),Wtr(wi)"
      W:$X ! F wi=1:1:$L(FL,","),98,99 S vn=$P(FL,",",wi) W ?tb(wi),vn," " ;Header
      W:$X !
      F wi=1:1:nsp DO  ;
       .F vi=1:1:$L(FL,",") S vn=$P(FL,",",vi) DO  ;
         ..S v=$G(@vn) S:v="" v="X" S:$D(@vn)=0 v="U"
         ..W ?tb(vi),v," "
      .W !
      Q        
;*
itb   KILL tb NEW wl,i 
      S tb=5,wl="5,10,10,10,15,15,8,10"
      F i=1:1:$L(wl,",") S tb(i)=tb,tb=tb+$P(wl,",",i)
      S tb(98)=tb,tb=tb+10
      S tb(99)=tb
      Q
;*      
      
