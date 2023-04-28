dvv(Lvn)   ;CKW/ESC  i7Aug17 ;  2017030-90 ; Var Lists & Vars Util
  ;  in  gmsa/ rdv/        was dev in mtxRube/rdv/ 
  ;RefBy: mHSTA3 ^
  zsh "S":%ZST zsh "*":%ZAL
  S CLR=$$CLR^dvzc($T(+0))  ; : Caller
  D LV(Lvn)
  Q
  ;  %VN(vn,a  in {vde,vTy,val}   %VN()  Produced by ^dvvr
  ;  %VLF(Lvn,a  a in {Lde,LTy,Lva  }
  ;  %VAL         Values, saved or live ? @vn, subscr by cb or timestamp
VLL(VLLn)    I $G(VLLn)="" S VLL="" D bug^dv Q
     NEW VLL,vli,VLn
     S VLL=@VLLn
     W !!,"Lists:",VLLn," - '",VLL,"'",!
     F vli=1:1:$L(VLL,",") S VLn=$P(VLL,",",vli) DO  ;
       .D LV(VLn)
     Q
  ;
;*  Lvn is a List, may be descr or not in %VL
LV(Lvn)  I $G(Lvn)="" D bug^dv Q
     NEW Lva
     S Lva="" I $D(@Lvn) S Lva=@Lvn
     E  S Lva=$G(%VL(Lvn,"Lva"))
     I Lva="" D bug^dv Q
     D WLa(Lva)  ;
     Q
;*  Write to $P
WLa(Lva) I $G(Lva)="" D bug^dv
         S Lde=$G(%VL(Lvn,"Lde"))
     W !,"WLa:",Lvn,": ",Lva,!  I Lde'="" W:$X ! W "  ",Lde,!
     NEW vi,vn,val
     F vi=1:1:$L(Lva,",") S vn=$P(Lva,",",vi) DO  ;
       .S val=$G(@vn) I val="" S val="null" S:$D(@vn)=0 val="Undef"
       .S vde=$G(%VA(vn,"vde"))
       .S L=$L(val)
       .I L<10 DO  Q
          ..W:$X ! W vn,": ",val  W:vde'="" "  /",vde  W !
       .I $L(vde)+L<70 DO  Q
          ..W:$X ! W vn,": '",val W:vde'="" "  /",vde  W !
       .I L>70 D WLL Q
       .DO
          ..W:$X ! W vn,": '",val,"' ",! W:vde'="" "  /",vde,!
     W:$X !
     Q
;* Write long line - wrap/break it
; val, vn, vde
WLL  W:$X ! W vn,"- ",vde,!
     S V=val,L=$L(V) S wd=80 
     F vx=wd-5:-1:wd-15 I " -_?."[$E(V,vx) S V1=$E(V,1,vx),V=$E(V,vx+1,999) W:$X ! W "  ",V1,! Q
     F vj=1:1:5 Q:V=""  F vx=wd-5:-1  I " -_?."[$E(V,vx)!(wd-15=vx) S V1=$E(V,1,vx),V=$E(V,vx+1,999) W:$X ! W " ...",V1,! Q
     I V'="" W "  ...",$L(V)," more!",!
     Q
