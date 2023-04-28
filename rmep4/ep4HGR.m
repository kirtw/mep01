ep4HGR ;CKW/ESC i27apr23 umep./ rmePT1/ ;20230427-78;HGen Grammar Page GRk(), 
;
;
HG    S Fil="Gram-Demo.2.html"
      D ^epaIB ; : PB, SB, W2B, dist, kwsys, mpjDir
      S devh=PB_"dmep/"_Fil
      D Init^hgh    S hghEOL=1
      S TIft=" by ^"_$T(+0)
      D Hcss
      ;
      D HGS^hgh
      D guts
      D HGE^hgh
      ;
      D WH^hgh(devh)
      Q
;;GRFL:runa,ruab,ruty,ruLst,nLst,tokCL,nLCL,Lna,rde_GRk(ruid)
;*  GRk(ruid,vn   vn in {ruLst,runa,rude     @grFL
;*  ruid is integer
;*  GRk(ruid), Gxi(runa,gi)=ruid
guts  ;
      D ot^hgh("table")
      F ruid=1:1 Q:$D(GRk(ruid))=0  D ru1  
      D ct^hgh("table")
      Q
;*
ru1   S Q=$$GFL^kfm(grFL) ; ruid, GR(ruid @grFL
      I rugi=1 ;bookmark #runa
      D ot^hgh("tr")  
      S ncL="ruid,runa,ruab,ruLst,rude"
      F xi=1:1:$L(ncL,",") S vn=$P(ncL,",",xi) DO  ;
         .S T=$G(@vn) S:T="" T=" "
         .I vn="ruLst" D ruLst(T) Q         
         .D rutd(T)
      D ct^hgh("tr") 
      Q
;*
rutd(T)  ;
      D ota^hgh("td",".tcell")      
      F ti=1:1:$L(T,",") S tok=$P(T,",",ti) I tok'="" DO  ;
        .I ti'=1 D sv^hgh(", ")
        .S href="#"_tok
        .D LINK^hgh(tok,href)
      D ct^hgh  ;td .tcell ?atpar
      Q
;*
ruLst(T)  ;
      D ota^hgh("td",".tcell")      
      D sv^hgh(T)
      D ct^hgh  ;td .tcell ?atpar
      Q
;*
Hcss  I $G(TIft)="" S TIft=" by ^"_$T(+0)
      Q
;*
