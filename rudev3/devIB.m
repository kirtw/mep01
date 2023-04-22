devIB  ;CKW/ESC i8sep20  gmsa/ rdev3/ ;20220820-75; Get Base vars, SB, PB, WB, GB, FB, MB
;$$Q
;
;
;   Special Set of Folder Variables
;  RefBy: many
;$zro : SB,PB,GB,MB,FB,WB, mpj
top     ;
IB      NEW Q,SBe,PBm,PBz,zro,o1,dist,mp,od,n,mpj1,mpj2,PBe,PBz,SBi,SBz,SBe
        S Q=""
        S SBi="/home/kw/km3a/"
        D Bzro($zro)  ; : SB,PB,mpj from $zro   was D Benv,Bz  ;
        S GB=SB_"gmsa/"        
        S MB=SB_"gmma/"
        S FB=SB_"gmfd/"
        S WB=PB_"wwm/"  
        Q:$Q Q  
        I Q'="" D b^dv(Q,"Q,SB,SBi,SBz,SBe,PB,PBz,PBm,mpj1,mpj2,dist,o1,so2,o2")
        Q
;*$$Q  Alt if you want W2B  ie some places in mbr
W2B     D ^devIB
        I $G(W2B)="" DO  ;
          .I $G(zrid)'="" S W2B=$G(^ZWZ(zrid,"W2B"))
          .I $G(W2B)="" S W2B=PB_"ww2m/"
          .D ^dvstk,b^dv("W2B default forced ","W2B,PB,zrid")
        Q:$Q Q Q
;*
; derived from $zro : SB, PB,  (GB, MB, FB)
Bzro(zro)    S zro=$G(zro) I zro="" S zro=$zro
        NEW B,zdir,nsl
        D ^dzroz(zro)  ; Parses more accurately : zdir(oi,si)
        S B=$G(zdir(2)) S:B="" B=$G(zdir(1))
        S nsl=$L(B,"/"),o=$P(B,"/",nsl) I o'="o" D b^dv("IB PB Err","B,zro,nsl,o")
        S PB=$P(B,"/",1,nsl-1)_"/",mpj=$P(B,"/",nsl-1)
        S SB=$P(B,"/",1,nsl-2)_"/"
        ;D b^dv("Log ^devIB ","SB,PB,B")
        Q
        ;
;*
;*  Older vers  derive from zro: SBz, PBz, mpj, PB
Bz      S zro=$$DSP^dvc($zro)
        S dist=$P(zro," "),o1=$P(dist,"(")
        S SBz=$P(o1,"/",1,3)_"/",PBz=$P(o1,"/",1,5)_"/"
        S mpj1=$P(o1,"/",5)
          S PBm=SBe_mpj1_"/"
        S so2=$P(zro," ",2),o2=$P(so2,"(")
        S n=$L(o2,"/")
        S mpj2=$P(o2,"/",n-1)
        I mpj1'=mpj2 S Q="$zro parse err mpj"
        I PBz'=PBm S Q="$zro Parse PBz vs PBm err"
        ;
        S mpj=mpj1
        S PB=PBm
        Q
;*
;*  Derive from Env Vars, ? set by profile.sh  NOT
Benv    S SBe=$ZTRNLNM("SB")_"/"
        S PBe=$ZTRNLNM("PB")_"/"
        Q
;*
;SBe and PBe  from Env  (sic)
;   set here  SB  (not PB)
