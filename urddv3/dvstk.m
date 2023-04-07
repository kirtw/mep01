dvstk    ;CKW/ESC  i12may16 gmsa/ rddv3/ ; 20220515 ; Caller Util stack -noIO
  ;
  ;
N  NEW:1 %ZSH,%ZS,nSTK,nZL,li,LR,LN,R,si,ls,eTR,zTR,ZC,LB
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
  ;* code from - only does zsch b  redirects if not $P to $P
    ;*  zsh  & Break (Use 0)
;   GTM>zwr %ZSH
;  %ZSH("S",1)="GFL+6^kas"
;  %ZSH("S",2)="    ($ZTRAP)"
;  %ZSH("S",3)="    (Direct mode) "
;  %ZSH("S",4)="GFL+5^kas"
;  %ZSH("S",5)="AAA+1^kaITRxdc"
;  %ZSH("S",6)="kaITRxdc+4^kaITRxdc"
;  %ZSH("S",7)="kaITRprs+5^kaITRprs"
;  %ZSH("S",8)="L1^kaITRgo"
;  %ZSH("S",9)="A+9^kaITRgo"
;  %ZSH("S",10)="AList+15^kaITRgo"
;  %ZSH("S",11)="AList+9^kaITRgo"
;  %ZSH("S",12)="Ph3^kaMenu"
;  %ZSH("S",13)="33^a2"
;  %ZSH("S",14)="A^a2"
;  %ZSH("S",15)="+1^GTM$DMOD    (Direct mode) "
;

