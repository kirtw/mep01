TOId2   ;CKW/ESC   i22jan18  gmsa/  rTOI7/ ; 20191002-94 ; Find a Date Field TOI
  ; 20sep20 cqlog-> devlog   rev 9oct Use WD() not L2  8aug19    
  ; At least one / or - not just day of month vs amt/num
;    Wpnd(wki)-> wki, WD(wki)
;  Defaults  Ddef(vn)=val  Dlst()  vn in {yr,mo,wkn,dat,apm,  d12, dj, wh}
A    D B,Def,dtm,Sdef,SDlst
     Q
;* d2 Variant One wki at a time to coclusions, Wty, Wr
B    ;I $G(toiFL)="" D ^TOIimg  ; : dtFL, toiFL ^TG(0
     NEW d8,wh,djw,dQ D II
     ;;dQ 1 date found, exit series of format tests
     S qD=0,wki=0 F wn=0:1 S wki=$O(Wpnd(wki)) Q:wki=""  DO  ;
       .S wd=$G(Wdlc(wki)) I wd="" Q
       .S wd=$TR(wd,"-","/")  ;treat / and - the same, switch to /
       .I wd["/" D dayp I dQ S dwki=wki D S9^TOIp("d8",d8) D b^dv("Log dayp","dwki,d8,d12") Q
       .D dtn Q:dQ
       .D dydt Q:dQ
     S wki=0 F wn=0:1 S wki=$O(Wpnd(wki)) Q:wki=""  DO  ;Ck wds following d8
       .S tm1=$G(Wd(wki)) I tm1'="" DO  ;
          ..D time
          ..S dtm=hr_min
           ..I dtm'?4n D b^dv("Err time ?4n","dtm,hr,min,d8,d12,dQ,wki,ri,L") Q
           ..S d12=d8_dtm
          ..D S9^TOIp("dtm",dtm)
          ..D b^dv("Log time","hr,min,dtm,d12,d8")  ;not tested yet
              ; Now combine all date-time vars, @DVL,  and -> Wty
              ;  yr,mn,day, apm,hr,min  : d8,d12 ?week also
dtm   S (d12,d8)="" D dpr("dtm") 
      I mn?1n S mn="0"_mn D dpr("lzmn")  D b^dv("err vs $$mn","mn,L,ri")
      I day?1n S day="0"_day D dpr("lzday") D b^dv("err vs $$day","day,L,ri")
      I yr?2n S yr="20"_yr D dpr("yrl20")  D b^dv("err vs $$yr","yr,L,ri")
      S d=yr_mn_day I d?8n S d8=d_"_"
      I hr?1n S hr="0"_hr D dpr("lzhr")
      I min?1n S min="0"_min D dpr("lzmin")
      S d=yr_mn_day_"_"_hr_min 
      I d?8n1"_"4n S d12=d
        I d12'?8n1"_"4nn D ^deverr("d12 err ","d12,d,yr,mn,day,hr,min,dt1,dt2,ri,L0,L2") Q
        I d8'?8n1"_" D ^deverr("d8 err","d8,d12,d,yr,mn,day,ri,L0,L2,L") Q
      ;
      I dwki'=wki D b^dv("ck need for dwki","dwki,wki,ri,L0")
      I dwki="" D b^dv("Err no dwki","dwki,wki,nsp,d8,d12,ri") Q
      S wki=dwki 
      D S9^TOIp("d8",d8)
      Q
;*
II   S AZ="ABCDEFGHIJKLMNOPQRSTUVWXYZ",Az="abcdefghijklmnopqrstuvwxyz"
     S dyL="mon,tue,wed,thu,fri,sat,sun,"
     S moL="jan,feb,mar,apr,may,jun,jul,aug,sep,oct,nov,dec,"
     Q
;*  Derive Defaults from Ddef(), where day, hr etc are still null
Def  I yr="" S yr=$G(Ddef("yr"))
     I day="" S day=$G(Dlst("day")) I day S mn=$G(Dlst(mn)),yr=$G(Dlst("yr"))
     I day="" S day=$G(Ddef("day")) I day>0 S mn=$G(Ddef("mn")),yr=$G(Ddef("yr"))
     I mn="" S mn=$G(Dlst("mn")) D dpr("deflstmn") I mn S:$G(Dlst("yr")) yr=Dlst("yr")
     I mn="" S mn=$G(Ddef("mn")) D dpr("defdefmn") I mn S:$G(Ddef("yr")) yr=Ddef("yr")
     I yr="" S yr=$G(Dlst("yr")) D dpr("defyr") I yr="" S yr=$G(Ddef("yr"))
     I day="" D dpr("defday") DO  
        .I $G(Ddef("d12")) S d12=Ddef("d12") I d12?12n D d12p Q
        .I $G(Dlst("d12")) S d12=Dlst("d12") I d12?12n D d12p Q
        .I $G(Ddef("day")) S day=Ddef("day"),mn=$G(Ddef("mn")),yr=$G(Ddef("yr"))
     I hr="" S hr=$G(Dlst("hr")),min=$G(Dlst("min")) I hr="" S hr="00",min="00"
     ;I wh="",d12?12n S whj=$$d8whj^dd($E(d12,1,8)),wh=+whj,djw=$P(whj,"-",2)
     Q
;* Save Dlst()  LAST vs Default   vs end of dtm already, redone here
SDlst KILL Dlst I d12?12n S Dlst("d12")=d12 ;D d12p 
     S Dlst("yr")=yr,Dlst("mn")=mn,Dlst("day")=day
     S Dlst("hr")=hr,Dlst("min")=min,Dlst("apm")=apm
     I $G(wh) S Dlst("wh")=wh
     Q
;*   from end of dtm
Sdef  F vn="d12","yr","mn","day","hr","min" S Dlst(vn)=$G(@vn)  ; sic vs dtFL ? not wh
      Q
;*  d12 -> yr,mn,day, hr,min
d12p S day=$E(d12,7,8),mn=$E(d12,5,6),yr=$E(d12,1,4)
     S hr=$E(d12,9,10),min=$E(d12,11,12)
     Q
;*
;*  wd split by/ 2 or 3  : dQ, yr, mn, day
dayp  S Ln=$L(wd,"/"),p1=$P(wd,"/"),p2=$P(wd,"/",2),p3=$P(wd,"/",3)
        ;I p1'?1.2n!(p2'?1.2n) Q  ; some other use of /
      I Ln=3 S yr=$$yr(p3),mn=$$mn(p1),day=$$day(p2) DO  Q:dQ
          .S d8=yr_mn_day_"_" D dpr("3/d8")
          .I d8?8n1"_" D S9^TOIp("d8",d8)
      I Ln=2  DO  Q:dQ
        .S mn=$$mn(p1),day=$$day(p2)
        .I 'yr DO  
           ..S yr=$G(Ddef("yr")) I yr D dpr("defyr") Q
           ..S yr=$G(Dlst("yr")) D dpr("yrDlst")
        .S d8=yr_mn_day_"_"  I d8'?8n1p D b^dv("Err d8","dQ,d8,d12,wd,p1,p2,p3,wki,ri") Q
        .D dpr("2/md")
        .D S9^TOIp("d8",d8)  ; S9(Wty,Wr)
      D b^dv("Err matching /","dQ,wd,wki,d8,d12,L,ri")
      Q
;*
dtn(d) I $G(d)="" D bug^dv Q
      I d'?4.12n Q ""
      I d?12n S d12p=$E(d,1,8)_"_"_$E(d,9,12) D S9^TOIp("d12",d12p) Q d12p
      I d?8n S d8p=d_"_" D S9^TOIp("d8p",d8p) Q d8p
      I d?4n S y=$$yr(yr) I y S d8y=y D S9^TOIp("yr",d8y) Q d8p
      Q ""
;*
Se(cd) I $G(cd)="" D bug^dv Q
       I dE="" S dE=cd Q
       S dE=dE_","_cd
       Q
;*$Q=yr'
yr(y)  I $G(y)="" D bug^dv Q
       I y?2n S y="20"_y
       I y?4n,y>1900,y<2100 Q y
       Q ""
;*$Q=mn'
mn(m) I $G(m)="" D bug^dv Q
       I m?1.2n,m<13 S:m?1n m=0_m Q m
       Q ""
;*
day(d) I $G(d)="" D bug^dv Q
       I d>31 Q ""
       S ndm=$P("31,28,31,30,31,30,31,31,30,31,30,31",",",mn)
       I ndm=28,yr#4,'(yr#400) S ndm=29
       I d>ndm Q ""
       S:d?1n d=0_d 
       Q d
;*       
nyr(n) I $G(n)'?2.4n D Se("yr rng '"_n)   ;  No Refs
;* dt1 : yr, mo, day,  opt: hr,min
Xdate  S day="" ; I dt1["/" D day1 Q  ; may or may not have found date, day
      I dt1?1.2n3A.4n D nMon I day D dpr("nJan") Q
      I dt1?1"wk"1.2n D WKN I wh D dpr("WKn")  Q
      I dt1?12n S hr=$E(dt1,9,10),min=$E(dt1,11,12),dt1=$E(dt1,1,8) D dpr("n12") Q
      I dt1?8n S yr=$E(dt1,1,4),mn=$E(dt1,5,6),day=$E(dt1,7,8) D dpr("n8") Q
      I dt1?4n D dpr("4nyr") D year(dt1) I yr Q  ;No day yet, mark used 2019 not time
      D dpr("date-not")
     ; Didnt find a date in this WD
     Q
    
;*  10oct or 10oct19 : day, mn, yr
nMon  NEW d,m,n,y
      S d=+dt1,m=$E(dt1,2,4) S:m m=$E(dt1,3,5)
      S m=$$LC^TOIs(m),n=$F(moL,m_",")\4  ; 1-12 or 0
      I 'n D dpr("xMocd") Q
      S mn=n,day=d
      S y=$P(dt1,m,2) I (y?2n)!(y?4n) D year(y) D dpr("1JanY") I yr Q
      Q
;*  ?2n or 4n year ? : yr
year(y)  I y?2n S y=20_y
      I y>1950,y<2100 S yr=y Q
      D dpr("4nnotYr")
      Q
;*  dy1~wk41 : wh for use with day of week, 
WKN  S w=+$E(dt1,3,9)
     I (w<1)!(w>53) D b^dv("Err wkn 1-53","dt1,w") Q
     S:w?1n w=0_w S wjy=w,w6=yr_wjy
       I w6'?6n D b^dv("Err w6 fmt","w6,w")
     S wh=$$w6wh^dd(w6)
     Q
;*
;*  dt2, dyL  :  day of week ("wed"), wh(week#)  -> day,mn,yr, d8m~d8
dydt  S djwq=$F(dyL,dt2_",")-1\4 I djwq DO  Q:dQ
        .; Calc day from day of week (djwq) +  Week as wh
        .S d8=$$whjd8^dd(wh,djwq)
        .I d8'?8n D b^dv("Err cal date from week & day of week","d8,wh,djwq") Q
        .S yr=$E(d8,1,4),mn=$E(d8,5,6),day=$E(d8,7,8)
        .D S9^TOIp("d8",d8)
      I day  Q  ; Ignore if have date, redundant - vs ck consistent-- below
      DO  ; ck day of wk vs d8/d12
        .I d12?12n S d8=$E(d12,1,8)
        .E  S:mn?1n mn=0_mn S:day?1n day=0_day S:yr?2n yr=20_yr S d8=yr_mn_day
        .D cdjw(d12) ; d8, djwq  seq week #
        .I djw=djwq Q  ;redundant, all is ok
        .D dpr("day-not-eq") 
        .D b^dv("mon NOT eq m/d","djw,djwq,day,L2,L0,ri")
      I day="" DO  Q
        .NEW dh,d8a,d8b,d12d
        .S xwh=$G(Ddef("wh")) I xwh DO   I d8 Q
           ..S d8=$$whjd8^dd(xwh,djwq)
           ..I d8'?8n D b^dv("Err def day","d8,xwh,wh,djwq") Q
           ..S yr=$E(d8,1,4),mn=$E(d8,5,6),day=$E(d8,7,8)
        .S d12d=$G(Dlst("d12")) I d12d="" S d12d=$G(Dlst("d12"))
        .S d8a=$E(d12d,1,8) I d8a'?8n Q
        .D cdjw(d8a)
        .S d12=d8b_$E(d12,9,12)
        .S day=$E(d12,7,8)
        .D ^devlog("Log mon -> day","day,djwq,wh")
      S:mn?1n mn=0_mn S:day?1n day=0_day
      S d8m=yr_mn_day
      Q
;*  : d8b, djw, day'
cdjw(d8a) I $G(d8a)'?8n D b^dv("cdjw-arg-not?8n") Q
        S dh=$$d8dh^dd(d8a)
        S whj=$$dhwhj^dd(dh)
        S djw=$P(whj,"-",2)
        S d8b=$$whjd8^dd(+whj,djwq)  ;diff day of week -> d8
        D dpr("d12-d8-wh-d8")
        S day=$E(d8b,7,8)  ;d8 may be null
        I day="" D b^dv("wed -> d8 err","day,d8a,dh,wh,djw,djwq,L2,L0,ri")
      Q
;* tm1 : hr, min
time  ;
      I $P(tm1,"pm")_"pm"=tm1 S apm="pm",tm1=$P(tm1,"pm") D dpr("pm")
      I $P(tm1,"p")_"p"=tm1 S apm="pm",tm1=$P(tm1,"p") D dpr("p")
      I $P(tm1,"am")_"am"=tm1 S apm="am",tm1=$P(tm1,"am") D dpr("am")
      I $P(tm1,"a")_"a"=tm1 S apm="am",tm1=$P(tm1,"a") D dpr("a")
      I tm1?1.2n1":"1.2n S hr=$P(tm1,":"),min=+$P(tm1,":",2) D dpr("n:n")
      ; Simple numbers- only if no hr yet
      I tm1?3.4n,hr="" S hr=tm1\100,min=tm1#100 D dpr("3-4nhrmin")
      I tm1?1.2n,hr="" S hr=+tm1,min="00" D dpr("1-2nhrmin00")
      I apm="pm",hr'="",hr<12 S hr=hr+12 D dpr("hr+12")
      S dtm=hr_min
      D S9^TOIp("dtm",dtm)
      Q

;*
;*  Add process log cd to  Lpr  (identical to dpr() in ^qdTOIin
dpr(cd) I Lpr'="" S Lpr=Lpr_", "_cd Q
        S Lpr=cd Q
;*    * * * * *

      
