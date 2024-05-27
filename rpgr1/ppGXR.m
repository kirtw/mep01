ppGXR ;CKW/ESC i8mar24 umep./ rppar1/ ;2024-0308-55;Trace/Traverse Grammar structure
;
;  GRv(grab  gunun
;  GRc(gran  grulst, gropsr, 
;  GRt(tokt   terminal tokens
;   :  GXby(grab,gran)= ... grulst
;   :  GXlev(grab)=...Lev   Detet looping, prev encountered in traversal
;   :  
;
top KILL GXby S GXby=0  ;GXby(grab,gran)=grulst
    KILL GXlev   ;GXlev(grab
    NEW Q I $$arg^pps("GRv,GRc") G Qb
    D ^ppIMG
    S grabC="mCmds",Lev=0
    D G1(grabC,Lev)
    ;
    D UnRef  ;grabs not traversed
    W:$X ! W "Finished Traversal  by ^"_$T(+0),!
    D la^dv
    Q
;* Recursive 
;*
G1(grabC,Lev)  
    NEW grulst,gran,Rn,un
    D Gab ; grabC : grnun, grde, Rn=1, gran, 
      I 'grnun Q ;undef ref, ignore here
    F un=1:1:grnun DO  I Q'="" G Qb
      .D Gran(grabC,un)
      .D Glst ;
      .  I grulst="" S Q="grulst null" Q
      .D Trv2(Lev)
    Q
;*  Lev' grabC,grunC,gran,grulst  
Trv2(Lev) NEW Rn
     D SLG ; grabC,Lev
       I QS'="" Q
     F Rn=1:1:$L(grulst," ") DO  ;
      .D Gtok ; grulst, Rn : toty, tok
      .I toty'="T" Q  ; vs R & E types
      .S Rtok=$D(GXby(tok))
      .  I $G(GXby(tok,gran))'="" D b^dv("Mult refs ?ok","grab,gran,Rn,grulst,tok")
      .S GXby(tok,gran)=grulst ;
      .I Rtok Q  ;Already traversed tok
      .S Lev=Lev+1 
      .D G1(tok,Lev) ;Recursive
    Q     
;*
Q      Q:$Q Q Q:Q=""
Qb     D b^dv("Err ^"_$T(+0),"Q,RG,devrg,gi,grab,gran") Q:$Q Q  Q
;*
;* Get grabC : grnun,grde : grunC=1,granC, grulst
Gab  S grab=grabC 
     I $D(GRv(grab))=0 S grnun=0,grulst="" Q
     D GFL^kfm("grde,grnun",grabFL) ; GRv(grab,
     I 'grnun D bug^dv Q
     S grun=1,grunC=grun
     D Gran(grabC,grunC) ; : gran, grulst
     Q
;* : gran
Gran(grabA,grunA) NEW Q I $$arg^pps("grabA,grunA") G Qb
     S gran=grabA_"."_grunA
     Q
;* 
;* gran : grulst, gropsr
Glst D GFL^kfm("grulst,gropsr",granFL) ; GRc(gran : grulst
     I grulst="" D b^dv("Err missing grulst/gran","gran,grab,Lev")
     Q
;*  grulst, Rn : toty, tok   ?Rn not beyond grulst here ?
Gtok  S tok=$P(grulst," ",Rn) 
      I tok="" D b^dv("Null tok in grulst","tok,grulst,Rn,granC,grabC") Q
      S toty="R" I tok?1P!(tok[".") S toty="T"
      Q
;* Save Level of grab
;*  grabC, Lev : QS, oL,  GXlev(
SLG S QS="",oLev=$G(GXlev(grabC))
      I oLev'="",oLev<Lev S QS="Qlev"_Lev D ^dv("Gram Data Err Loop ","grabC,oLev,Lev") Q
    S GXlev(grabC)=Lev
    Q
;*  Dupl ^ppXUxr ?
UnRef  S nur=0 D ^ppIMG
       W:$X ! W "Looking for Unreferenced grab's named rules",!
       F rsq=1:1:GXsq S grab=$G(GXsq(rsq)) DO  ;
         .S x=$G(GXlev(grab))
         .I x'="" Q
         .D GFL^kfm(grabFL) ; GRv(grab,  grde, grnun
         .S nur=nur+1 W:$X ! W grab,"  ",grde,"   " W:gropsr'="" " sr:",gropsr," "
       I 'nur W:$X ! W " ... No Unref grab's found.",!
       E  W:$X ! W " found   x",$G(nur),"  by UnRef^"_$T(+0),!
       Q
;*       
