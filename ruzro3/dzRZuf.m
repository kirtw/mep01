dzRZuf(zrid,VL);CKW/ESC i30dec22 gmsa./rzro3/ ;20221230-29;Read czro from 0uzro./ dmpjzro
; into ^ZWZ(zrid  selective vn per VL (others unchanged)
; See gmsa./dmdk/ 
; Returns  ^ZWZ(zrid,  and zVL list of fields ?  Merged 
;*  mpj : czro , opt if zrid ^ZWZ(zrid) in this/caller, mbr mGbl g/
top   NEW Q S Q="" I $G(zrid)="" S Q="arg zrid" D bug^dv Q
      I $D(^ZWZ(zrid))=0 ;S Q="^ZWZ(zrid, UNDEF" D bug^dv Q  ;might be first --
      NEW L,vi,vn,val,ri,dh,d12 ; WZ() is not returned, already locals and ^ZWZ
      NEW:0 RZ,VNf,VNr
      KILL VNf,VNr 
      S VL=$G(VL)
      F vi=1:1:$L(VL,",") S vn=$P(VL,",",vi) I vn'="" DO  ;
         .S VNr(vn)=vi ;flag for below
         .KILL ^ZWZ(zrid,vn)  ;In case not in devuz, dont leave stray/prior
         .S @vn=""  ;ditto locals, def but null
      D III^dzWZuf  ;  zrid : devuz, dh, d12 
      S Q=$$OFR(devuz,"RZ") 
         I Q'="" D b^dv("Err reading czro file","czro,zrid,zridA,devuz") Q
      F ri=1:1:RZ S L=$G(RZ(ri)) I L'="" DO  ;
        .I $E(L)="#" Q
        .I L[" #" S L=$P(L," #")
        .I L[":" S vn=$P(L,":"),val=$P(L,":",2) I vn'="" S VNf(vn)=val
      ; All vn: returned here in VNf(vn) - not filtered by VL yet
      I '$D(VNf) S Q="No fields returned."
      I $D(VNf) DO  ;
         .S vn=""
         .F  S vn=$O(VNf(vn)) Q:vn=""  DO  
            ..S val=VNf(vn)
            ..I $G(VNr(vn)) DO  ;
                ...S ^ZWZ(zrid,vn)=val  ; Filtered, local and ^ZWZ(zrid
                ...S @vn=val
      Q:$Q Q  Q:Q=""  D b^dv("Err ^"_$T(+0),"Q,zrid") Q      
;*
;*   * * * * *
;*  Avoid rdir Dependency on rdevIO/   copy local OFR 30dec22
;*  OPEN File AND Read if Array given  --- Confusing, Looping ?  $D and Call by Ref
OFR(devrr,RAo) NEW Q  S Q="?OFR" 
       I $G(devrr)="" S Q="Bug devrr" D b^dv(Q,"devrr") Goto ofrQ
       CLOSE devrr  ; safety for debugging
       OPEN devrr:(readonly:exception="G ofrE1^"_$T(+0))
       USE devrr:(rewind:exception="G ofrE2^"_$T(+0))
       S Q=""
ofrQ   I Q="",$G(RAo)'="" DO  ;
         .KILL @RAo S @RAo=0
         .F ri=1:1 USE devrr R X S ZEOF=$ZEOF USE $P Q:ZEOF  Q:X=""  S @RAo@(ri)=X,@RAo=ri
         .;D b^dv("Log fin ZEOF","ZEOF,ri,X")
       Q:$Q Q   Q 
;
       D OFR^devIO  ; non-executable pseudo ref - link copy (avoid dependency)
;*        
;*
ofrE1 S Q="Err Opening file- " D b^dv(Q,"devrr,exc") Goto ofrQ
ofrE2 S Q="Err Reading file- :" D b^dv(Q,"devrr,ZEOF,ri,X") Goto ofrQ
;*
DSP

