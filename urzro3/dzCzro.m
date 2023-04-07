dzCzro(PBL,GBL) ;CKW/ESC i5apr23 gmsa./  rzro3/ ;20230405-50;Compose zroLST from rdir lists
;
;   dist $ZTRNLNM
;
top   NEW Q S Q=""
      I $G(PBL)="" D bug^dv G Qb
      I $G(GBL)="" D bug^dv G Qb
      ; Kludge convenience comma list to space list (takes either now)
      I PBL["," S PBL=$TR(PBL,","," ") 
      I GBL["," S GBL=$TR(GBL,","," ")
      D ^dzIB  ; from EnvVars 
      ;D b^dv("Log PB,GB","PB,GB,PBL,GBL")
      S z=dist_" "_PB_"o("
      F di=1:1:$L(PBL," ") S r=$P(PBL," ",di) I r'="" D az(r,PB)
      S z=z_") ou("
      F di=1:1:$L(GBL," ") S r=$P(GBL," ",di) I r'="" D az(r,GB)
      S z=z_") "_dist_"/libyottadb.so "_dist_"/libyottadbutil.so"
      S zro=z
Q     Q:$Q Q Q:Q=""
Qb    D b^duv(Q,"PBL,GBL,zro,z")
      Q:$Q Q Q
;*  Add rdir & path B (or $PB/ ) to z, accumulating zro
az(rdir,B) NEW Q S Q="" ;NEW z,Bn
      S B=$G(B) I B="" S Q="err B~PB,GB az^"_$T(+0) D bug^dv(Q,"B,PB,GB,rdir,z") G Qb
      I rdir["$" DO  ;
         .S Bn=$P($P(rdir,"$",2),"/"),rdir=$P(rdir,"/",2)
         .I Bn?1U1"B" S B=$G(@Bn) I B="" D b^dv("Err $*B ","B,Bn,rdir,z,PB,GB") ;
      ;D b^duv("Log az^"_$T(+0),"B,Bn,rdir,z")
      I $E(B)'="/" S Q="Err B az^"_$T(+0) D b^duv(Q,"rdir,B,z")
      S z=z_B_rdir_" "
      Goto Q

      
