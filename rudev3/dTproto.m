dTproto(TRou,Tlab,inL,outL) ;CKW/ESC  i1mar19  ; 20190301-55 ; Prototype Test Utility
  ; in gmsa/  rudev/   -- Separate later ?
  ;
  ;RefBy:  ^fdMenu  $test  td.
A   D Sat  zwr ^dtTRef
    D X S tid=10
    D S1(tid)
      zwr ^dtTin
    S Q=$$Test(tid) D Res("First Test",Q)
      zwr ^dtTout
    Q
;*
Res(id,Q) W:$X ! W "Test:",id," - " 
    I Q="" W " Passed.",!
    E  W " Failed: ",Q,!
    Q
;*  One test profile
X   S TRou="devIO",Tlab="rRD"
    S DOI="S Q=$$rRD^devIO(rFil,rFol)"
    S inL="rFil,rFol,RD"
    S inV="@Filr1,@Folr1,0"
    S outL="Q,devr,rFil,rFol,rBase"
    S outV=",@devr1,@Filr1,@Folr1,@Base"
    Q

;*  Ref set of vars - ref by @Filr1   in inV, outV ^dtTRef(vn)=val
Sat  KILL ^dtTRef
     D SV("devr1=/home/kw/km6a/gmfd/dbg/abc.txt")
     D SV("Filr1=abc.txt")
     D SV("Folr1=dbg/")
     D SV("Base=/home/kw/km6a/")
     D SV("devw1=/home/kw/km6a/gmfd/dbg/write-w-file.txt")
     Q
SV(veqv)
     S vn=$P(veqv,"="),val=$P(veqv,"=",2,9)
     S ^dtTRef(vn)=val
     Q
;* Save vars in MGbl to use  inL,inV,outL,outV
S1(tid)   KILL ^dtTin(tid),^dtTout(tid) D II
     F Lv="inL","inV" S ^dtTin(tid,Lv)=@Lv
     F Lv="outL","outV" S ^dtTin(tid,Lv)=@Lv
     Q
;*
II   S L="inL,outL,inV,outV"  Q
;*
;*$$   DOI,TRou,Tlab ^dtTin(tid,  : Q=$$, ^dtTout(tid,tver,
Test(tid,tver)   I $G(tver)="" S tver=1
       S KL="tid,tver,DOI,TRou,Tlab" F vi=1:1:$L(KL,",") S vn=$P(KL,",",vi),^dtT(0,vn)=@vn
       KILL  D II
       S KL="tid,tver,DOI,TRou,Tlab" F vi=1:1:$L(KL,",") S vn=$P(KL,",",vi),@vn=^dtT(0,vn)
       S inL=^dtTin(tid,"inL"),inV=^dtTin(tid,"inV")
       F vi=1:1:$L(inL,",") DO   ; Create vars for call
         .S vni=$P(inL,",",vi) 
         .S vali=$P(inV,",",vi)
         .I $E(vali)="@" DO  ;
            ..S vnR=$P(vali,"@",2)
            ..S vali=$G(^dtTRef(vnR))
            ..I vali="" I $D(^dtTRef(vnR))=0 S Qv="Undef ref var "_vnR Q
         .S @vni=vali  ; could be null
         .;D ^dv("Log in var ","vi,vni,vali,vnR")
         .S @vni=vali
teD    ;D ^dv("Log ","DOI,TRou,Tlab,tid")
       ; Having created vars, DO it (Xecute)
       USE $P W:$X ! W "Xecuting ",DOI,!
       ;zwr  W !!
DOI    X DOI  ; DOI is a MUMPS Cmd, eg S Q=$$rRD^devIO(@inL))
       ;  Now test results
       USE $P W !,"RD()=",!  zwr RD  W !!
teO    S Qn=0,Qx="" D II
       ;F li=1:1:$L(L,",") S Lv=$P(L,",",li),@Lv=^dtT(1,0,Lv)
       S outL=^dtTin(tid,"outL"),outV=^dtTin(tid,"outV")       
       F vi=1:1:$L(outL,",") DO  I Qt'="" S Qn=Qn+1,Qx=Qx_Qt_","
         .S vno=$P(outL,",",vi)
         .S oval=$G(@vno) I oval="" S oval="D"_$D(@vno)
         .S ^dtTout(tid,tver,vn)=oval
         .S val=$P(outV,",",vi)
         .I $E(val)="@" DO  ;
            ..S vl=$P(val,"@",2)
            ..I $D(^dtT(1,vl))=0 S Qv="Undef ref "_vl Q
            ..S val=$G(^dtT(1,vl))
teT      .; Compare expected with output vars, @vno
         .I $D(@vno)'=1 S Qv="Undef-"_vno Q
         .S vo=$G(@vno)    
         .I vo=val S Qt="" Q
         .I vo="" S Qt="Null-"_vno Q
         .S Qt="NEQ-"_vno
       Q Qt
;*
