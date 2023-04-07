dvd(FL)   ;CKW/ESC  i2jun17 gmsa/ rmgbFL3/; 20170604-41  ; Display/HGen Data from *FL Lists
  ;  si top entry vs label
  ;
  D dd($G(FL))
  Q
  
  ;  and implied subscripts in FL_2
dd(FL)  ;Work from *FL
    I $G(FL)="" D ^dvstk,b^dv("No FL to display","FL") Q
    I FL?.2U1.L1"FL" W FL,"  " S FL=$G(@FL)  ;Meta ^dvd("LineFL")
    I FL="" W " -- Var*FL is Undef. " Q
    W:$X ! W FL,":- "
    D ds(FL)
    S G=$P(FL,"_",2),VL=$P(FL,"_")
    I G="" D ^dvsch,b^dv(" No second part _ of FL","FL,G") Q
    I $D(@G)=0 W:$X>20 ! W "Node is Undef.",! Q
    F vi=1:1:$L(VL,",") S vn=$P(VL,",",vi) DO
      .S D=$D(@G@(vn)) 
      .I D=0 S val="UNDEF"
      .E  S val=$G(^(vn)) S:val="" val="null"
      .W:$X ! W "  ",vn,": ",val,!
    W:$X !
    Q
;*  Display subs values
ds(FL)  I $G(FL)'["_" Q
    S G=$P(FL,"_",2),P=$P(G,"(",2),P=$P(P,")") I P="" W "  No subscr. " Q
    I $X>60 W !,"  "
    F pi=1:1:$L(P,",") S sn=$P(P,",",pi) DO
      .I sn?1N.1".".N Q  ; ignore lit number, esp 0
      .I $E(sn)="""" W sn,"  " Q
      .I sn'?1A.AN D b^dv("? Subs ","sn,pi,P,FL") Q
      .S val=$G(@sn) S:val="" val="null" S:$D(@sn)#2=0 val="Undef"
      .I $L(val)>20 S val=$E(val,1,20)_"... "
      .W "  ",sn,"=",val,"  "
    Q
;*

    


