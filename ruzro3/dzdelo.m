dzdelo(zro)  ;CKW/ESC  i27aug19 umep./ ru*/ ; 20200907-98 ;Delete *.o FIles from */o/*.o
  ;
;$$Q  or not   sr zl5  from ^dvzl
A       I $G(zro)="" S Q="Arg ^"_$T(+0) D bug^dv(Q,"Q,zro") Q
        D ^dzroz(zro)  ; zro : zdir(oi,si)
        NEW Q
        S Q=$$delo5  ; zdir :  compile mumps *.m for sdir's
        Q:$Q Q
        Q
;*$$Q      alt entry without recalculating zdir from zro
zdir()  NEW Q  S Q=""
        I $D(zdir)'=10 D bug^dv("Arg array zdir(oi,si)... missing","zdir") Q
        S Q=$$delo5  ; zdir :  compile mumps *.m for sdir's
        Q:$Q Q
        Q        
         ;
         ;  falls into vers for zdir(oi,si)
delo5()  ;I $G(odir)="" D b^dv("No odir","odir,oi") Q
        NEW oi,odir,ZRM,Q S Q=""
        F oi=1:1 Q:$D(zdir(oi))=0  DO  ;
          .S odir=$G(zdir(oi)) I odir="" Q
          .I $D(zdir(oi))<10  Q  ; No source files
          .I odir["gtm"  Q  ; Do not delete in /gtm Dir        ;sic  THIN Safety !!
          .I odir["yottadb"!(odir["ydb")  D:oi'=1 b^dv("Err ydb in odir, not oi=1","odir,oi")  Q  ; ditto ydb_dist
          .I odir["ou/"  Q  ; Do not delete ou/  $GB utility *.o files
          .I oi=1 DO  Q
              ..D b^dv("Normally for kw TP7 oi=1 is gtmdist ???","oi,odir,zdir")
          .D dodir
	Q Q
;*    sr  Executes/zsy ZRM to rm odir/ *.o
;   oi, odir, zdir()
dodir     I $D(zdir(oi))<10  Q  ; No source files
          I odir["gtm"  Q  ; Do not delete in /gtm Dir        ;sic  THIN Safety !!
          I odir["yotta"!(odir["ydb") D b^dv("Bug trying to del ydb_dist *.o","odir")  Q  ; Do not delete in /yottadbs Dir        ;sic  THIN Safety !!          
          I odir["/ou/"  Q  ; ou/*.o are retained $GB utility for git
          I oi=1 D b^dv("Normally for $zro in kw/km5b/<mpj>/ oi=1 is ydb_dist ???","oi,odir,zdir") Q
          S ZRM="rm -v "_odir_"/*.o"
          ZSY ZRM
          I $ZSY S zsy=$ZSY D bug^dv("Error in ZSY  del *.o ?","zsy,ZRM,oi,odir,zro,zdir")
        Q
