dzRD1  ;CKW/ESC i21aug22 gmsa./ rzro3/ ;20220821-20;Quickie zro construct exercise, PBL,GBL : zro
;No dependencies, can't trust $zro yet
;  was ^madev, ^dzmadev, ...
;
;Note rdix is replacement name for rdid (from rdir with op ~i)
;
top    
       D RD1  ; RIX(rdix,    RDxg(
       D RD2  ; RIG(rdgp,    RDxg(
       Q
;*
ZRO1   S PBL="rcfg,ra1" 
       S GBL="rzro3,rdv2" 
       S MBL="rbrzm1" 
       D Bldzro
       USE $P W !!,"zro:",zro,!!!
       Q
;*  PBL, GBL, MBL  : -> zro
Bldzro S zrix="umad"
       S kwsys="km3a"
       S LUser="kw"
       ;
       S MIB=$ZTRNLNM("PWD")  ; current dir on mumps start
       S MXB=$ZTRNLNM("ydb_dist")  ; gtmy, symlink to ydb vers
       S zroi=$ZTRNLNM("ydb_routines")  ; Mrou path list $zro
       ;  Don't ref $zro or will get crash if errors, frustrating
       S SBi=$ZTRNLNM("SB")
       S PBi=$ZTRNLNM("PB")
       S SB="/home/"_LUser_"/"_kwsys_"/"
       S PB=SB_zrix_"/"
       ;
       S zro=MXB_" "  ; source and obj, existing, both in $ydb_dist  itself
            ;don't delete *.o and don't compile   -> oi=1,si=1
       S zro=zro_" o( "
       D AR(PBL)
       S zro=zro_") ou( "
       D AR(GBL,"../gmsa/")
       D AR(MBL,"../gmma/")
       S zro=zro_" )"       
       ;S zro=zro_" "_MXB_"/libyottadb.so "_MXB_"/libyottadbutil.so"  ; GDE.o is in ydb_dist
       Q
;*  
AR(RL,RB) S RB=$G(RB)
       F li=1:1:$L(RL,",") S rd=$P(RL,",",li)  S zro=zro_RB_rd_" "
       Q
;*
RD1   S MIB=$ZTRNLNM("PWD")  ; Rel base
      S Fil="rdir-ll.txt",B="/home/kw/km3a/umad/dixd/"
      S devR=B_Fil
      D RDR ; devR : RX(ri)
      S BB=-1,Burl="?"
      KILL RIX,RDxg
      F ri=1:1:RX S L=$G(RX(ri)) DO  ;
        .I L="" Q
        .I $E(L)="#" Q
        .I $E(L,1,2)="//" D HD Q
        .D LN
      CLOSE devR USE $P
      ;
      Q
;* L : BB, Burl    // header util gp line
HD    S L1=$E(L,3,9999)
      S BB=$P(L1," "),Burl=$P(L1," ",2,99)
      I $E(Burl,$L(Burl))'="/" B:$L(Burl,"/")'=2  S Burl=Burl_"/"
      Q
;*  L  is ll line for folder rdir
LN    S nsp=$L(L," "),rdir=$P(L," ",nsp)
      I $E(L)'="d"  D b^dv("Directory type line","L,nsp,rdir")
      I $E(rdir,$L(rdir))'="/" D b^dv("Error rdir","rdir,L1,L0,ri") Q
      S nsl=$L(rdir,"/") 
         I nsl'=2 D b^dv("Error rdir ","rdir,ri,L0,L1,BB,Burl") Q
      D rdix ; rdir : rdix
      S RIX(rdix,"rdir")=rdir
      S RIX(rdix,"BB")=BB
      S RIX(rdix,"Burl")=Burl
      D RDmeta
      I meta'="" S RIX(rdix,"meta")=meta
      Q
;*  rdir : rdix      
rdix  S rdix=rdir
      I $D(RIX(rdix)) F i=1:1 S rdix=rdir_"~"_i Q:$D(RIX(rdix))=0  I i=99 BREAK Q
      Q
;* FInd file a-meta-gp-semver.txt
RDmeta  ;
      S meta=""
      S Fil="a-meta-*",src=Burl_rdir_"/"_Fil
      S mfn=$ZSEARCH(src) 
      D b^dv("Log mate ","mfn,Fil,src,rdix")
        I mfn="" Q  ;just didnt find a-meta-  file in rdir
      S meta=mfn
      S mfn=$P(mfn,".txt")
      I mfn'["-" D b^dv("Err mfn","mfn,ri") Q
      S rdgp=$P(mfn,"-",3),rver=$P(mfn,"-",4)
      I $L(rver,".")=3,rdgp'="" S RDxg(rdgp,rver)=rdix
      Q
;*      
RD2   ;
      S MIB=$ZTRNLNM("PWD")  ; Rel base
      S Fil="rdir-gp-gpde.txt",B="/home/kw/km3a/umad/dixd/"
      S devR=B_Fil
      D RDR  ; devR : RX(ri)
      KILL RIG
      F ri=1:1:RX S L=$G(RX(ri)) DO  ;
        .I L="" Q
        .I $E(L)="#" Q
        .I $E(L,1,2)="//" D HD2 Q
        .D LN2
      CLOSE devR USE $P
      Q
;*
;* L : BB, Burl    // header util gp line
HD2    S L1=$E(L,3,9999)
      S BB=$P(L1," "),Burl=$P(L1," ",2,99)
      I $E(Burl,$L(Burl))'="/" B:$L(Burl,"/")'=2  S Burl=Burl_"/"
      Q
;*
LN2   S rdgp=$P(L," "),rdgde=$P(L," ",2,999),rdL=""
      I rdgde["{" S rdL=$P(rdgde,"{",2),rdL=$P(rdL,"}")
      S RIG(rdgp,"rdgde")=rdgde
      I rdL'="" S RIG(rdgp,"rdL")=rdL
      Q
;*  devR : RX(ri)
RDR    ;
       CLOSE devR  ; safety/harmless
       OPEN devR:(readonly)  ; OFR^devIO    ;Error on exception
       USE devR:(rewind)  
      KILL RX S RX=0
      F ri=1:1 USE devR R X Q:X["***"  USE $P S RX(ri)=X,RX=ri
      Q
;*  Remove Lead & trailing space       
TSP(X) ;
      Q X
