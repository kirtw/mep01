WSTK ;CKW/ESC i6apr24  ;;Quickie debug front -no logic here, just name ^WSTK
;
;
;
top   D WSTKsr
      Q
;*  moved from ^p2PAR
;*  STK(), StkP, sgrabFL, sgranFL 
WSTKsr  NEW tbs 
      D stb^dv3("Wstkb","StkP:3,sty:5,tki:3,grab:10,grts:3,grte:3,grnun:4,grri:5,grde:20")
      D stb^dv3("Wstkn","StkP:3,sty:5,tki:3,gran:10,grts:3,grte:3,grulst:40")
      D stb^dv3("Wstkt","StkP:3,sty:5,tki:3,gnn:10")
      NEW PS S PS=StkP
    NEW sty,StkP,grab,grri,grnun,grde,grts,grte,Gn,grun,gran,grulst,gropsr,Rn,tok,gnn,gtki
    NEW T,L,xFL,SKx,sgrabFL,sgranFL,stokFL
    F xFL="sgrabFL","sgranFL","stokFL" S T=$T(@xFL^p2IMG),L=$P(T,";;",2),L=$P(L,":",2),@xFL=L
    D hdr^dv3("Wstkb"),hdr^dv3("Wstkn"),hdr^dv3("Wstkt")
    F SKx=1:1 DO  I $D(STK(SKx))=0,$O(STK(SKx))=""  Q  ;
      .S StkP=SKx
      .D GFL^kfm("sty_STK(StkP)")
      .I StkP=PS W:$X ! W "StkP:",StkP,"  *** ",!
      .I sty="grab" DO  Q
        ..D GFL^kfm(sgrabFL) ; STK(StkP,
        ..D bln^dv3("Wstkb")
      .I sty="gran" DO  Q
        ..D GFL^kfm(sgranFL) ; STK(StkP,
        ..D bln^dv3("Wstkn")     
      .I sty="tok" DO  Q
        ..D GFL^kfm(stokFL) ; STK(StkP,
        ..D bln^dv3("Wstkt")          
      W ! Q
;*
