TOIparse(Tii)  ;CKW/ESC  i2oct19 ; 20191003-01 ; Temp/Alt  ^TOIp Parse One Line
  ; in gmsa/  rTOI7/  really this is new TOIp/test  -> Stick with ^TOIp (rename entry)
  ;  TOIp is primary 30mar23
;
I   BREAK  KILL WD,Wd,Wdu,Wvn,Wty
    I $G(toiFL)="" D ^TOIimg
    D GFL^dvs(toiFL)  ; VNmode, ...
    S Wbp=";^",Ppx="/@!*#$%.~\|",Psx=".\|!#%&*_-"  ; Allowed Punct sx & px
    ;
    S T2=$TR(Tii,Wbp,"        "),T3=$$DSP^dvs(T2)
    F wi=1:1:$L(T3," ") DO  ;
      .S WD=$P(T3," ",wi),px="",sx="",ty=""
      .S Wu(wi)=0
      .S C=$E(WD) I C?1P,Ppx[C S px=$E(WD),WD=$E(WD,2,999) D PXW
      .S C=$E(WD,$L(WD)) I C?1P,Psx[C S sx=C,WD=$E(WD,1,$L(WD)-1) D SXW
      .S WD(wi)=WD
      .S Wd(wi)=$$LC^dvs(WD)
    I VNmode["dt" D ^TOId
    I VNmode["PAT" D ^TOIpat
    ; Now line up wds and vn in order til last takes everything else
    ;Thru each wi, bump vi/vn when not used yet, Wu-null or 0
    S vi=1,vn=$P(vnL,",",vi),Qvi=0 
    F wi=1:1:nwi I 'Wu(wi) DO  Q:Qvi  ;vi done or last wi
      .S Wvn(wi)=vn,Wu(wi)=1,Wty(wi)="txt",Wvn=vn
      .I $L(vnL,",")>vi S vi=vi+1,vn=$P(vnL,",",vi) Q
      .DO  ;
         ..S Wty(wi)="last",Qvi=1
         ..S WD=WD(wi)
         ..F wi2=wi+1:1:nwi S WD=WD_" "_WD(wi2),Wu(wi2)=1,Wty(wi2)="la+"
         ..S WD(wi)=WD,Wd(wi)=$$LC^dvs(WD)
         ..S Wvn(wi)=vn
    ;
    Q
;* px, WD, wi
PXW  S v=$G(TG("PXvn",px)) I v="" Q  ;not regis pox
     S Wvn(wi)=v,Wty(wi)="px"_px,Wu(wi)=1
     Q
;*
SXW  S v=$G(TG("SXvn",sx)) I v="" Q ; Not regis sx
     S Wvn(wi)=v,Wty(wi)="sx"_sx,Wu(wi)=1
     Q
;*
