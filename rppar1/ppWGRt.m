ppWGRt ;CKW/ESC i13mar24 umep./ rppar1/ ;2024-0313-98;Write GRt Token Grammar
;
;  GRt(tokt)=            GXtrq(trq)=tokt
;  tokt is either ?1P (not space)  or name ending in dot {sp1. wd. Swd. ... }
;
;*  GRt(tokt)=  Terminal tokens, ?1P, or dot in name, GXtq(tsq)=tokt
WGT    ;
       F tsq=1:1:GXtq DO  ;
         .S tokt=$G(GXtq(tsq)) I tokt="" D b^dv("Err no tokt","tokt,tsq")
         .
