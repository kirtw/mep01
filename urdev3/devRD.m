devRD(devrd,jsin,ARna)  ;CKW/ESC  i28dev919 gmsa/ rd2io/ ;20200321-92 ; Read File to Array, def RDa()
;*$$~Q    in gmsa/  rd2io/  ^dev*
  ;
  ;RefBy:many
   I $G(devrd)="" D bug^dv Q "9arg?devrd"
   I $G(ARna)="" S ARna="RDa"
   D inJ
A  I $G(@ARna)'=""  KILL @ARna 
   S @ARna=0,@ARna@(0,"devrd")=devrd
   NEW Q,rdi,Lmax  S Q="?devRD",Lmax=""
       CLOSE devrd  ; safety for debugging
       OPEN devrd:(readonly:exception="G ofrE1^"_$T(+0))  ; Flag OFR 
       USE devrd:(rewind:exception="G ofrE2^"_$T(+0))
       F rdi=1:1 USE devrd R X S ZEOF=$ZEOF  USE $P Q:ZEOF  S @ARna@(rdi)=X,@ARna=rdi
       S Q=""
ofrQ   USE $P CLOSE devrd 
       S @ARna@(0,"Lmax")=Lmax
       S @ARna@(0,"Q")=Q
       Q:$Q Q
       Q   ; This Quit for stray D ^devRD  vs $$ $Q
;*
ofrE1 S Q="Err Opening file- " D b^dv(Q,"devrd,exc") 
      G ofrQ
ofrE2 I $ZEOF S Q="" G ofrQ
      S Q="Err Reading file- :" D b^dv(Q,"devrd")
      G ofrQ
;*
;* Mode vars def or from jsin
inJ  S Lmax=""
     ; eg jsin="{ARna=RF,Lmax=120}  ; sic Lmax is output, not input...
     I $G(jsin)'="" D jv(jsin) DO
       .I jsin["Lmax=" S x=$P(jsin,"Lmax=",2),x=$P(x,","),x=$P(x,"}")    I x S Lmax=+x
       .I jsin["ARna=" S x=$P(jsin,"ARna=",2),x=$P(x,","),x=$P(x,"}")  I x'="" S ARna=x
     Q
;*  convert jsin to vars
jv(jsin,FL)  I $G(FL)="" D bug^dv  Q  ;FL is list allowed to S @vn
     BREAK  ; no code yet,, see inJ
     Q ""
;*
;*    * * * * *  Tests
;*  RefBy:  Menu ^devTMenu  trd.
TES   S Q=$$T  USE $P W:$X ! W "Tests on ^devRD- "
      I Q="" W "Passed.",!
      E  W " Failed x",$G(Qn),"  ",Q,!
      Q
;*$$
T(Q1)   S Qn=0 KILL (Qn) S RT=0
    S devt="~/km6a/gmfd/dbg/abc.txt"
    S Q=$$^devRD(devt,,"RT")
      I Q'="" D SE^devTs("devRD-1",Q,"devt,Q")
      I $D(RT)'=11 D SE^devTs("devRD-2RT",Q,"devt,Q")
      I $G(RT(3))'["tdu." D SE^devTs("devRD-3txt",Q,"devt,Q")
    ;
    Q Qn
      
    
