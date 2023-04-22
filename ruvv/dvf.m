dvf(RVL)  ;CKW/ESC   i21May16 gmsa/ rvv/ ; 20160620 ; Test modules @*FL
  ;
  ;
  I $G(RVL)="" S RVL=""  ;Super Var
  ;
A  D PVL(RVL)  ; parse to    ;  SmyV,
  Q
  ;  Save  %vars and vars in %vl list into %var  and KILL them
  ;  -- vs Save All    ?Trying to Preserve vars
  ;* * * *
SmyV  I $D(%var) B
  KILL %var I $D(%v)=1 S %var("%v")=%v
  I $D(%vi)=1 S %var("%vi")=%vi
  S %v="%" F %vi=0:1 S %v=$O(@%v) Q:%v'["%"  I $D(@%v)#2 B:$D(@%v)>1  S %var(@%v)=$G(@%) KILL @%v
  S %vl="VVL,dVM,%KMO,VL,x,%c,d,%1,%i2,%VL,%n"
  F %vi=1:1:$L(%vl,",") S %v=$P(%vl,",",%vi) I $D(@%v)#2 B:$D(@%v)>1  S %var(%v)=$G(@%v) KILL @v
  Q
;* * * * *
;
PVL(%vl) I $G(%vl)="" B  Q  ; internal bug, local ref
  S %FL=$P(%vl,"_"),%G=$P(%vl,"_",2)
  I %G'="",%G["(" S %s=$P(%G,"(",2),%s=$P(%s,")") W !,%s,!
  W:$X ! W "*FL","=",%vl,!
  F %vi=1:1:$L(%s,",") S %v=$P(%s,",",%vi) I %v'="" W:$X ! W %v,"=" D WV W !
  F %vi=1:1:$L(%FL,",") S %v=$P(%FL,",",%vi) I %v'="" W:$X ! W "  ",%v,"=" D WV W !
  Q
;*  
;Write @%v - val or Undef or Array   ; Flag WFL variant
WV  I $E(%v)="""" W %v,"  literal. " Q
   I $D(@%v)=0 W "UNDEF." Q
   I $D(@%v)>9 W "[Array]" 
   I $G(@%v)="" W "null" Q
   W @%v
   Q
