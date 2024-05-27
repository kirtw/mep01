ppWGR ;CKW/ESC i12mar24 umep./ rppar1/ ;2024-0312-88;Write GRv and GRc Grammar
;
;  GXtby(tokt,gran)
;
;*  GXsq(rsq)=grab
;;grabFL:grde,grnun,grri_GRv(grab)
;;granFL:grulst,gropsr,grtt_GRc(gran)
WGR    W !!,"Grammar -",!
       F rsq=1:1:GXsq S grab=$G(GXsq(rsq)) DO  ;
         .D GFL^kfm(grabFL) ; GRv(grab,  grnun, grde, grri
         .W:$X ! W "  ",grab," ",?10,grde,"    ln:",grri,!
         .F grun=1:1:grnun S gran=grab_"."_grun DO  ;
            ..D GFL^kfm(granFL)  ; GRc(gran , grulst, grtt, gropsr, 
            ..W:$X ! W ?4,gran,"  ",?15,grtt,"  "
            ..W ?30,$P(grulst,"_"),?50,$P(grulst,"_",2)
            ..I gropsr'="" W ?70,"post:",gropsr
            ..W !
       Q
;*
