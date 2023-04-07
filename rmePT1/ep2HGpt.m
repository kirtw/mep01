ep2HGpt ;CKW/ESC i14dec22 umbr./ rmep2/ ;20221214-64;HGen Parse Tree Array
;
;
;  PT(xi,yi)  Table
;  xi cols  0:1:nIns
;  yi rows  state table, ?SSg 
top   D I0,IHT  ;create table of data
      D HG
      Q
;*
I0    S Ins="1+(2*3+4)"
      KILL INc F i=1:1:$L(Ins) S C=$E(Ins,i),INc(i)=C
      KILL Ttok S V="Cdig:0123456789,Cop:(,Ccp:),Psum:+-,Pfac:*/"
      F vi=1:1:$L(V,",") S P=$P(V,",",vi),runa=$P(P,":"),CL=$P(P,":",2) DO  ;
        .F ci=1:1:$L(CL) S c=$E(CL,ci),Tokx(c)=runa
      Q
;*
IHT   KILL PT,Pcs S eol=$C(13)
      S nIns=$L(Ins)
      F xi=1:1:nIns S PT(.1,xi)=xi,PT(.2,xi)=$E(Ins,xi)
      S yi=1,nPTy=20
      F xi=1:1:nIns S C=INc(xi) DO  ;
        .I C?1N DO  ;
           ..I xi=1 D tokL("Cdig,num,fac,prod,sum",1)
           ..I xi=4 D tokL("Cdig,num,fac,prod",1)
           ..I xi=6 D tokL("Cdig,num,fac",1)
           ..I xi=8 D tokL("Cdig,num,fac,prod",1)
        .I C?1P S tok=$G(Tokx(C)) S T=tok_eol_"{"_C_"}",PT(yi,xi)=T
      S yi=5,xi=4,C="2*3" D tokL("prod.1:3",yi)
      ;S yi=6,xi=4,C="2*3" D tokL("sum.2",yi)
      S yi=7,xi=4,C="2*3+4" D tokL("sum.1:5",yi)
      S yi=8,xi=3,C="(2*3+4)" D tokL("fac.1:7",yi)
      S yi=8.1,xi=3,C="(2*3+4)" D tokL("prod.2:7",yi)
      S yi=9,xi=1,C="1+(2*3+4)" D tokL("sum.1:9",yi)
      S yi=0 F qi=0:1 S y0=yi,yi=$O(PT(yi)) Q:yi=""
      D blank(y0+1,10)
      Q
;*   yi,xi, C, tokL : PT(yi,xi), Pcs(yi,xi)   
tokL(tokL,y0)   NEW ti,tok,yti
      F ti=1:1:$L(tokL,",") DO  ;
        .S tok=$P(tokL,",",ti)
        .S yti=y0+ti-1
        .  I tok[":" S cs=$P(tok,":",2),Pcs(yti,xi)=cs  ;  ,tok=$P(tok,":")
        .S T=tok_eol_"{"_C_"}"
        .S PT(yti,xi)=T
      Q
;*
blank(y0,N)
      F yi=y0:1:y0+N S PT(yi,0)=yi
      Q
;*
HG    S Fil="PT.2.html" D ^devIB ; : PB
      S devh=PB_"dmep/"_Fil
      D Init^hgh    S hghEOL=1
      D Hcss
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
             ...I cs>1 D ^dv("Log colspan","cs,scs,yi,xi")  DO  Q  ;
                ....D ota^hgh("td",".tcell","colspan="_cs) S xi=xi+cs-1 Q
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
