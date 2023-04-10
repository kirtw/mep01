dvsys    ;CKW/ESC  i27feb20  gmsa/ rddv3/ ; 20200227-57 ; Sys status, Linux version, os, hw...
  ;  
  ;
  ;
A   S t="temp-sys",ZSY="lsb_release -a>"_t
    OPEN t USE t R X,X2,X3
    CLOSE t
    W !,X,!,X2,!,X3,!
    S ZSY="uname -a>t" ZSY ZSY
        OPEN t USE t R X  ;,X2,X3
    CLOSE t
    W !,X,!  ; ,X2,!,X3,!
    Q



;*************** from dvstk ?
N  NEW:0 %ZSH,%ZS,nSTK,nZL,li,LR,LN
   zsh "S":%ZSH   ; See example below, 2-level array
    ; %ZSH("S",1:1)=   source label ^ MRou
    S nZL=$ZL
    S nSTK=$ZP(%ZSH("S","")) 
    I nZL'=nSTK USE 0 W !,"$ZL=",$ZL," but ZSH has ",nSTK,!
    S eTR=$ETRAP
    S zTR=$ZTRAP
S    F li=nSTK:-1:1 S ls=nSTK-li+1,LR=%ZSH("S",li) DO  ;
      . S R=$P(LR,"^",2),LB=$P(LR,"^")
      . S %ZS(ls,"R")=R,%ZS(ls,"LB")=LB
      .; W:$X ! W li," ",?4,LR
      . I LR["(" S LN="Dir Mode"
      . E  I LR'["^" S LN=LR
      . E  S LN=$T(@LR)
      . S %ZS(ls,"LN")=LN
      .; W !,?6,LN,!
    S ZC=nSTK-1 S Caller="?"
    I ZC S Caller=$G(%ZSH("S",ZC))_": "_$G(%ZSH("L",ZC))
    D WS
    Q
WS   W:$X ! W "Caller:",Caller,"   Stack-",!
     F si=1:1:nSTK DO
       .W:$X ! W si," ",?5,%ZS(si,"R")," ",%ZS(si,"LB"),"  ",?25,%ZS(si,"LN"),!
     W "  $ETRAP='",eTR,"' ",!
     W "  $ZTRAP='",zTR,"' ",!
     W "  $ZL=",nZL,!
     W !
     Q


