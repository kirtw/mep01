aydb  ;CKW/ESC  i31oct22 rcfg/ ;20221031-07;Start ydb mumps
;
; input config:  $PWD must be umep, $zro bash is primary
;
top    	S $ETRAP="B"
    ; Following for relative-to-$PWD refs in mumps.gld to g/ydb-mumps.dat
    S PWD=$ZTRNLNM("PWD")
      I $E(PWD)'="/" D b^dv("Err PWD not abs ???","PWD") Q
    ;  Note also compiles ^epa ???
	D ^dzzl($zro)  ; deletes *.o and recompiles to o/*.o  and ou/*.o  for gmsa, gmma, gmfd, umfd
	    S zrid="umep"
	    S ^ZWZ(zrid,"izro")=$zro  ; Log zrid,zzro for mbr IB^mwIpg
	    S ^ZWZ(zrid,"izgl")=$zgl
	    S ^ZWZ(0,"zridCur")=zrid
	    S ^ZWZ(zrid,"zzro")=$zro
	    D ^dzWZuf(zrid)  ; Writes ^ZWZ(zrid,  to file in zzro for MBR
        D ^epaMenu  ; Compiles to ^MNU(mSys,   mSys="tde"   
          KILL MU,RM  ; Clean up for ^dmnu  vs change in gmsa/rdv/
        D ^dmnu    ; Runs from ^MNU(0,"mSysCur")  and ^MNU(mSys,
        Q
       
       Q
