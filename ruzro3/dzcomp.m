dzcomp(zro)  ;CKW/ESC i7sep20 gmsa/ rd2zro/ ; 20200907-80 ; Compile mFil *.m via Lcmd mumps ^mFil
;
;$$Q  or not   sr zl5  from ^dvzl
A       D ^dzroz($G(zro))  ; zro : zdir(oi,si)
        NEW Q
        S Q=$$zl5  ; zdir :  compile mumps *.m for sdir's
        Q:$Q Q
        Q
;*$$Q      alt entry without recalculating zdir from zro
zdir()  NEW Q  S Q=""
        S Q=$$zl5
        Q:$Q Q
        Q
;
; 5th Variant after zrox : zdir(oi,si)=FileRef, odir #
zl5()   ;U $P W !,"Performing zl5 on-  ^",$T(+0),!
        NEW:1 oi,od,sn,si,Q S Q=""
        F oi=1:1 S od=$D(zdir(oi)) Q:od=0  ; Find last oi, work backwards
        F oi=oi-1:-1:2 S od=$D(zdir(oi)) I od=11  DO  ;
          .S odir=zdir(oi)
          .I odir["mumps"!(odir["ydb") D b^dv("Err compiling sdir/odir ","oi,odir,si,sdir") Q
          .S sn="" F si=0:1 S sn=$O(zdir(oi,sn),-1) Q:sn=""  DO  ;
            ..S sdir=zdir(oi,sn)
            ..D zls5(odir,sdir)
        Q:$Q Q
        Q
;*  new variant of zls
zls5(odir,sdir,stem)  I $G(stem)="" S stem="*"
        ;D b^dv("Log sls5^dzcomp","sdir,odir")
        I sdir["yotta"!(sdir["ydb")  D b^dv("Err trying to compile sdir","osi,sdir,oi,odir") Q  ; not ydb_dist
        S ZC="cd "_odir_";  $ydb_dist/yottadb "_sdir_"/"_stem_".m"
        I sdir["gtm" DO  Q  ; not gtm or gtmy
           .;D ^dv("Log skip gtm/gtmy","odir,sdir,ZC")
        I sdir'["km" DO  Q
          .D ^dv("Skip- Expect to compile only km*/ folders","sdir,odir,ZC")           
        W:$X ! W "ZC:",ZC,!
        ZSY ZC
          I $ZSY W:$X ! W "  Empty Folders are ok in $zro",!
        Q
