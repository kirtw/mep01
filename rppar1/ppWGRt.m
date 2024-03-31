ppWGRt ;CKW/ESC i13mar24 umep./ rppar1/ ;2024-0313-98;Write GRt Terminal Tokens Grammar
;
;  GRt(tokt,          GXtsq(trq)=tokt
;  tokt is either ?1P (not space)  or name ending in dot {sp1. wd. Swd. ... }
;
;*  GRt(tokt,)=  Terminal tokens, ?1P, or dot in name, 
;*    GXtsq(tsq)=tokt  logical sequence (as created from RG()  //tokt section
tokgrFL ;;tokgFL:ttde,ttri_GRt(tokt)
WGT    NEW tsq,tokt,ttde,ttri
       F tsq=1:1:GXtsq S tokt=$G(GXtsq(tsq))  DO  ;
         .I tokt="" D b^dv("Err no tokt value for tsq","tokt,tsq")
         .D GFL^kfm(tokgrFL) ; GRt(tokt,   ttde, ttri
         .W:$X ! W "tokt:",tokt,"   ",?15,"ln:",$G(ttri),"  ",?25,$G(ttde),!
       W !,"Completed Terminal Toke Gram Table GRt()   - ",$G(tsq)," elements.",!
       Q
