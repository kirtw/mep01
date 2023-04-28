ep2HGpt(hFil,TIft) ;CKW/ESC i14dec22 umbr./ rmep2/ ;20221214-64;HGen Parse Tree Array
;
;
;  PT(yi,xi)  Table
;  Pcs(yi,xi)  cs colspan
;  xi cols  0:1:nIns
;  yi rows  state table, ?SSg 

;*
HG    I $G(hFil)="" S hFil="PT.2.html" 
      D ^devIB ; : PB
      S devh=PB_"dmep/"_hFil
      D Init^hgh    S hghEOL=1
      D Hcss
      I $G(TIft)="" S TIft="^"_$T(+0)      
      ;
      D HGS^hgh
      D guts
      D HGE^hgh
      ;
      D WH^hgh(devh)
      Q
;*  PT
guts  ;
      D ot^hgh("table")
      S yi=0 F yn=0:1  S yi=$O(PT(yi)) Q:yi=""  DO  
        .D ot^hgh("tr")   
        .F xi=0:1:nIns DO  ;
           ..S T=$G(PT(yi,xi)) S:T="" T=" "
           ..S cs=$G(Pcs(yi,xi)) S:cs="" cs=1
           ..DO  ;
             ...I cs>1  DO  Q  ;
                ....D ^dv("Log colspan","cs,scs,yi,xi")
                ....D ota^hgh("td",".tcell","colspan="_cs)
                ....S xi=xi+cs-1
             ...D ota^hgh("td",".tcell")   ; cs=1        
           ..D sv^hgh(T)
           ..D ct^hgh  ;td .tcell ?atpar
        .D ct^hgh("tr") 
      D ct^hgh("table")
      Q
;*
Hcss  ;D flexrow^hgh(".row",".tcell")
      D css^hgh(".row","background: lightgray;")
      D css^hgh("table","border: 1px solid black;border-collapse: collapse;")
      D css^hgh("th","border: 1px solid black;border-collapse: collapse;")
      D css^hgh("td","border: 1px solid black;border-collapse: collapse;")
      D css^hgh("td","width:10em")
      D css^hgh(".tcell","border: 1px solid black;")
      D css^hgh(".tcellsp","border: 1px solid yellow;background:lightblue;")
      Q
;*
