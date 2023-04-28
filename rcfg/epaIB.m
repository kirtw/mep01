epaIB  ;CKW/ESC i27apr23 umep./ rcfg/ ;20230427-78;Set umep./ PB, SB, W2B, dist, LUser,...
; not zrid here, nor test/compare...
;
;
top    S kwsys="km3a",LUser="kw"
       S kwmpj="umep",mpjDir=kwmpj_"/"
       S SB="/home/"_LUser_"/"_kwsys_"/"
       S PB=SB_mpjDir
       S GB=SB_"gmsa/"
       S MB=SB_"gmms/"
       S W2B=PB_"ww2mbr/"  ; vs ww2m, ww2
       ;
       S sP=$ZPARSE(W2B)
        I sP="" DO  ;
         .D b^dv("W2B directory undef? ^"_$T(+0),"sP,W2B,SB,PB")
         .; SET W2B=...
       Q
PWD    S PWD=$ZTRNLNM("PWD")
       Q
;*

