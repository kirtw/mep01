TOIpat  ;CKW/ESC i30mar23 gmsa./ rtoi7/ ;20230330-86;Parse Special patterns, email, url, ...
;
;
;   Paralel part of ^TOIp
;   Wpnd(wki) -> wki
top   S dQ=""
    S wki=0 F wn=0:1  S wki=$O(Wpnd(wki)) Q:wki=""  DO  ;
      .S wd=Wdlc(wki),dQ=""
      .I wd["@" S Q=$$tema I dQ D S9^TOIp("ema",ema) Q
      .I wd["/" S Q=$$turl I dQ D S9^TOIp("url",url) Q
      .I wd["-" S cd=$$ttel(wd) I dQ D S9^TOIp("tel",cd) Q
      .S xcd=$$tncd(wd) I dQ D S9^TOIp("amt,un",xcd) Q
    Q
;*  obs code, replace
;*   wki, WD, wd : toity,    
PAT  I WD?1.n S toity="int,num,dol" D EWD Q
     ;  I forgot what this was used for ??:  food units ?
     I WD?1.n1.A.n I $$tncd(wd) S toity="Icd" D EWD Q  ;start with n?
     I WD["@" I $$tema(WD) S toity="email" D EWD Q
     I WD["(" I $$ttel(WD) S toity="tel" D EWD Q
       ;D ER("Did not recog syntax of WD","WD,px,sx")
     S toity="txt",Wty(wki)="txt" Q  ; not used uet -> vqlst
     Q
;*
;*$$  $$ null if NOT found!? - tncd -- for T2DM complexity ???
tncd(w) S I=+w,cd="" F i=1:1:$L(w) I $E(w,i)?1A S cd=$E(w,i,999) Q  ;skip past initial digits
     S xu=$G(^TG(0,"XUw",cd)) I xu'="" S V2=cd,srvgm=xu,U2=cd Q 1
     S xu=$G(^TG(0,"XUv",cd)) I xu'="" S V2=cd,srvml=xu,U2=cd Q 2
     S xcd=$G(^TG(0,"MO",cd)) I xcd S vn="mn",WD(wki)=xcd,WDt(wki)="mn" D EWD Q 3
     S xcd=$G(^TG(0,"DWL",cd)) I xcd S vn="dwj",WD(wki)=xcd,WDt(wki)="dwk" D EWD Q 4
     S xcd=$G(^TG(0,"UVN",cd)) I xcd'="" S vn=xcd D EWD Q 5
     Q ""
;* trigger ["@"  email type <Kirt Walker> "kw@gmail.com"
tema(W)  I $G(W)="" D bug^dv Q "?"
     S e=W,hna="" I W["<" S e=$P(W,"<",2),e=$P(e,">"),hna=$P(W,"<")
     S dom=$P(e,"@",2),na=$P(e,"@")
     I dom'["." S Q="2 ?domain" Q Q
     I na="" S Q="# na in email" Q Q
     S ema=e,toity="email" D EWD
     Q ""
;*  ["/"  ? url
turl(w)  ;
     S uty="" S LUser="kw",kwSys="km3a",kwMpj="KAC",kwPdir="fin3"
     I $G(w)="" D bug^dv Q
     S url=w
     S nsl=$L(w,"/"),ndt=$L(w,".")
     S C=$E(w) S:C="/" uty="F" S:C="~" uty="rHm",url="/home/"_LUser_"/"_w
     I C="." S uty="rU"
     ; : uty, url
     Q
     
;*
ttel(W)  I $G(W)="" D bug^dv Q "?"
     S Tn=$TR(W,"()- ","") I Tn?10n S tel=Tn,toity="tel" D EWD Q ""
       I Tn?7N S Tn=713_Tn,tel=Tn,Q="",toity="tel" D EWD Q ""
     Q Q
;*  toity, vn, @vn, dQ
EWD  B  ;S9?
     Q
