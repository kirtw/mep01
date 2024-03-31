ppHPT ;CKW/ESC i8mar24 umep./ rppar1/ ;2024-0309-00;Write HGen PTx grid
;
;   See umep./   rmePT1/ep2HGrp.m  ota^hgh("td",".tdcls","colspan="_nspan)
;
;   COls  tki   table, tr td
top    NEW Q I $$arg^pps("PTx")
       NEW:0 hFil,hFol,devh
       S hFil="PTx-grid.2.html"  D IB^mepIO
       S hFol="ww2x/"
       S devh=PB_hFol_hFil
       ;
       D Init^hgh
       S TIhd="Parse Table Grid"
       S TIft="  by ^"_$T(+0)
       S TItb="^ppPT"
       D Hcss
       D HGS^hgh
       D guts
       D HGE^hgh
       D WH^hgh(devh)
       W:$X ! W "Comlpeted ",$G(devh,"? devh"),!
       Q
;*
Hcss   ;
       D css("table","border: 1px solid black;border-collapse: collapse;")
       D css(".tdcls","border: 1px solid blue;")
       D css("td","background-color:lightgray;min-width:50px;")
       Q
;;pt1FL:
;;pt2FL:
guts   D ot("table")
       D ot("tr"),htr("tki:") F tki=1:1:TKv D ot("th"),sv(tki),ct
       D ct,breol^hgh
       D ot("tr"),htr("Terminal:") F tki=1:1:TKv D ot("th"),gt,sv(tkcod),ct
       D ct,breol^hgh
       D ot("tr"),htr("Str:") F tki=1:1:TKv D ot("th"),gt,sv(tks),ct
       D ct,breol^hgh
       F pti=1:1  Q:$D(PTx(pti))=0  D gp1 DO  ;
         .D ot("tr"),htr("Row "_pti)
         .F tki=1:1:TKv D ot("td"),gp2,sv(td),ct
         .D ct("tr")
         .D breol^hgh
       D ct("table")  D breol^hgh
       Q
;* line header literal
htr(x)  D ot("td"),sv(x),ct Q
;
;;pt1FL:Lev_PTx(pti)
gp1   D GFL^kfm(pt1FL) Q
;;pt2FL:gran,grts,grte,grstr_PTx(pti,tki)
gp2   D GFL^kfm(pt2FL)
      S td=grab_$C(12)_grstr
      S nspan=grte-grts+1
      Q
;;tokFL:
gt   D GFL^kfm(tokFL) Q ; TKv(tki, @tokFL
;* local shorthand vers to ^hgh
ot(x)  D ot^hgh($G(x)) Q
ct(x)  D ct^hgh($G(x)) Q
sv(x)  D sv^hgh($G(x)) Q
css(x,y) D css^hgh($G(x),$G(y)) Q
