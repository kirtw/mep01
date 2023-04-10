dzMdup(zro) ;CKW/ESC i2jun20 gmsa/ rd2zro/ ; 20200602-70 ; Find list of MRou in zdir, Test dup MRou
;$$Q  or not        was ^dzMdir  (sic)
;
;falls from top---
A       NEW zdir
        D ^dzroz($G(zro))  ; zro : zdir(oi,si)
        NEW RXU,Ru  ; Arrays, Clean up
        NEW Q
        S Q=$$RXU  ; zdir :  Find Dupl mrou refs in zro/zdir sdir's
        Q:$Q Q
        Q
;*$$Q      alt entry without recalculating zdir from zro
zdir()  NEW Q  S Q=""  NEW RXU,Ru
        S Q=$$RXU  ; zdir : RXU  dup mrou refs
        Q:$Q Q
        Q
;
;
;$$Q  zdir : Writes if Dup MRou or case-clash
RXU()  NEW Q,oi,si S Q=""
      KILL RXU
      F oi=1:1 Q:$D(zdir(oi))=0  F si=1:1 Q:$D(zdir(oi,si))=0   S Q=$$SRU(oi,si)
      S Q=$$Dup  ; : Q
      Q:$Q Q
      Q
;*
;*$$Q zdir(oi,si)   - one dir, Ru()	and cumulative RXU(mr,url)=ii
SRU(oi,si)  KILL Ru  ; not RXU here, it is cumulative
      NEW Q,m,ri,ii,n,mr,MRou,url,durl,ref,fil,x
      S Q=""
      ;
      S durl=$G(zdir(oi,si))  ; sdir
      I durl["gtm" Q ""  ;Skip Utilities, gtm/ or gtmy/
      S x=$ZSEARCH(durl)
      S ref=durl_"/*.m"
      F ri=1:1 S url=$ZSEARCH(ref) Q:url=""  D F1  ;
    Q Q
;* One File url    
F1   S n=$L(url,"/"),fil=$P(url,"/",n)
     S MRou=$P(fil,".m")        
     S ii=oi_"-"_si_"-"_ri_"-"_MRou
     S mr=$ZCONVERT(MRou,"L")  ; vs mr=$$LC^dvc(MRou)
     ;D b^dv("Log MRou ","fil,n,url,MRou,mr")        
     S Ru(mr,url)=ri
     S RXU(mr,url)=ii  ; ? Identical structure... Cumulative across zro
     S m=$G(RXU(mr)) I m="" S RXU(mr)=MRou
     I oi=1 DO:0   Q ; Ignore, no err msg
       .D b^dv("Ignore dup Case when ydb_dist when oi=1 ","oi,ii,m,MRou")
     I m'="",m'=MRou D ^dv("Case clash ?","m,MRou,mr") ;Lists as dup too
     Q

;*$$Q   RXU()  : Q  msg $P/$IO
Dup()   NEW Q,mr,mi,url,url2,i S Q=""
      USE $P W:$X ! W "Checking for Duplications in $zro-",!
      S mr=0
      F mi=0:1 S mr=$O(RXU(mr)) Q:mr=""  S url=$O(RXU(mr,"")) S url2=$O(RXU(mr,url)) I url2'="" DO  ;
        .I url2["gtmy/" Q  ;Skip utilities, both case ways
        .I url2["/usr" Q  ;Skip oi=1 ydb_dist if in /usr/local/lib/yottadb
        .W !,url,!,url2,!!
        .S Q=Q+1
        .S url=url2 F i=0:1 S url=$O(RXU(mr,url)) Q:url=""  W url,!
      I Q="" W:$X ! W "No duplications- No overlapping MRou in different $zro groups.",!
      Q Q
;*


      
