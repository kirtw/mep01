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
       S TIVL="devrg,devlog"
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
       D css("td","min-width:75px;border: 1px solid black;")
       D css("td .tdt1","background-color:lightgray;")
       D css("td .tdt2","background-color:lightblue;")
       D css("td","text-align:center;")
       Q
;;pt1FL:
;;pt2FL:gran,gnts,gnte_PTx(StkP,gnts)
guts  D ot("table")
      D ot("tr"),htr("tki:") F tki=1:1:TKv D ot("th"),sv(tki),ct
      D ct,breol^hgh
      F pti=1:1  Q:$D(PTx(pti))=0  D rows  ;
       ;
      D ot("tr"),htr("tokt:") F tki=1:1:TKv D ot("th"),gt,sv(tkcod),ct
      D ct,breol^hgh
      D ot("tr"),htr("Str:") F tki=1:1:TKv D ot("th"),gt,sv(tks),ct
      D ct,breol^hgh  
       D ct("table")  D breol^hgh
       Q 
;*
;;tokFL:tkcod,tks,tkcs,tkce,tkri_TKv(tki)
gt   D GFL^kfm(tokFL) Q ; TKv(tki, @tokFL
;*
;* pti~StkP, gnts~tki  
rows  D ot("tr"),htr("StkP "_pti_"a")
      F tki=1:1:TKv DO  
         .D gp2 
         .I arg3="" D ot("td .tdt1")
         .I arg3'="" D ota^hgh("td .tdt2",,arg3)  ; colspan            
         .D sv(tdt1),ct 
         .I nspan>1 S tki=tki+nspan-1
      D ct("tr")
      ;
      D ot("tr"),htr(" "_pti_"b")
      F tki=1:1:TKv DO  ;
        .D gp2 
        .I arg3'="" D ota^hgh("td .tdt2",,arg3)  ; colspan
        .I arg3="" D ot("td .tdt2")
        .D sv(tdt2),ct 
        .I nspan>1 S tki=tki+nspan-1
      D ct("tr")  
      ;
      D ot("tr"),htr(" "_pti_"c")            
      F tki=1:1:TKv DO  ;
        .D gp2 
        .I arg3'="" D ota^hgh("td .tdt3",,arg3)  ; colspan
        .I arg3="" D ot("td .tdt3")
        .D sv(tdt3),ct 
        .I nspan>1 S tki=tki+nspan-1            
      D ct("tr")         
      D breol^hgh
      ;
      Q
;* line header literal
htr(x)  D ot("td"),sv(x),ct Q
;
;;pt1FL:Lev_PTx(pti)   OBS
gp1   D GFL^kfm(pt1FL) ; pti : Lev
          ;
      Q 
;;pt2FL:gran,gnts,gnte_PTx(StkP,gnts)
; pti~StkP,  ptj=gnts  
gp2   NEW Q I $$arg^pps("pti,tki") G Qb
      D GFL^kfm("gran,gnts,gnte_PTx(pti,tki)") ; gran, gnts,gnte
      D GFL^kfm("grulst_GRc(gran)")
      S gnstr="'" F tkx=gnts:1:gnte DO  
        .S gnstr=gnstr_$G(TKv(tkx,"tks"),"|")
      S gnstr=gnstr_"'"
      S tdt1=gran
      S tdt3=grulst
      S nspan=gnte-gnts+1
      S gnC=$G(gnts)_":"_$G(gnte)_"/"_$G(nospan)     
      S tdt2=gnC_" "_gnstr
      I 'gnts S tdt3="|"
      KILL colspan I nspan>1 S colspan=nspan  ;D b^dv("Log colspan","gran,nspan")
      S arg3="" I nspan>1 S arg3="colspan="""_nspan_""""
      ; ^ot^hgh Fudge vs ota("td" ,clslst ,atpar)  atpar="colspan=""2""
      G Q
;*
Q      Q:$Q Q Q:Q=""
Qb     D b^dv("Err ^"_$T(+0),"Q,RG,devrg,gi,grab,gran") Q:$Q Q  Q
;*
;* local shorthand vers to ^hgh
ot(x)  D ot^hgh($G(x)) Q
ct(x)  D ct^hgh($G(x)) Q
sv(x)  D sv^hgh($G(x)) Q
css(x,y) D css^hgh($G(x),$G(y)) Q
