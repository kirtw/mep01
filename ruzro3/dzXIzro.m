dzXIzro ;CKW/ESC i11nov22 gmsa./ rzro3/ ;20221111-03;Find all rdir,in PB,GB,MB index BB
;? not debugged     zl. in madMenu
;
;  ; : RDx(rdir)=BB
;
top    NEW x,durl,murl,rdsch,di,nsl,B0,BB  
       D III
       W !!,"RDx  rdir to *B -",!
       zwr RDx
       Q
;*
III    KILL RDx
       D devIB  ; $PWD : SB, PB, GB, MB  local sr !
       D XR(PB),XR(GB),XR(MB)
       Q
;*  Find rdir in BB
XR(BB)  ;
       S durl=$ZPARSE(BB)
         I durl="" D b^dv("Err durl/BB","BB") Q
       S x=$ZSEARCH("^X")  ;clear ptr
       S rdsch=BB_"r*/"
       F di=0:1 S durl=$ZSEARCH(rdsch) Q:durl=""  DO  ;
         .S nsl=$L(durl,"/"),rdir=$P(durl,"/",nsl)
         .I rdir="" D b^dv("Err rdir from durl","rdir,durl,BB") Q
         .S B0=$G(RDx(rdir)) I B0'="",rdir'="r" D b^dv("rdir dupl in other base?","rdir,B0,BB")
         .S RDx(rdir)=BB  ; last overrides
       Q
;*   $PWB~PB SB, GB, MB, MBR
devIB  S PB=$ZTRNLNM("PWD")_"/"
       S SB=$P(PB,"/",1,4)_"/"
       S GB=SB_"gmsa/"
       S MB=SB_"gmma/"
       S MBR=SB_"umbr/"
       Q
