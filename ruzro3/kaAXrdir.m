kaAXrdir ;CKW/ESC i5feb23  fka3i./ rcfg/ ;20230205-38; rdir Dependency List vs MBR ?
;
;
;
top      NEW Q S Q="" 
         D tzro
         Q
;*         

xref     ;
;;$GB rmgbFL3/   ^dgmg  and ^kfm  *IMG Field Lists   SFL/GFL
;;$GB rdd2/      Dates  ^   
;;$GB 
;*   Writes if rdir not in $zro
tzro  NEW Q S Q="" 
      S szro=$P($zro,"o(",2)  ; skip ydb_dist to good stuff
        I szro="" S Q="Err szro subset of $zro" D b^dv(Q,"szro") Q
      F I=1:1 S T=$T(xref+I) Q:T'[";;"  DO  ;
        .S L=$P(T,";;",2,9)
        .I $E(L)="#" Q  ;full line comment ?
        .S L2=$$DSP^dvc(L)
        .S mpj=$P(L2," ")
        .S rdir=$P(L2," ",2)
        .S rdX="" I $E(rdir,$L(rdir))?1n S rdX=$E(rdir,1,$L(rdir)-1) ;strip term digit
        .S rde=$P(L2," ",3,99)
        .;  test $zro
        .I szro[("/"_rdir_" ") Q
        .S Q=" rdir ("_rdir_") not in $zro."
        .USE $P W:$X ! W Q
        .I szro[("/"_rdX_" ") DO  ;
           ..S n=$F(szro,rdX)-$L(rdX)-1
           ..S r=$E(szro,n,n+$L(rdX)+1)
           ..W !," but, Another version may be: ",r,!
      I Q'="" D ^dzs W !!
      Q
;*
