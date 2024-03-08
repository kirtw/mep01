epaGoInd  ;CKW/ESC  i31oct22 rcfg/ ;20221031-07;Start Earley Parser Menu umep./ zroUcp self-contained Utilities copy
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
    ;  Note also compiles ^epaGoInd itself ???  works
    S zrid="umep"
    S zroUcp=$G(^ZWZ(zrid,"zroUcp"))
;;Config epa choice:
    ;  zroUcp selfcontained umep./  util in ru* rdirs
    I zroUcp="" W !!,"? zroUcp null ? " BREAK  Q
    S $zro=zroUcp   
    ;Now regular start, compile
	D ^dzzl($zro)  ; deletes *.o and recompiles to o/*.o  and ou/*.o  for gmsa, gmma, gmfd, umfd
	;
	S ^ZWZ(zrid,"zroMBR")=$zro  ; Log zrid,zzro for mbr
	S ^ZWZ(0,"zridCur")=zrid
	;
	D ^dzWZuf(zrid)  ; from ^ZWZ(zrid,zroMBR to 0uzro./  file for MBR
	;
    ;D ZST
        ;
        D ^epaMenu  ; Compiles and run 
        Q
;*
;*
ZST    U $P W !!,"^"_$T(+0)_"  $ZL=",$ZL,",  $ZE=",$ZE,",  $ZSTATUS=",$ZSTATUS,",   $ZTRAP=",$ZTRAP,!
       Q
