TOIsv ;CKW/ESC i2apr23 gmsa./ rTOI7/ ;20230402-38;End Logic Save per Wvn, Wty, tFL, VNmode
;   was SV^TOIp, svlst
;
;   VNmode ["L" -> @vn, ["A" -> VN(vn), ["G" -> @G@(vn)  MGbl
;   *TFL, tFL vn list only
;   Wr(wki), Wty(wki), Wvn(wki)
;
top   ;
      D SV
      Q
;*
;* VNmode, $O-Wvn(), WDm/WD()  Save Ret Vars
SV   NEW G  ;,Wval,wki,vki,vqi
     ;Wty(wki) -> Xtyw(vnty,wki)=""
     F vi=1:1:$L(tFL,",") S vn=$P(tFL,",",vi) DO  ;
       .I vn="" D bug^dv Q
       .S wki=$G(Xvn(vn))
       .I wki D Swki(wki,vn)
       .D b^dv("Log SV lp1 none Xvn","wki,vn,vi")
     ; wki 1:1:nsp  - only if Wvn, then "dts" etc
     S vlft="",wki=0 F wn=0:1 S wki=$O(Wpnd(wki)) Q:wki=""  DO  ;
       .S wr=$G(Wr(wki)) I wr="" D b^dv("Log Wpnd null Wr","wr,wki,WD(wki)")
       .S:vlft'="" vlft=vlft_", " S vlft=vlft_wr,lfwki=wki
      I wn,vlft'="" S vnlft=$G(Xty("lft")) I vnlft="" D b^dv("Err leftover, no vn-lft","wki,vnlft,vlft,ri")
      I vnlft'="" D Swki(wki,vnlft)
      
     S wki="" F wn=0:1 S wki=$O(Wvn(wki)) Q:wki=""  DO  ;
       .D b^dv("Log SV lp3","wki,vn")
       .D Swki(wki,vn)
     Q
;* VNmode, wki : Wval -> @vv etc
Swki(wki,vn)   S Wr=$G(Wr(wki)) I Wr="" S WD=$G(WD(wki)) D b^dv("Err no Wr","wki,Wr,WD") S Wr=WD
       I $G(vn)="" D bug^dv Q
       I VNmode["L" S @vn=Wval
       I VNmode["A" S VN(vn)=Wval
       I VNmode["G" S G=$P(sTFL,"_",2) I G'="" S @G@(vn)=Wval
       ;D b^dv("Log Save wki","vqi,wki,Wval,vn,VNmode")
       Q

;*
     ; Now set in order, and then rest to the llast var, num nTVN eg cede
;* vqlst, nsp : @vqlst
sqWD I vqlst="" D b^dv("Err last vqlst","tsidT") Q
     S n=$L(vqlst,","),vnlast=$P(vqlst,",",n),vqlist=$P(vqlst,",",1,n-1)
       DO  ;
         .USE $P D WTOIp^TOIw
         .;D b^dv("debug init vqlst","vqlst,vqlist,vnlast")
     I vqlist'="" D vqlist
     I vnlast'="" D vnlast
     USE $P D WTOIp^TOIw  
       ;D b^dv("Pause post Last ","wlki,vn,Wlst,vqlst")
     Q
;*
vqlist  F vni=1:1:($L(vqlist,",")) S vn=$P(vqlist,",",vni) DO  
          .F wki=1:1:nsp I $D(Wpnd(wki)) DO  Q  ;Only one wki per vni/vn, first unused
             ..S Wval=WD(wki)
             ..S Wvn(wki)=vn,Wtr(wki)="vq"_vni
             ..D ^dv("Log sqWD1 ","wki,vn,Wval,vqlist")
        Q
;*
vnlast  S Wlst="",vn=vnlast
       ;USE $P D WTOIp^TOIw  
       ;D b^dv("Pause Mid ","vni,vn,Wlst,vqlst")
       S wki=0 F wn=0:1 S wki=$O(Wpnd(wki)) Q:wki=""  DO  ; The rest of WD's into last vni, eg *de
         .S Wval=WD(wki) S:Wlst'="" Wlst=Wlst_" " S Wlst=Wlst_Wval
         .S Wty(wki)="lastvq"
         .S wlki=wki
         .;D ^dv("Log vnlast ","wki,wlki,vn,Wval,vqlst")
       I Wlst="" D ^deverr("debug No Wlst","Wlst,vnlast,wlki") Q 
          S tv=$G(Wvn(wlki)) I tv'="" D b^dv("debug wlki vn","tv,vn,wlki,wki")
       S Wvn(wlki)=vn,WDm(wlki)=Wlst
       Q
