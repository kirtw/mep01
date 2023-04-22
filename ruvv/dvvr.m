dvvr  ;CKW/ESC  i20Jul18 ; 20180720-25 ; Gather var vde from MRou via grep
  ;	in gmsa/  rvv/		dev/kate edit in T2DM
  ;    RefBy: 1) DVV^qdDIS Menu: $doc dvv.      2) Menu: $doc  dvvr.
  ;
  ;  :  %VN(vn,   in {vde,vdty,vref,
  ;  :  $VLF(Lvn,       *FL vars
  ;  grep pipe file-         temp-pipe.txt   in T2DM/ doc
  ;   QSdm  T2DM  Menu $doc  dvvr. 
  ;   Just *IMG.m  in MPrj   r*/  Subdirs
  ;   First space piece after ;; must look like a var-name
  KILL  ; 
grep  S devP=$$devp^dvIdev("temp-pipe.txt")
      S MPrj=$G(Mpr)  I MPrj="" S MPrj="T2DM"
      S Rns="*.m"  ; All MRou for now vs NameSpace
      S ZCmd="cd ~/km7r/"_MPrj_"; grep -n ""^\;\;"" r*/"_Rns_" >"_devP
      USE $P W:$X ! W "Searching (grep) for dbl ;; vne lines in Mpj MRou-",! zwr ZCmd W !
      ZSY ZCmd
      KILL RF D RDF^dvs(devp) I 'RF D b^dv("Failed to read pipe file?","devp") Q
      ;USE $P W:$X ! W "Found ",RF," lines with dbl semcolons-",!
      ;
      D II
      F ri=1:1:RF S T=$G(RF(ri)) I T'="" DO  ; ea line
        .D T1 I vn="" Q
        .I vn?1.A.N.AN D VAR
        .I Vna?1.AN1"FL" D TFL  ; in addition to VAR
        .I vn["^" D CB  ; Label^MRou variants => cb CodeBlock
      USE $P D WriN
      Q
;* Init
II    KILL %VN,%VLF   ; vs merge
      S vnFL="vde,Vna,mrou,vri,vFol,L2,vT,nLn,T1_%VN(vn)" 
      S nVN=0
      Q
WriN  W:$X ! W "^",$T(+0)," Found ",nVN," vars.",!
      Q
;*  grep file Lines
;** rsr/qdIMG.m:22:;;qaFL *FL Main List DM QS log record
;*
;* Parse identifier  Vna or cb...   from grep-output !  MRou line incidentally...
;* includes grep info then MRou line itself to parse, ?TOI - not yet
;*  T : Vna, vn, mrou, 
T1    S T1=$P(T,":"),nLn=$P(T,":",2),L=$P(T,":",3,999),vn="",Vna=""
      I L[$C(9) S L=$TR(L,$C(9)," ")  ; no tabs/ convert to space
      S nSl=$L(T1,"/"),mrou=$P(T1,"/",nSl),vFol=$P(T1,"/",1,nSl-1)
      I mrou'[".m" Q
      I mrou'["IMG",mrou'["img" Q  ;Ignore all but ^*IMG or ^*img
      I mrou["Menu" Q  ; Ignore Menu with conflicting ;; lines
      I vFol'="" S vFol=vFol_"/"
      F nSp=1:1:9 I $E(L)=" " S L=$E(L,2,9999)  ; remove init/post-key spaces, up to 9
      ;  I $E(L,1,2)'=";;" Q  ;Ignore  ';;' later in line
      S v1=$P(L,";;",2),v=$P(v1," "),L2=$P(v1," ",2,9999),vde=L2
      I v="" Q
      I v["." Q
      I v["^" D CB
      S Vna=v,vn=$$LC^dvs(v)
      Q
;*  ;; var name sp -> %VN()
VAR   D T^dws("vnFL=vde,mrou,vri,vFol,L2,vT,nLn,T1_%VN(vn)")
      S vlst=$G(%VN(vn)),L8=$G(%VN(vn,"L2"))
      I vlst'="",vlst'=Vna D b^dv("Vna case clash","vlst,Vna,vn,mrou,nLn")
      I L8'="",L8'=L2 D b^dv("Duplicate entry for vn","vn,mrou,nLn,L2,L8")  ; proceed
      I vlst=Vna KILL %VN(vn)  ; replace
      ;S %VN(vn)=Vna  ; Vna actual case, vn is lc
      S nVN=nVN+1  ; count num vars found
      S vri=ri,vT=T
      D SFL^dvs(vnFL)  ; Save in %VN(vn) Array
        ;F fi=1:1:$L(fL,",") S fn=$P(fL,",",fi),val=$G(@fn) I val'="" S %VN(vn,fn)=@fn
      Q
;*
TFL   S %VLF(vn)=Vna
      S %VLF(vn,"Lde")=$G(vde)
      Q
;*  CodeBlock Ref  ;;label^Mrou  
CB    S cbi=$P(vn,"^",2)_"-"_$P(vn,"^")  ;either may be null
      S cbde=vde
      S %CB(cbi,"cbde")=cbde
      Q
 