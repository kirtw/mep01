epa  ;CKW/ESC  i31oct22 rcfg/ ;20221031-07;Start Earley Parser Menu
;
; input config:  $PWD must be umep, $zro bash is primary
;
top    	S $ETRAP="B"
    ; Following for relative-to-$PWD refs in mumps.gld to g/ydb-mumps.dat
    S PWD=$ZTRNLNM("PWD")
      I $E(PWD)'="/" D b^dv("Err PWD not abs ???","PWD") Q
      DO  I Q'="" Q  
        .S Q="",nsl=$L(PWD,"/"),mpj=$P(PWD,"/",nsl)
        .I mpj["umep" Q
        .S Q="Cur Dir must be mpj ('umep') upon start mumps and ^"_$T(+0) 
        .D b^dv(Q,"mpj,PWD")
    ;  Note also compiles ^epa itself ???  works
    S zrid="umep"
    S zroS=^ZWZ(zrid,"zroStart")
      I zroS="" D bug^dv Q
    S $zro=zroS
	D ^dzzl($zro)  ; deletes *.o and recompiles to o/*.o  and ou/*.o  for gmsa, gmma, gmfd, umfd
	;
    S zrid="umep"
	S ^ZWZ(zrid,"izro")=$zro  ; Log zrid,zzro for mbr IB^mwIpg
	S ^ZWZ(0,"zridCur")=zrid
	S ^ZWZ(zrid,"zzro")=$zro
	;
	D ^dzWZuf(zrid)  ; zzro for MBR
	;
        ;D ZST
        D ^epaMenu  ; Compiles and run 
        Q
;*
;*
ZST    U $P W !!,"^"_$T(+0)_"  $ZL=",$ZL,",  $ZE=",$ZE,",  $ZSTATUS=",$ZSTATUS,",   $ZTRAP=",$ZTRAP,!
       Q
