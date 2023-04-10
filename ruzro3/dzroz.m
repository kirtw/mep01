dzroz(zro) ;CKW/ESC i7sep20 km3a/gmsa/ rzro3/ ; 20200907-78 ; zro/$zro parse to zdir(oi,si)
;
;            adapted from ^dzZROdir  and in ^dvzl, ^dzzl;   rdv/ rzro/ rd2mrou/ rd2zro/
A      I $G(zro)="" S zro=$zro D bug^dv("arg zro def $zro","zro") Q
;$$Q or not
; -- Handle *.so refs, ? contents
; Note odir and sdir here are oi and si elsewhere, where OC here is odir elsewhere
;     Vers 2 of zros sr  zro : PM, zdir(oi,si)        vs odir, sdir
;       zro : zdir()
zrox    KILL zdir   NEW ci,C,oi,si,PM,OC,SC,vi,vn,val,Q S Q=""
        S PM=1,OC="",SC="",oi=0 F ci=1:1:$L(zro) S C=$E(zro,ci) DO  Q:PM>7  ;
          .I PM=1 DO  Q  ; obj file
            ..I C=" " D so  Q  ;leave PM=1
            ..I C="(" D so  S PM=2 Q
            ..I C?1A  D ao Q
            ..I C?1N  I $L(OC) D ao Q
            ..D ao Q
            ..D Err("Char ? "_C) S PM=8
          .I PM=2 DO   ;src file
            ..I C=" " D ss Q  ;leave PM=2
            ..I C=")" D ss S PM=1 Q
            ..I C?1A D as Q
            ..D as Q
            ..I C?1N  I $L(SC) D as Q
            ..D b^dv("Format Err src File","zro,ci,C,oi,si") S PM=8
        I PM>7 S Q="Err zrox Parse" D b^dv(Q,"C,ci,zro,oi,si,PM")
        I PM=2 S Q="Err Parsing Finished inside paren?" D b^dv(Q,"Q,zro,PM")
        I $D(zdir(2))'=11 DO  
          .S Q="kw std expects 2nd obj to have sub-src",PM=11
          .W:$X ! W Q,! I $D(zdir) zwr zdir W !
          .D b^dv(Q,"zdir(2)")
        Q:$Q Q
        Q
;*
;srs  add C, Set zdir(oi) or zdir(oi,si)
ao      S OC=OC_C Q
as      S SC=SC_C Q
so      Q:OC=""  S oi=$G(oi)+1,zdir(oi)=OC,OC="",SC="",si=0 Q
ss      Q:SC=""  I $E(SC,$L(SC))="/" D ETS S SC=$E(SC,1,$L(SC)-1)  ; remove terminal /
        S si=$G(si)+1,zdir(oi,si)=SC,SC=""
        Q
ETS     D Err("There is a terminal / in element oi:"_oi_", si:"_si_"  sdir:"_SC)
        Q
Err(M)  NEW D S D=$IO U $G(devlog) W:$X ! W M,!
        ; S Err(M,...)=M
        U D
        Q
;*
