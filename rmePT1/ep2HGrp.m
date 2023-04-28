ep2HGrp ;CKW/ESC i14dec22 umbr./ rmep2/ ;20221214-64;HGen Reverse Parse Tree Array
;
;
;  PT(xi,yi)  Table
;  xi cols  0:1:nIns
;  yi rows  state table, ?SSg 
top   D I0  ; Init, ?Ins if not def
      D IHT  ;create table of data, PT(), Pcs() aux colspan
      ;D IT ; : Ttok ? not necessary ?
      D HG
      Q
;*
I0    D ^epaIMG  ;
      I $G(Ins)="" D IIn
      S yi=1
      Q
;*  : Ins, INc(IPc)=C
IIn   S Ins="1+(2*3+4)"
      KILL INc F i=1:1:$L(Ins) S C=$E(Ins,i),INc(i)=C
      Q
;* Pseudo Grk part 2, Terminals, ?OBS vs GRk      
IT    KILL Ttok S V="Cdig:0123456789,Cop:(,Ccp:),Psum:+-,Pfac:*/"
      F vi=1:1:$L(V,",") S P=$P(V,",",vi),runa=$P(P,":"),CL=$P(P,":",2) DO  ;
        .F ci=1:1:$L(CL) S c=$E(CL,ci),Tokx(c)=runa
      Q
;*
IHT   KILL PT,Pcs S eol=$C(13)
      S nIns=$L(Ins)
      F xi=1:1:nIns S PT(.1,xi)=xi,PT(999,xi)=$E(Ins,xi)
      ;
      S yi=1,xi=1 D getI(78),SPT(yi,xi)
      
      S yi=2,xi=1    D getI(1),SPT(yi,xi) D b^dv("Log PT","yi,xi,P,PT")
      S xi=2         D getI(15),SPT(yi,xi) D b^dv("Log PT","yi,xi,P,PT")     
      S xi=3         D getI(77),SPT(yi,xi) D b^dv("Log PT","yi,xi,P,PT")

      S yi=3,xi=1 D getI(78),SPT(yi,xi)
      S xi=2 D getI(78),SPT(yi,xi)
      S xi=3 D getI(78),SPT(yi,xi)
      
      D getI(78),SPT(4,1)
      D getI(78),SPT(4,1)
      D getI(78),SPT(4,1)
      Q
;*      
;* ? expand ruLst      
      S IP=IPs F rj=1:1:$L(ruLst,",") DO  ;
        .S tok=$P(ruLst,",",rj)
        .S SSq=$G(XR(IP,tok))
        .S QY(yi+1,SSq)=IP
      Q
FLg1  ;;grFL:runa,ruab,ruty,ruLst,nLst,tokCL,nLCL,Lna,rde_GRk(ruid)
FLi1  ;;itemFL:runa,ruab,ruid,ikey,svSSq,IPs,IPe,dot,ruLst,tokR1,tokTy,ruby,frm_SCF(Si,Sj)
;* SSq, Ins, SCF(), itemFL  :  Item locals
getI(itm)  DO  ;
        .I itm["." S Si=$P(itm,"."),Sj=$P(itm,".",2),SS=Si_"."_Sj,SSq=$G(XSQ(SS)) Q
        .I itm S SSq=itm DO  Q
           ..S SS=$G(XSS(SSq))
           ..S Si=$P(SS,"."),Sj=$P(SS,".",2)           
           ..I SS'["." D b^dv("Err itm SSq","itm,SSq,SS")  ;Set Si,Sj anyway
        .D b^dv("Err itm syntax","itm")
      ;
      I 'Si!'Sj D bug^dv Q
      D GFL^jfm(itemFL) ; Si,Sj, SCF(...
      S IC=$E(Ins,IPs,IPe) I IC'="" S IC=" {"_IC_"}"
      Q
;*  @itemGL : PT(yi,xi), Pcs(yi,xi)
SPT(yi,xi)
      S xi=IPs,colspan=IPe-IPs
      S P=SSq_") "_ruab_" "_IC_"    "_$G(ruLst) I colspan>1 S Pcs(yi,xi)=colspan
      S PT(yi,xi)=P
      Q
;*
blank(y0,N)
      F yi=y0:1:y0+N S PT(yi,0)=yi
      Q
;*
HG    S Fil="RPT.2.html" D ^devIB ; : PB
      S devh=PB_"dmep/"_Fil
      D Init^hgh    S hghEOL=1
      D Hcss
      S TIft="^"_$T(+0)
      ;
      D HGS^hgh
      D guts
      D HGE^hgh
      ;
      D WH^hgh(devh)
      Q
;*  PT
guts  ;
      D ot^hgh("pre"),ot^hgh("table")
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
      D ct^hgh("table"),ct^hgh("pre")
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
