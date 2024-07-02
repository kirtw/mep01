ppXIpt ;CKW/ESC i9mar24 umep./ rppar1/ ;2024-0309-05; Fudge PTx Data
;
;
;
top    KILL PTx S PTx=0
       D ^ppIMG ; pt1FL, pt2FL
       D LD
       Q
       ;       
;;pt1FL:Lev_PTx(pti)
;;pt2FL:gran,gnts,gnte_PTx(StkP,gnts)
       ;
LD     F I=1:1 S T=$T(PTx+I) Q:T=""  Q:T["***"  S L=$P(T,";;",2,99) DO
         .S pti=$P(L," "),PTx(pti)=pti,PTx=pti
         .S CL=$P(L," ",2,99)
         .F tki=1:1:5 S P=$P(CL,",",tki) DO  ;
            ..I grab=$P(P,":"),nspan=$P(P,":",2) S:'nspan nspan=1
            ..D SFL^kfm("grab,nspan",pt2FL) ; PTx(pti,tki)
       Q
;       
;*  pti  then cols/commas   :n is colspan
TKv  ;Swd. sp1. Vn. = Vn.  tki 1:1:5  or 6
;
PTx  ;Used to Fudge table contents follows
;;1  Swd.,sp1.,Vn.,=,Vn.
;;2  Scmd.:2,,eScmd
