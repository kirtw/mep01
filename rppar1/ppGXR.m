ppGXR ;CKW/ESC i8mar24 umep./ rppar1/ ;2024-0308-55;Trace/Traverse Grammar structure
;
;  GRv(grab  gunun
;  GRc(gran  grulst, gropsr, 
;  GRt(tokt   terminal tokens
;   :  GXby(
;   :  GXlev(
;
top KILL GXby S GXby=0  ;GXby(grab,gran)=grulst
    KILL Gxlev   ;GXlev(grab
    NEW Q I $$arg^pps("GRv,GRc") G Qb
    D ^ppIMG
    S grabC="mCmds",Lev=1  D SLG
    D G1(grabC,Lev)
    ;
    D UnRef
    
    W:$X ! W "Finished Traversal"
    D la^dv
    Q
;* Recursive 
;*
G1(grabC,Lev)  
    NEW grulst,gran
    D Gab ; : 
      I grulst="" S Q="grulst null" G Qb
    S Lev=Lev+1 D SLG ; grabC,Lev
    F RnC=1:1:$L(grulst," ") S tok=$P(grulst," ",RnC) DO  ;
      .I tok="" D b^dv("Null tok in grulst","tok,grulst,RnC,granC,grabC") Q
      .S toty="R" I tok?1P!(tok[".") S toty="T"
      .I toty="T" Q
      .S GXby(tok,gran)=grulst
      .D G1(tok,Lev) ;Recursive
    G Q     
;*
Q      Q:$Q Q Q:Q=""
Qb     D b^dv("Err ^"_$T(+0),"Q,RG,devrg,gi,grab,gran") Q:$Q Q  Q
;*
;* Save Level of grab
;*  grabC, Lev : oL,  GXlev(
SLG S oL=$G(GXlev(grabC))
      I ol'="" D b^dv("Gram Data Err Loop ","grabC,ol,Lev") Q
    S GXlev(grabC)=Lev
    Q
;* Get grabC : grnun,grde : grunC=1,granC, grulst
Gab  S grab=grabC D GFL^kfm("grde,grnun") ; grab
     I 'grnun D bug^dv Q
     S grun=1,grunC=grun
     S gran=grab_"."_grun
     D GFL^kfm("grulst,gropsr",granFL) ; GRc(gran : grulst
     I grulst="" D b^dv("Err missing grulst/gran","gran,grab,Lev")
     Q
;*     
UnRef  S nur=0 D ^ppIMG
       F rsq=1:1:Gxsq S grab=$G(GXsq(rsq)) DO  ;
         .S x=$G(GXlev(grab))
         .I x'="" Q
         .D GFL^kfm(
         .S nur=nur+1 W:$X ! W grab,"  "

