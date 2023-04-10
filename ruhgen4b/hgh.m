hgh	;CKW/ESC  i15May15 gmsa/ rhgen4b xx ; 20221201-40 ;  HGen Std Parts
;   WHT  mod for ,!   $G(hghEOL)  See ^mwMod5
;
;  Mode shift:  gen h str, NO writes
;        h into HTS() or HTE() or HT()
;  Compare to MDk compile data structures tg, tx
;RefBy: 1 dev  gmgu Nav  ^guN* in rgnav/
;
; falls from top here  (sic)
  D bug^dv("Should not use top of ^hgh","devh")
  Q
  ;   dev vers of ^dvh, integral with ^cfIO
  ;RefBy: gmgu/ KAcf/        later to convert: many uCal, T2DM, KA1, ...
; 9aug19  still very much dev in progress, not clean design...  
;     convert to h string vs WRITE's 
;*
;   Dependencies:  OFW, CFM, CFW^devIO rd2io/
  ;
  ;  next guts by Caller
  ;  filCSS  is external css file
  ;  vs CS(sel,propn)=value  no semicolon.
  ;  css(sel,propn,val)  - no quotes, mult refs to sel ok, diff propn's
  ;  csl(sel,prL)  prL is pre-composed mult list eg "width:100px; border:1px;"
; Conversion from write to s h=h_  strings is in progress, still writes h  also
;*
;*$$Q  S^h4css -> css^hgh(sel,prL)
flexrow(pardiv,kiddivL)  NEW Q,ki,w,kiddiv S Q=""  ;; 
       D css(pardiv,"display: flex; flex-direction: row; flex-wrap: nowrap; justify-content: space-between; ")   ;Container
       F ki=1:1:$L(kiddivL," ") S kiddiv=$P(kiddivL," ",ki) DO  ;
         .S w=1 I kiddiv[":" S w=$P(kiddiv,":",2),kiddiv=$P(kiddiv,":") I 'w S w=1
         .I kiddiv'="" D css(kiddiv,"flex: "_w_";")                                ; Flex item
       Q:'$Q  Q ""
;*
;*$$Q  
flexcol(pardiv,kiddiv)  ; 
       D css(pardiv,"display: flex; flex-direction: column; flex-wrap: nowrap; justify-content: flex-start; ")   ;Container
       D css(kiddiv,"flex: 1;")                                ; Flex item
       Q:'$Q  Q ""
;*$$Q  
flexvert(pardiv,kiddiv)  ; 	;; sic name vs row  - already in use... dup flexcol
       D css(pardiv,"display: flex; flex-direction: column; flex-wrap: nowrap; justify-content: flex-start; ")   ;Container
       D css(kiddiv,"flex: 1;")                                ; Flex item
       Q:'$Q  Q ""
;*
A     S Q=$$HGS I Q'="" Q Q
      S Q=$$HGE I Q'="" Q Q
      Q:'$Q  Q ""
;*
;*$$  Q=$$HGS  : HTS()		then ^hghWH(devx) - open devx, write HTS,HT,HTE and close
;   Note arg devw  is gone here -> goes to WH^hgh(devw)
;   devcss  is ext css file name, flag to use HCS for external...See css vs cse sr
;* was HG1, HGE was HG2
HGS() KILL TSTK  S TSTK=0,tsti=0  ; dupl stk ptr ?
      I $D(TI)>1 D ITI  ; 	TI*, TI(), TIjson
      S sp3="&nbsp;&nbsp;&nbsp;" 
      D DOCTYPE,html
      D HD
      D BODs
      ;D Ssh("<code>") ; ??
      Q:$Q ""
      Q
; mod to add arg, to close it  11apr16 in FL2/rdv/  ^dvh  ref by ^mdwht and gmsa/rdv/
;*$$Q but no errors, consistency
HGE() ;D Esh("</code>") ; ??
      D BODe
      D htmlq
      D KTI
      Q:$Q ""
      Q
;*
html	D Ssh("<html lang='en'>") Q
htmlq	D Esh("</html>") Q
;*$$
;*   Nested call   S Q=$$sv^hgh($$enc^hgh(X))  
enc(X)  NEW i,Y S Y=X ;W !!,0,". ",X,!
      F i=0:1 Q:Y'["<"  S Y=$P(Y,"<")_"~^lt;"_$P(Y,"<",2,999)
      F i=0:1 Q:Y'[">"  S Y=$P(Y,">")_"~^gt;"_$P(Y,">",2,999)
      F i=0:1 Q:Y'["&"  S Y=$P(Y,"&")_"~^amp;"_$P(Y,"&",2,999)
      F i=0:1 Q:Y'["~^"  S Y=$P(Y,"~^")_"&"_$P(Y,"~^",2,999)
      Q Y
;*  sic not $$Q - not consistent, albeit no err
sv(h)   S HT=HT+1,HT(HT)=$G(h),h="" Q:$Q "" Q   ; rev name for shg  ;Note $$sv or D sv^hgh
shg(h)  S HT=HT+1,HT(HT)=$G(h),h="" Q:$Q "" Q
;*  Non breaking spaces, html pita
sp(nsp) NEW ni   I '$G(nsp) S nsp=1
      I nsp>10 S nsp=10  ; silent max 10 nbsp ??
      F ni=1:1:nsp D sv("&nbsp;")
      Q
;*
;These are mostly? internal
Ssh(h) S HTS=HTS+1,HTS(HTS)=$G(h),h="" Q
Esh(h) S HTE=HTE+1,HTE(HTE)=$G(h),h="" Q
;*  pass raw pre-coded html in special cases - use case colspan in table
svrawh(h) S HT=HT+1,HT(HT)=$G(h) Q:$Q "" Q  ;sv should encode literal '<>&' etc.
;*  TI() and TI      Force all vars from Array TI, not strays, maybe null
ITI   F vs="tb","hd","VL","mo","ft","cssFil" S vn="TI"_vs,@vn=$G(TI(vs))
      I $D(TItb)#2=0 S TItb="HGen"  ; ???
      Q
KTI   KILL TI,TIhd,TIft  ; sic $D variability - clean up; x  VVL() not used
      Q
;* RefBy:  Caller, NOT HGS
Init  D IKH  ; KILL & init HTS, HTE and HT() guts ...
      D KTI  
      KILL CS  S CS=0
      KILL HCS S HCS=0  ; redundant ?
      Q
;*
;*  RefBy: Init above vs outside refs ?
IKH    KILL HTS S HTS=0
       KILL HTE S HTE=0
       KILL HT S HT=0
       Q
;*
;*$$Q  $$:err	prL is space-list, ea ends in ;, pn:val sgl quotes prn
;* was csl but restored better name css
css(sel,prL) NEW err S err=""
      I $G(sel)="" S err="csl arg reqd" D bug^dv(err,"sel,prL") Q err
      I $G(prL)="" S err="arg prL reqd" D bug^dv(err,"prL") Q err
      D S^h4css(sel,prL)  ; HCS
      S Q=$$xsel(sel) I Q'="" D b^dv(Q,"sel") Q Q
      S CS=CS+1 I $D(CS(CS,sel)) D b^dv("Dupl CS?","CS,sel,prL")
      ; ? parse, err ck prL,  and rest of sel -- no error on bad css
      S CS(CS,sel)=sel_"  {"_prL_"}"  ;  vs       S CS(sel,pn)=val
      Q:'$Q  Q err
;*
;*$$Q  sel : tag, id, cls    internal syntax check, expand . -> class=, # -> id=
xsel(sel) S tag="div",id="",cls=""  NEW err S err=""
      I $G(sel)="" S err="1ot. Null arg tag" Q err
      I $E(sel)="." S cls=$P(sel,".",2,9)
       I cls[" "!(cls[";") S cls="'"_cls_"'"  ; wrap in quotes if embedded sp or colon
      I $E(sel)="#" S id=$P(sel,"#",2,9)
      Q err
;*
peol  D shg^hgh("<p line-height=50%> </p>") Q
;*  <br/>  newline  dont ot because no ct, not really a normal element/box
br()   D shg("<br/>")  Q
hr()   D shg("<hr/>")  Q   ; horizontal rule divider
;*  ict is #id, .class or element, not to be confused with css sel  selector, similar but broader
;*  add selectivity - class as second (opt) arg, which might be space list of classes
;*$$  ot shorter name, newer method- 17may20
;  $$Q null if ok
ot(ict,clsval) NEW h,err,cls,id  S err="",id=""
       S Q=$$xict(ict) ; : tag, id and cls defined/set
         I Q'="" D b^dv("Err Syn ict","Q,ict") Q Q
       I $G(clsval)'=""  DO  ;
          .I $G(cls)'="" D ^deverr("Dupl class cls clsval","cls,clasval,ict") 
          .I ict'="p" D b^dv("Err clsval not p sel (ict)","ict,cls")
          .I tag="" D b^dv("Err clsval but not tag 1st arg ict","tag,ict,clsval")
          .S cls=clsval
          .I cls[" " S cls=""""_cls_"""" 
       I $G(tsti)="" D bug^dv("tsti,TSTK not init for ^hgh HGS^hgh","ict") S tsti=0  ; sic vs init ???
       S tsti=tsti+1,TSTK(tsti,"ict")=ict,TSTK(tsti,"tag")=tag
         ;W !,?tsti*2   ;indent
         S h="<"_tag_" "
           I id'="" S h=h_"id="_id_" "
           I cls'="" S h=h_" class="_cls_" "   ;Any use, tolerance for sgl quote?
           ; Note properties here are html/inline, not css so = is the syntax!
           ; NO Props except class and/or id ! 
           ;   Q $$oprop()
           S h=h_">"
           D shg(h)  ; : HT()
           I err'="" D bug^dv("Unexpected err","err,ict,tag,cls,h") Q err
     Q:$Q err
     S Q=err Q      ;call vers both $$ and DO , ret Q (sic)
;*  ot variant with literal attr third arg, eg for colspan:3  in td
;*  ict is #id, .class or element, not to be confused with css sel  selector, similar but broader
;*  add selectivity - class as second (opt) arg, which might be space list of classes
;*$$  ot shorter name, newer method- 17may20
;  $$Q null if ok
ota(ict,clsval,atpar) NEW h,err,cls,id  S err="",id=""
       S Q=$$xict(ict) ; : tag, id and cls defined/set
         I Q'="" D b^dv("Err Syn ict","Q,ict") Q Q
       I $G(clsval)'=""  DO  ;
          .I $G(cls)'="" D ^deverr("Dupl class cls clsval","cls,clasval,ict") 
          .;I ict'="p" D b^dv("Err clsval not p sel (ict)","ict,cls")  ;? td vs p ^ep2W
          .I tag="" D b^dv("Err clsval but not tag 1st arg ict","tag,ict,clsval")
          .S cls=clsval
          .I cls[" " S cls=""""_cls_"""" 
       I $G(atpar)="" S atpar=""
       I $G(tsti)="" D bug^dv("tsti,TSTK not init for ^hgh HGS^hgh","ict") S tsti=0  ; sic vs init ???
       S tsti=tsti+1,TSTK(tsti,"ict")=ict,TSTK(tsti,"tag")=tag
         ;W !,?tsti*2   ;indent
         S h="<"_tag_" "
           I id'="" S h=h_"id="_id_" "
           I cls'="" S h=h_" class="_cls_" "   ;Any use, tolerance for sgl quote?
           ; Note properties here are html/inline, not css so = is the syntax!
           ; NO Props except class and/or id ! BUT here override by user of ota
           I atpar'="" S h=h_" "_atpar
           S h=h_">"
           D shg(h)  ; : HT()
           I err'="" D bug^dv("Unexpected err","err,ict,tag,cls,h") Q err
     Q:$Q err
     S Q=err Q      ;call vers both $$ and DO , ret Q (sic) 
;*     
;*           
;*$$  Close tag from ict or TSTK(tsti)   -- if tsg null just pop and dont test tag=ctag
;$$Q?  
;;     sic bad design ,esp for common sr in HGen, chg to $$Q?  D ct or =$$ct
ct(ict0) NEW:0 h,Q,tag,cls,clstag,ictstk  S Q="",id="",tag="div"
      S ict0=$G(ict0) I ict0'="" S Q=$$xict(ict0) I Q'="" D b^dv("ict err (ct punt)","ict0,ict") Goto Qct
      I $G(tsti)<1 S Q="99 stack empty tsti,TSTK?" D b^dv(Q,"tsti,TSTK,ict0,ict") Goto Qct
      S stkict=TSTK(tsti,"ict"),tag=TSTK(tsti,"tag"),tsti=tsti-1  ; ict  POP stack
      I ict0'="",ict0'=stkict DO  Goto Qct  ;
        .S Q="1?. Mismatched ict="_ict0_", stkict="_stkict
        .USE $P W:$X ! zwr TSTK  W !
        .;D b^dv("ct close ict stack sync err","ict0,ict,ictstk")
      S clstag=tag
      S h="</"_clstag_">"  ;usu div, occ other
      S Q=$$shg(h)
Qct    Q:$Q Q
      I Q'="" D bug^dv("ct sync close/stack Err ","Qict,ictstk,tag,cls,tsti,TSTK")  ;Q to caller D ct^
      Q  ; in case D ct^... No Error/Q (NEWed) returned  All ct should be $$
;*$$Q  ict : tag, id, cls    internal syntax check, expand . -> class=, # -> id=
xict(ict) S tag="div",id="",cls=""  NEW err S err=""
      I $G(ict)="" S err="1ot. Null arg tag" Q err
      I $E(ict)="." S cls=$P(ict,".",2,9),tag="div"
       I $E(ict)="#" S id=$P(ict,"#",2,9),tag="div"
      I $E(ict)?1A S tag=ict
      I ict?2.A1"."2.AN.e DO  ;
        .S tag=$P(ict,"."),cls=$P(ict,".",2,9)
      I ict?2.A1"#"2.AN.e DO  ;
        .S tag=$P(ict,"#"),id=$P(ict,"#",2)
      I cls[" "!(cls[";") S cls="'"_cls_"'"  ; wrap in quotes if embedded sp or colon
      Q err
      ;*
    ;RefBy: local, ^ktxHG*, others ?    This should be outside <html>, the first line of html file
    ;See alternatives in ^dvh?, 
DOCTYPE D Ssh("<!DOCTYPE html>")
        ;  D Ssh("<html lang=""en"">")  ; See label html
	Q
	;*
HD      D Ssh("<head>") D met
        D TI
        D csso	; css in <head or <head <link (devcss)
        D js
        D Ssh("</head>")
        Q
met	D Ssh("<meta http-equiv=""content-type"" content=""text/html; charset=UTF-8"">")
        D Ssh("<meta name=""viewport"" content=""width=device-width, initial-scale=1"">")
        I $G(TImo)["NoCache" DO  ;
          .D Ssh("<meta http-equiv=""Cache-Control"" content=""no-cache, no-store, must-revalidate"">")
	Q
TI	NEW title,t S title=$G(TItb)
          I title="" S t=$G(TI("title")) I t'="" S title=t
          I title="" S title="HGen"  ;Invalid html if absent or null
        D Ssh("<title>"),Ssh(title),Ssh("</title>")
        Q
;*  Write CS()  to external css fle  devcss        
;*  CSq(sq,sel)=val ->  hFcss  
;*     make it a TI("cssFil")  parameter of HGS but output css file later, after guts, from CS()
WCSS(devcss)    ; needs ext fle name, I $G(filCSS)'="";   rethink  OFW...
        I $G(devcss)="" Q "?devcss for css"

        ; CS(sq,sel)=  fully formed line  sel { prL }
        ;*$$Q  Write css to file  vs head/css ?   incomplete..., unnecessary, write when called.
        NEW Q S Q="" I $G(devcss)="" Q "?arg dev"
        S Q=$$OFW^devIO(devcss) I Q'="" Q Q
        USE devcss 
        S sq=0 F si=0:1 S sq=$O(CS(sq)) Q:sq=""  DO  ;
          .S sel="" F ei=0:1 S sel=$O(CS(sq,sel)) Q:sel=""  DO  ;
             ..S sep=CS(sq,sel) W:$X ! W sep,!
        S Q=$$CFW^devIO(devcss)
        Q Q
;*
csso	;write <link  inside <head  to ref ext css file if hFcss is set or in TI
        NEW Q D sEOL
        ;D b^dv("Log css0 ","devcss,CS")
        I $G(devcss)'="" DO   ; ext if devcss not null, link here, file later
          .S Q="",n=$L(devcss,"/"),cfn=$P(devcss,"/",n)
          .I $P(devcss,"/",n-1)="css/" S cfn="css/"_cfn
          .;D b^dv("Log devcss link","devcss,cfn,n")
          .D Ssh("<link rel='stylesheet' type='text/css' href='"_cfn_"'>")   ; rel <head<link 
        ; else write in <head as <style
        I $G(devcss)="" DO  
          .S h="<style> " D Ssh(h)  ; _EOL
          .S sq=0 F si=0:1 S sq=$O(CS(sq)) Q:sq=""  DO  ;
            ..S sel=0 F sj=0:1 S sel=$O(CS(sq,sel)) Q:sel=""  DO
              ...S h=CS(sq,sel) D Ssh(h)  ; _EOL
          .S h="</style>" D Ssh(h)  ; EOL_"</style>"
zb1     Q
;*
sEOL    S EOL=$C(12),EOF=$C(14) Q
;*
js	I $D(JS)'=11 Q
        D Ssh("<script>")
        NEW ji S ji="" F j0=0:1 S ji=$O(JS(ji)) Q:ji=""  DO
          .S J=$G(JS(ji)) D Ssh(J)
        D Ssh("/script>")
        Q
      ;*
BODs	D Ssh("<body>") 
        D HDR
        D NAV
        Q
BODe    I ($G(TImo)'["NoFt") D FT ;
        D Esh("</body>") Q
HDR	I $G(TIhd)'="" D Ssh("<h1>"_TIhd_"</h1>")
	I $G(TImo)["BraceLine" S h1=sp3_"{ " DO  
	  .D Ssh($$LNKh(" LOCAL/*","./"))
	  .S h1=h1_sp3_"} " D Ssh(h1)
	  .I $G(devlog)'="" D Ssh($$LNK(" Log",devlog)) D Ssh(sp3)
	  .I $G(deverr)'="" D Ssh($$LNK(" Errors ",deverr)) D Ssh(sp3)
	  .I $G(TIVL)'="" D WTIV
	Q
;*$$Q  to HT()
LINK(txt,href)  NEW Q,h S Q=""
        S h=$$LNKh($G(txt),$G(href))
          I $E(h,1,2)'="<a" S Q="?link" Q Q
        D sv(h)
        Q:$Q ""
        Q
;*$$Q    link <a...  Caller saves in H*()   
LNK(txt,href) S h=$$LNKh($G(txt),$G(href)) Q:'$Q   Q ""
;*    --sic $$ returns h (No errs/no cks)
LNKh(txt,href) NEW h,err  I $G(txt)="" S Q="txt? " Q Q
      I $G(href)="" S href="./"
      S h="<a href="_href_" >"_txt_"</a>"
      Q h
;* Doc Vars after HDR - debug mainly
;* val is num and unit  or other value and unit, np wsp between num & unit
;* val itictf should not contain wsp ?
;* No quotes should be necessary in head or external css ?
WTIV   NEW vn,vi,val
       F vi=1:1:$L(TIVL,",") S vn=$P(TIVL,",",vi)  I vn'="" DO
         .S val=$G(@vn)
         .I val="",$D(@vn)#2=0 S val=" is UNDEF."
         .;W:$X ! W vn,"='",val,"' ",!
         .;D Ssh("<h4>"_vn_"='"_val_"' </h4>")
         .D Ssh(vn_"='"_val_"' <br/>")
       Q
;*       
NAV	Q
;*  TIft
;RefBy: ^guHNgo
FT	S h2=$G(TIft) I h2="" S h2="^"_$T(+0)
	D Esh("<h3>"_$ZD($H," DDMONYYYY 24:60 ")_"  by "_h2_"</h3>")
	Q
;*
; Write HTS, HT() and HTE() to devw
;$$      fixed Arry names for now ?  simple h-strings, html, not separated tags and text 30mar20
;
;  Follows HGS^hgh -> HTS() and HGE^hgh -> HTE and guts to HT
;*$$Q     RefBy: HBD^suMa,  ^guNHgo   was ^hghWH
WH(devw) I $G(devw)="" D bug^dv Q "1arg"
      NEW Q,wi D sEOL
      S Q=$$OFW^devIO(devw) I Q'="" G Q
       ;
      USE devw 
      D WHTS  ;D b^dv("Log end WHTS","HTS")
      D WHT
      D WHTE
      S Q=$$CFM^devIO(devw)
Q     Q:$Q Q   Q  ;either D or $$
;*
WHTS   USE devw W:$X !  ; HTS() -> devx
      F wi=1:1:HTS W HTS(wi),!
      Q
;*      
WHT   USE devw NEW h W:$X !  ; HT() -> devx
      F wi=1:1:HT S h=HT(wi) DO  ;
        .I $E(h,$L(h))="\" W $E(h,1,$L(h)-1) Q
        .W h S $X=0 I $G(hghEOL) W !
      Q
;*      
WHTE  USE devw W:$X !  ;  HTE() -> devx
      F wi=1:1:HTE W HTE(wi),!
      Q

;
