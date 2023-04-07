dvFLimg  ;CKW/ESC i8mar20 gmsa/ rmgbFL3/ ; 20200308-95 ; Init Super *FL lists
; AUD(VVL) : $$Q
;
;	was ^dvIMG
;
A   S varFL="vnde,vty_^DDv(vset,vn)"
    S vnIXL="vn,lcvn_^DDx(vset,lcvn)=vn"
    ;  MRou
    S rouFL=""    ; Dupl of ^mrIMG
    Q
;*
;$$Q  Audit list of SuperFL lists for format
AUD(VVL)  I $G(VVL)="" D SVVL  ;Scan vars for *FL	;;
    NEW Q,FL,G2,vj,vi,vn  S Q=""
    F vj=1:1:$L(VVL,",") S FLn=$P(VVL,",",vj) DO
      .I FLn'?1A.31AN S Q2=" List var name "_FLn_"?" D b^dv(Q2,"FLn,FL,VVL") S Q=Q_Q2 Q
      .I FLn'["FL" S Q2="*FL has no FL" D b^dv(Q2,"FLn,vj,VVL") S Q=Q_Q2 Q
      .I $D(@FLn)'=1 S Q2="FLn UNDEF" D b^dv(Q2,"FLn,vj,VVL") S Q=Q_Q2 Q
      .S FL=@FLn,G2=$P(FL,"_",2),FL=$P(FL,"_")
      .  I G2="" D b^dv(Q2,"G2,vj,VVL") S Q=Q_Q2
      .F vi=1:1:$L(FL,",") S vn=$P(FL,",",vi) DO
         ..I vn="" S Q2="Null vn" D b^dv(Q2,"vi,FL,vj,VVL") Q
         ..I vn'?1A.30AN S Q2="vn fmt?" D b^dv(Q2,"vn,vi,FL,FLn") S Q=Q_Q2 Q
         ..S D=$D(@vn)  ; just force full syntax check now
Q   Q:$Q Q
    Q
;*
;*  Find in vars all with name *FL, compose into VVL
; Vars : VVL
SVVL  NEW Q,VAR,vi,vn  S VVL=""
      ZSH "V":VAR
      F vi=1:1 S vs=$G(VAR("V",vi)) Q:vs=""  DO  ;
        .I vs["FL" S vn=$P(vs,"=") I vn["FL",$P(vn,"FL")'="" DO
           ..S VVL=VVL_","_vn
        .S VVL=$E(VVL,2,999) ;remove leading comma
      Q
