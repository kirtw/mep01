h4ss  ;CKW/ESC  i15apr20 gmsa/ rhgen4b/ ; 20200415-93 ; Set CS() for css in <head
;
;
   BREAK  H  ; No top for now
;
;  Only refs by ^hgh, internal module only, ir S(sel,prL)  even via ^hgh
;
;* sel is #id, .class or maybe tag no prefix
;* pvL is _ list of prop:val pairs, opt end ea with ;
;*$$Q  selector (.id, #class tag,  or combinations)  Save properties rule, add to h2 for now ala $$sc
S(sel,prL) I $G(EOL)="" S EOL=$C(12),EOF=$C(14)
     NEW:0 Q,ty,d,si2,h2 S h2="",Q=""
     S ty="tag" ; { tag, id, class, complex }
     S sel=$G(sel)
     I $E(sel)="#" S ty="id"
     I $E(sel)="." S ty="class"
     I ty="id" S h2=h2_" "_sel_" { "   ; id has # prefix
     I ty="class" S h2=h2_" "_sel_" { "  ; dot prefix class
     I ty="tag" S h2=h2_" "_sel_" { "   ; tag no prefix
     D propL(prL)  ; h2 : h2'
     S HCS=HCS+1,HCS(HCS)=h2
     I Q'="" Q:$Q Q
     Q:$Q "" Q
;*
;* h2 : h2' One rule, one line, one set of braces, mult prop in space list, term semicolon
;*  property list name:value pairs, space or _ list    _ when single quotes wrap embedded spaces
propL(peqL)     
     S nsc=$L(peqL,";")
     I peqL["_" S peqL=$TR(peqL,"_",";")  ; Kludge convert _ to ;  may be double
     I peqL'="" F si2=1:1:$L(peqL,";") S pv=$P(peqL,";",si2) I pv'="" DO  ;
       .I pv="" B  Q  ; readability spaces ok  --handled before
       .I pv["=" S e2=$P(pv,"=",2,9),e1=$P(pv,"=") D b^dv("Err use colon not equal for css source","pv")
       .E  I pv[":" S e2=$P(pv,":",2,9),e1=$P(pv,":") ;D b^dv("Log pv","pv,e1,e2")
       .E  S e1="",e2=pv  ;D b^dv("fmt not = or :","pv,peqL")
       .I e1="" S h2=h2_e2_"; " ; D b^dv("css fmt err","e1,e2,pv,si2,peqL")
       .I e1'=""  DO  ;  equal or colon  converted to colon here
         ..;I e2'["'" S e2="'"_e2_"'; "  ; force quotes ?  vs embedded sp, ; , etc. ?
         ..S h2=h2_e1_": "_e2_";  "
       ;I h2["'" D ^dv("Log occ of sgl quotes here","h2,HCS")
     S h2=$TR(h2,"'","""")  ; strip sgl quotes ?  vs convert to db ,"""")
     S h2=h2_" } "   ;  vs escape char slash inhbiting EOL ' }"_EOL'  ; Doesnt like / escape EOL      "_EOL    
     Q
;*
