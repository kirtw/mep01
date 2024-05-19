ppHPT ;CKW/ESC i8mar24 umep./ rppar1/ ;2024-0309-00;Write HGen PTx grid
;  PTx(), TKv()
;   See umep./   rmePT1/ep2HGrp.m  ota^hgh("td",".tdcls","colspan="_colspan)
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
       S TImo="BraceLine"
       S TIVL="devrg,devlog"
         I $G(devrg)="" DO  
           .S d=$G(GRv(0,"devrg")) I d'="" S devrg=d Q
           .D b^dv("Err undef devrg","devrg,TIVL")
         I $G(devlog)="" D ^dv("Err devlog value gone.","devlog,TIVL")
       D Hcss
       D HGS^hgh
       D guts
       D HGE^hgh
       D WH^hgh(devh)
       W:$X ! W "Completed ",$G(devh,"? devh"),!
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
;;pt2FL:gran,grts,grte_PTx(StkP,grts)
guts  D ot("table")
      D ot("tr"),htr("tki:") F tki=1:1:TKv D ot("th"),sv(tki),ct
      D ct,breol^hgh
      S pti="" F ptj=0:1  S pti=$O(PTx(pti))  Q:pti=""  D rows  ;
       ;
      D htk  ;optional
      D ct("table")  D breol^hgh
      Q
;*  hgen two lines of tk      
htk   D ot("tr"),htr("tokt:") F tki=1:1:TKv D ot("th"),gt,sv(tkcod),ct
      D ct,breol^hgh
      D ot("tr"),htr("Str:") F tki=1:1:TKv D ot("th"),gt,sv(tks),ct
      D ct,breol^hgh  
      Q 
;*
;;tokFL:tkcod,tks,tkcs,tkce,tkri_TKv(tki)
gt   D GFL^kfm(tokFL) ; TKv(tki, @tokFL  tkcod, tks
     Q
;*
;* pti~StkP, grts~tki  
rows  
      D r1,r2,r3
      Q
;*      
r1    D ot("tr"),htr("StkP "_pti_"a")
      F tki=1:1:TKv DO  
         .D gp2 
         .I arg3="" D ot("td .tdt1")
         .I arg3'="" D ota^hgh("td .tdt1",,arg3)  ; colspan            
         .D sv(tdt1),ct 
         .I colspan>1 S tki=tki+colspan-1 ;D b^dv("Log bump tki for colspan","tki,colspan") ;fudge
      D ct("tr")
      Q
      ;
r2    D ot("tr"),htr(" "_pti_"b")
      F tki=1:1:TKv DO  ;
        .D gp2 
        .I arg3'="" D ota^hgh("td .tdt2",,arg3)  ; colspan
        .I arg3="" D ot("td .tdt2")
        .D sv(tdt2),ct 
        .I colspan>1 S tki=tki+colspan-1
      D ct("tr")  
      Q
      ;
r3    D ot("tr"),htr(" "_pti_"c")            
      F tki=1:1:TKv DO  ;
        .D gp2 
        .I arg3'="" D ota^hgh("td .tdt3",,arg3)  ; colspan
        .I arg3="" D ot("td .tdt3")
        .D sv(tdt3),ct 
        .I colspan>1 S tki=tki+colspan-1
      D ct("tr")         
      D breol^hgh
      Q
;* line header
htr(x)  D ot("th"),sv(x),ct Q
;
;;pt1FL:Lev_PTx(pti)   OBS
gp1   D GFL^kfm(pt1FL) ; pti : Lev
          ;
      Q 
;;pt2FL:gran,grts,grte,grulst,gropsr,gropsyn,colspan,gnC_PTx(StkP,grts)
; pti~StkP,  ptj=grts  
gp2   NEW Q I $$arg^pps("pti,tki,granFL") G Qb
      D GFL^kfm("gran,grts,grte,grulst,gropsr,gropsyn,grstr,colspan,gnC_PTx(pti,tki)") ; gran, grts,grte
      ;D GFL^kfm("grulst,gropsr,gropsyn",granFL)
      ;D der2  ; vs stored derived fields by ^p2PAR      
      S tdt1=gran
      S tdt3=grulst
      S tdt2=grstr
      I 'grts S tdt3="|"
      S arg3="" I colspan>1 S arg3="colspan="""_colspan_""""
      ; ^ot^hgh Fudge vs ota("td" ,clslst ,atpar) eg,  atpar="colspan=""2""
      G Q
;*  grts,grte, TKv() : grstr, colspan, gnC      
xder2  S grstr="'" F tkx=grts:1:grte DO  
        .S grstr=grstr_$G(TKv(tkx,"tks"),"|")
      S grstr=grstr_"'"
      S colspan=grte-grts+1
      S gnC=$G(grts)_":"_$G(grte)
      I colspan>1 S gnC=gnC_"/"_colspan
      Q
;*
Q      Q:$Q Q Q:Q=""
Qb     D b^dv("Err ^"_$T(+0),"Q,RG,devrg,gi,grab,gran") Q:$Q Q  Q
;*
;* local shorthand vers to ^hgh
ot(x)  D ot^hgh($G(x)) Q
ct(x)  D ct^hgh($G(x)) Q
sv(x)  D sv^hgh($G(x)) Q
css(x,y) D css^hgh($G(x),$G(y)) Q
