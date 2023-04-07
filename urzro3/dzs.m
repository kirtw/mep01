dzs(vzro)  ;CKW/ESC i27aug20  gmsa/ rd2zro/ ;20220804-44; Show (write to $P) $zro / zdir DirMode calls
;
;
;
A     I $G(vzro)="" S vzro=$zro ; default vs input
      D ^dzMdup(vzro)  ; Writes if Dupl MRou in zro
      NEW Q,zro,oi,si,lsi,odir,sdir ; zdir persists now, output
      S zro=vzro
      NEW n,B,rdir,mpj,SB,GB,PB,WB,Bty,kwsys,kwmpj,mpjDir,LUser   ; for s2, not repeatedly
      I $I'=$P USE $P 
      ; D ^guIMG  ; may not have access in $zro, eg mdk
      D IB^dzIMG  ; : SB, GB, PB      
      S Q=$$^dzroz(vzro)  ; vzro/$zro : zdir()
	I Q'="" D b^dv("zro parse Err","Q")
      ;
      I $T(^dzRDMeta)'="" D ^dzRDMeta ; Rdir(rdir)=rde
      F zoi=1:1 S odir=$G(zdir(zoi)) Q:odir=""  DO
        .W:$X ! W zoi," ",odir,!
        .F lsi=1:1 S sdir=$G(zdir(zoi,lsi)) Q:sdir=""  DO
           ..D s2
           ..W:$X ! W "  ",lsi," ",Bty," ",?10,mpj,"/  ",?20,rdir,"/ ",?30
           ..W $G(rdNSL)," ",$G(D2abs),"  "
           ..W:$X>35 !,?30 W $G(Rdir(sdir))
      W !

Q     KILL RXU,Ru,zdir,Rdir     
      Q:$Q Q  Q
;*      
;*  sdir, zoi,lsi : mpj, rdir, Bty, B,   @rdirFL(rdid)
s2    NEW oi,si,id,rdNSL,D2abs 
      S n=$L(sdir,"/"),rdir=$P(sdir,"/",n),mpj=$P(sdir,"/",n-1)
      S B=$P(sdir,"/",1,n-2)_"/",Bty=""
      I B[GB S Bty="GB"
      I B[PB S Bty="PB"
      ;D b^dv("Log Bty","B,SB,GB,PB")
      I rdir'=""  DO  ; maybe get rdNSL, D2abs
        .S id=$G(^ZRx("dab",rdir)),rdNSL=""
        .I id S rdNSL=$G(^ZRD(id,"rdNSL"))   ; may not have access
        .I rdNSL="" D ^dzFdir(sdir) ; : D2abs
        .S rdid=mpj_"-"_rdir
        .I rdid'="" S rdide=$G(^ZQrdir(rdid))  
;^ZQ* gde mapped to gmfd common ZQ-ydb-mumps.dat in gmfd/g/
      ;
      Q
;*
