TOIs	;CKW/ESC  i27Jan15  ; 20181005-99 ; Std S/R 
  ; in gmsa/  rTOI7/   cp ^dvs 23sep19  to remove dependency of TOI
;
;RefBy:  Many to ^dv still, 
  ;  No special mods init 23sep19
  ;
  ; Read File to Array	Call RF by Ref (devr)  or ^kas(devr) -> RF()
;RefBy: ^fr4TI1      mod $$ Err result  23sep19
;*$$  
RDF(devr)   NEW ri,X   ; : RF()
  I $D(RF)  D b^dv("RF() is not empty. I will Kill it:","devr")  KILL RF 
  S RF=0,devrU0=$I
  CLOSE devr ;debug
  OPEN devr:(readonly:exception="G ERO") USE devr:exception="G ERD"
  F ri=1:1 USE devr R X USE 0  DO:X[$C(13) X13  D:X[$C(9) X9 S RF(ri)=X,RF=ri
  CLOSE devr U $P
  I devrU0="" Q ""
  USE devrU0
  Q ""
ERD  CLOSE devr I $G(devrU0)'="" USE devrU0 KILL devrU0
  E  USE 0
  Q ""
ERO  W !!,"Error opening ",devr,! d b^dv("Open to Read","devr") 
  Q "Err Open"
;*  
X13 S X=$TR(X,$C(13)_$C(10),"") Q
X9 S X=$TR(X,$C(9)," ") Q
  ;*  Full FilePath   or simple name -> gtm start, ie p/   eg. km7r/ KA1/ p/
  ;* Chg to $$OFW  ret null ok, 1 Open Err, 2 Write err  kw 20feb18 (Lost my head)
OFW(devw)  I $G(devw)="" D b^dv("devw undef","devw,Fil,Fol,FBase")  Q
    CLOSE devw  ; debug
  OPEN devw:(newversion:exception="G EWO")
  USE devw:(exception="D EWW^"_$T(+0))
  Q:$Q "" Q  ;Hopefully compatible if no error !
  ;*
EWO	USE 0 D b^dv("Open File (EWO/OFW) Err","devw")  
  CLOSE devw USE $P
  Q:$Q "1-Err Opening File"  ;
  Q

EWW   S D=$I USE $P D ^dvsch,b^dv("USE Err, writing to File","devw")
  CLOSE devw USE $P
  Q:$Q "2-Err during write?"
  Q
;*
CF(devx) USE $P CLOSE devx
         Q
CFW(devw)  USE $P CLOSE devw
     W:$X ! W "Completed writing ",devw,!
     Q 
  ;
  ;* Set local fields/@vars -  @SFL null - Initialize
NFL(SFL,L2) I $G(SFL)="" D b^dv("NFL 1st FL null","SFL,L2") Q
  NEW G,FL,%vi,%vn
  I $G(L2)'="" S G=$P(L2,"_",2),FL=$P(SFL,"_",1)
  E  S G=$P(SFL,"_",2),FL=$P(SFL,"_") ;I G="" D b^dv("Net G null","FL,G,SFL,L2")  Q
  I FL="" D b^dv("Net FL null","FL,G,SFL,L2")  Q
  F %vi=1:1:$L(FL,",") S %vn=$P(FL,",",%vi) I %vn'="" S @(%vn)=""
  Q
;Save loc vars to MGbl via Super-FL-list
SFL(SFL,L2)  I $G(SFL)="" D bug^dv  Q
  NEW:1 RSZ,A,Rc,TRc,R2c,TR2c,R,FLn,L2n,G,FL,%vi,%vn,%val,%old
  I $G(L2)="" S L2=$P(SFL,"_",2)		; sic L@ bad choice vs L, L0, L2
  E  S L2=$P(L2,"_",2)  ;uses arg2 for _2 MGbl Ref
  zsh :A DO  ;
    .MERGE RSZ=A("S")  ;remove first subscr "S"
    .I $G(RSZ(1))'["SFL" B
    .S Rc=$G(RSZ(2))
    .S TRc="" I Rc["^" S TRc=$T(@Rc)
    .S R2c="",TR2c="" I Rc["FL" S R2c=$G(RSZ(3))
    .  I R2c["^" S R=Rc,Rc=R2c,R2c=R,RcTR2c=TRc,TRc=$T(@Rc)
    .S FLn=$P(TRc,"FL(",2),FLn=$P(FLn,")"),L2n=$P(FLn,",",2),FLn=$P(FLn,",")
    .;D ^dv("SFL Log:","Rc,TRc,R2c,TR2c,FLn,L2n,SFL,L2") B
    .I FLn'="",Rc'="" S RLL(FLn,Rc)=TRc  ; first crack
  S G=L2,FL=$P(SFL,"_") I G="" D b^dv("Bug No _2 G","G,FL,SFL,L2")  Q
  I FL="" D b^dv("Bug No _1 FL","G,FL,SFL,L2")  Q
  F %vi=1:1:$L(FL,",") S %vn=$P(FL,",",%vi) DO  ;
    .I %vn="" Q  ; ignore and go on...
    .S %val=$G(@%vn) I %val'="" S @G@(%vn)=%val Q
    .I $D(@%vn)#2=0 D errFL("Undef Var "_%vn) Q  ; Var %vn is UNDEF Usu not, NFL^dvs ?
    .S %old=$G(@G@(%vn)) I %old'="" KILL @G@(%vn)  ; Kill prior value ?
zqs  Q  ; zb target

;Get Loc Vars via Super-FL-List ether in $P_SFL (no G2), G2, or $P_2 of G2
;
GFL(SFL,G2)  I $G(SFL)="" d b^db("GFL null 1st arg","SFL,G2")  Q
  NEW G,FL,vi,vn
  I $G(G2)'="" S:G2["_" G2=$P(G2,"_",2)
  S G=$P(SFL,"_",2),FL=$P(SFL,"_") I G="" S G=G2 I G="" D errFL("No MGbl Given")  Q
  I FL="" B  Q
  F vi=1:1:$L(FL,",") S vn=$P(FL,",",vi) I vn'="" S @vn=$G(@G@(vn))
  Q
;eg.  D GFL("lnfun",LineFL)  ; uses _2 of LineFL but list lnfun only
  ;*
errFL(M) NEW D S D=$I USE 0 W:$X ! W "*FL Error ",M,!
    D ^dvsch D b^dv(M,"D")
    Q
  ;*  Formatting  TOI
  ;
	;Replace all dbl spaces (or more) with single, and remove starting/ending
DSP(X)	NEW i F i=0:1 Q:X'["  "  S X=$P(X,"  ")_" "_$P(X,"  ",2,9999)
	Q $$TSP(X)
	; Remove start and end spaces (only)
TSP(X)	NEW i S X=$TR(X,$C(9)_$C(10)_$C(13),"   ")  ;replace tab,lf,cr with space
	I $E($G(X))=" " F i=1:1:$L(X) I $E(X,i)'=" " S X=$E(X,i,999) Q
	I $E(X,$L(X))=" " F i=$L(X):-1:1 I $E(X,i)'=" " S X=$E(X,1,i) Q
	I X=" " S X=""  ; Funny case all spaces  vs end i=0 second line ?
	Q X
;*$$ Actually DSP already does both calls TSP in 2nd line	
LTDSPtb(X) NEW i 
        S X=$TR(X,$C(9)_$C(10)_$C(13),"   ")  ;replace tab,lf,cr with space
        F i=0:1 Q:X'["  "  S X=$P(X,"  ")_" "_$P(X,"  ",2,9999)
	; Remove start and end spaces (only)
	I $E($G(X))=" " F i=1:1:$L(X) I $E(X,i)'=" " S X=$E(X,i,999) Q
	I $E(X,$L(X))=" " F i=$L(X):-1:1 I $E(X,i)'=" " S X=$E(X,1,i) Q
	I X=" " S X=""  ; Funny case all spaces  vs end i=0 second line ?
	Q X	
  ;*  Case & Canonic
LC(X) Q $TR(X,"ABCDEFGHIJKLMNOPQRSTUVWXYZ","abcdefghijklmnopqrstuvwxyz")
UC(X) Q $TR(X,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
UC1(X) Q $$UC($E(X))_$$LC($E(X,2,9999))   ; Cap 1st, rest LC
  ;
can(X) Q $$LC(X)
  ;*
ER(M)	NEW d S d=$I USE 0 W:$X ! W "ER ^",$T(+0),"- ",$G(M),! USE d Q
	Q  ;* safety