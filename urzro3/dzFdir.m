dzFdir(sdir)  ;CKW/ESC i27aug20 gmsa/ rd2zro/ ; 20200827-75 ; Look at Files in one sdir (rdir/?)
;
;  : D2abs, rdNSL  Short Abstract  1st file, (x n files *.m)
;
;* RefBy: s2+8^dzs
A     I $G(sdir)="" D bug^dv Q
      NEW Q,url,zsurl,x,fi,furl,n,fil,nf  S Q=""
      S url=$ZPARSE(sdir)
        I url="" D b^dv("Arg sdir failed ZPARSE","sdir") Q
        I $E(url,$L(url))="/" S url=$E(url,$L(url)-1)  ;remove terminal /
      S zsurl=url_"/*.m"
      D IB^dzIMG  ; SB, GB, PB
      S x=$ZSEARCH(PB),D2abs=""
      F fi=0:1 S furl=$ZSEARCH(zsurl) Q:furl=""  DO  ;
        .S n=$L(furl,"/"),fil=$P(furl,"/",n)
        .I fi=0 S D2abs=fil
      I fi S nf="(x "_fi_") " S D2abs=D2abs_nf
      Q:$Q Q  
      Q
;*      
