ppGo  ;CKW/ESC  i31oct22 umep./ rcfg/ ;2024-0302-57;@mpp Start mumps table m parser ^pp* rppar1/
;
; input config:  $PWD must be umep, $zro bash is primary
;
top    	S $ETRAP="B"
    DO  ;
      .I $zro'["umep/rcfg" D b^dv("Need $zro access to Starter ","zrid")
    I 000 DO  I Q'="" Q  
        .S Q="",nsl=$L(PWD,"/"),mpj=$P(PWD,"/",nsl)
        .I mpj["umep" Q
        .S Q="Cur Dir must be mpj ('umep') upon start mumps and ^"_$T(+0) 
        .D b^dv(Q,"mpj,PWD")
    ;  Note also compiles ^parGo itself ???  works
    S zrid="umep"
    D p2IBzro^mepIO S $zro=zro  ;zro ^p2*
    ;Now regular start, compile
	D ^dzzl($zro)  ; deletes *.o and recompiles to o/*.o  and ou/*.o  for gmsa, gmma, gmfd, umfd
	;
	;S ^ZWZ(zrid,"zroMBR")=$zro  ; Log zrid,zzro for mbr
	;S ^ZWZ(0,"zridCur")=zrid
	;
        ;
    D ^p2Menu  ; Compiles menu ^MNU(mSys and MU() and runs ^dmnu
        Q  ; doesnt normally return, usu halt
;*
;*
ZST    U $P W !!,"^"_$T(+0)_"  $ZL=",$ZL,",  $ZE=",$ZE,",  $ZSTATUS=",$ZSTATUS,",   $ZTRAP=",$ZTRAP,!
       Q
