dzfl   ;CKW/ESC i25sep20 gmsa/ rd2zro/  ; 20200925-95 ; Quick First lines, ala dzs, dir mode
;
;         ****   BREAK   ****  Too Complicated, Too dependent, Bad Idea
;
A     S zro=$zro
      D ^dzroz(zro)
      KILL rDIR S rDIR=0
      F oi=2:1 Q:$D(zdir(oi))=0  F si=1:1  Q:$D(zdir(oi,si))=0  DO  ;
        .S rDIR=rDIR+1,rDIR(rDIR)=zdir(oi,si)
        .W:$X ! W rDIR," ",?5,rDIR(rDIR),!
      R !,"which rdir(s):",X
        I X="." Q
      I X[" " S X=$TR(X," ",",")
      F xi=1:1:$L(X,",") S xn=$P(X,",") I xn'="" D WXn(xn)
      Q
;*
WXn(xn)  I $G(xn)="" Q
      S r=$G(rDIR(+xn)) I r="" W " ? '",xn,"' " Q
      D WFL(r)
      Q
;*
WFL(durl)  NEW Q S Q=""
      I $G(durl)="" D b^dv("Bug arg","durl") Q
      S n=$L(durl,"/"),ns=$P(durl,"/",n) I ns="" S ns="*.m"
      E  S $P(durl,"/",n)=""  ; remove any ns to ns
      I $E(durl,$L(durl))'="/" S durl=durl_"/" D b^dv("Add / on durl end","durl")
      S olf=$ZSEARCH(durl_"aa-*.olf")
      I olf="" S olf="",ns="*.m"
      D ^mbsAF(olf)  ; : qF(sq)  via olf
      ;
      F sq=1:1:qF S furl=qF(sq) DO
        .S Q=$$^devRD(furl,,"RM") I Q'="" Goto Q
        .S Q=$$durl(furl) ; : 
        .S L1=RM(1),mFL=$P(L1,";",4)
        .D WF1
Q     Q:$Q Q
      Q
;*$$Q  : Fil, ns, Fol, mpj, Base
durl(url) NEW Q,m,n S Q=""  I $G(url)="" S Q="Arg durl^dzfl" D b^dv(Q,"Q,url") Q Q
      S n=$L(url,"/"),ns=$P(url,"/",n),Fil=""
      I ns="" S ns="*.m"
      E  I ns'["*" S Fil=ns,ns=""
      S m=$L(Fil,"."),ext=$P(Fil,".",m)
      S Fnm=$P(Fil,".")  ; first only even if m>2
      S mpj=$P(url,"/",n-2)
      S Base=$P(url,"/",1,n-2)  ; includes mpj
      Q Q
;*
WF1   ;
      USE $P W:$X ! W $G(Fnm),"  ",?15,$G(mFL),!
      Q
;*

      S Fol=$P(url,"/",n-1)

      
      