ep4Gpt ;CKW/ESC i28apr23 umep./ rmePT1/ ;20230428-14;Gen Demo HG Data PT(), Pcs()
;    from first part of ^ep2HGpt  extracted
;
;
top   D I0,IHT  ;create table of data
      D ^ep2HGpt  ; PT(), Pcs() : HGen
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
