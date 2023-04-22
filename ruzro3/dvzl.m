dvzl(zro)   ;CKW/ESC   i1sep16 gmsa/ rdv/ ; 20171121  1020pm   ; Zlink Utility
  ;;     Update  (prior ^dvzl2 in emergency bug) from mtxRube/  gv1/  rdv/  
  ;    --> gmma/  rd2zro/ ^dzzl  is Clean 16sep20
  ;
  ;   prototype tested in mHSTA ^t
  ;   early prod moved to gmsa/rdv/    used by ?KA1
  ;   rev to debug in mtxRube/ gv1/ rdv/ ref by ^r    new sr zrox
  ;
  ;
z5    NEW sdir,odir,zBase,zsl,zsd,mpr,mpf,zl,zd,di8,ZC,ZRM
      I $G(zro)="" S zro=$zro
      D zrox(zro)  ; zdir(oi,si)
      D delo5
      D zl5
      D pz
Qz5   KILL:1 zdir,odir,sdir,zro
      Q
;*
;*  Vers 2 of zros sr  $zro : PM, zdir(oi,si)  odir, sdir
zrox(zro)    KILL zdir   NEW:1 ci,C,odir,sdir,PM,OC,SC,vi,vn,val
        S PM=1,OC="",SC="" F ci=1:1:$L(zro) S C=$E(zro,ci) DO  Q:PM>7  ;
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
            ..D b^dv("Format Err src File","zro,ci,C,odir,sdir") S PM=8
        I PM>7 D b^dv("Err zrsx Parse","C,ci,zro,odir,sdir,PM")
        I PM=2 D b^dv("Erro Parsing Finished inside paren?","zro,PM")
        I $D(zdir(2))'=11 zwr zdir D b^dv("kw std expects 2nd obj to have sub-src","zdir(2)") S PM=11
        Q
;srs  add C, Set zdir(odir) or zdir(odir,sdir)
ao      S OC=OC_C Q
as      S SC=SC_C Q
so      Q:OC=""  S odir=$G(odir)+1,zdir(odir)=OC,OC="",SC="" W odir,"  ",zdir(odir)  Q
ss      Q:SC=""  S sdir=$G(sdir)+1,zdir(odir,sdir)=SC,SC=""  Q
Err(M)  NEW D S D=$IO U $G(devlog) W:$X ! W M,!
        ; S Err(M,...)=M
        U D
        Q
;*
;* vers for zdir(oi,si)
delo5   ;I $G(odir)="" D b^dv("No odir","odir,oi") Q
        NEW:1 oi,ZRM
        F oi=1:1 Q:$D(zdir(oi))=0  S odir=$G(zdir(oi)) DO
          .I odir["ou" Q  ;Save $GB util *.o files for execution in git clone
          .I $D(zdir(oi))<10  Q  ; No source files
          .I odir["gtm"  Q  ; Do not delete in /gtm Dir
          .S ZRM="rm -v "_odir_"/*.o"
          .ZSY ZRM
          .I $ZSY
        Q
  ;
;* 5th Variant after zrox : zdir(odir,sdir)=FileRef, odir #
zl5     U $P W !,"Performing zl5 on-  ^",$T(+0),!
        NEW:1 oi,od,sn,si
        F oi=1:1 S od=$D(zdir(oi)) Q:od=0
        F oi=oi-1:-1:1 S od=$D(zdir(oi)) I od=11  DO  ;
          .S odir=zdir(oi)
          .S sn="" F si=0:1 S sn=$O(zdir(oi,sn),-1) Q:sn=""  DO  ;
            ..S sdir=zdir(oi,sn)
            ..D zls5(odir,sdir)
        Q
;*  new variant of zls
zls5(odir,sdir,stem)  I $G(stem)="" S stem="*"
        S ZC="cd "_odir_";  $gtm_dist/mumps "_sdir_"/"_stem_".m"
        W:$X ! W "ZC:",ZC,!
        ZSY ZC
          I $ZSY W:$X ! W "  Empty Folders are ok in $zro",!
        Q
;*
;*  Pauze to see results of compile-
pz	W:$X ! W "Finished zl List in zl^",$T(+0),!!
        NEW X
	W "Pause after zl.",! R X I X="." W "...Quitting." Q
	Q
