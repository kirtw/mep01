dvn(VNL)  ;CKW/ESC i13dec22 gmsa./ rddv3/ ;20221213-52;Alt ^dv write line, @vn substitutions
;
;
;  @vn ? and space following or any punct?
;
;  VNL
top   I $G(VNL)="" D bug^dv Q
      S P=VNL S vi=1 KILL VP
      F vi=1:2  S VP(vi)=$P(P,"@"),P2=$P(P,"@",2,99) Q:P'["@"  DO  ;
        .F i=1:1 I $E(P2,i)'?1.AN  S vn=$E(P2,1,i-1),P=$E(P2,i,999) Q
        .S VP(vi+1)=vn
      ;zwr VP
      W:$X ! F vi=1:2  W VP(vi) Q:'$D(VP(vi+1))  DO  ;
        .S vn=VP(vi+1),val=$G(@vn),D=$D(@vn)
        .I '(D#2) S val=" "_vn_" is UNDEF."
        .I D#2,val="" S val="NULL."
        .W val
      W !
      Q
;*
T     KILL  S V="This is it:@v1, but it goes on @v2 til here."
      S v1="ABC",v2="xyz" D ^dvn(V)
      KILL v1 D ^dvn(V)
      S v2="" D ^dvn(V)
      Q
;*
