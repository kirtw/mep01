TOIa(TOIsyn,tsidp)   ;CKW/ESC $$ i27may16  ; 20191004-75 ; Init/Compile TOI Process
  ;  in gmsa/  rTOI7/      10oct19, 8aug19    
  ;  from gmsa/  rTOI3ucal/
  ;RefBy:  KAcf/ rcash/...  Dev
  ;
  ;    Some uCal-specific Kludges, commented [uCal
  ;
toiFL ;;sTFL,tFL,VNmode,WQP,dictL,vndt,d8vn,vqlst,Cpx,Csx,cdL,wtL,cTS,ctxde_^TG(tsid)
  	;  TOIsyn is Var List and _2 destination Compile to ^TG(tsid)
	;     with coded prefix and/or suffix punct to interpret lines
	NEW Q,T,toiFL,dtFL S Q=""
	I $G(tsidp)="" S tsidp=$G(^TG(0,"tsidCur")) I tsidp="" D bug^dv Q "9-No-tsid in"
          S tsid=tsidp  ; tsid is sys var, tsidp is arrg/new
        D ^TOIimg  ; toiFL, dtFL
         ;  removed  ,pL,pvL,psL,vnL  3oct19
        D III  ; Init for process
        S sTFL=TOIsyn,cTS=$ZD($H)
        U $P W:$X ! W "^TOIa Compiling '",tsid,"'  from -",!
           W "   '",sTFL,"' ",!
        ;
        S ^TG(0,"tsidCur")=tsid
	D XTG(TOIsyn)  ;  : ^TG(tsid,
	I $G(VNmode)="" S VNmode="L"
	I $E(tFL)'="," S Q="Err tFL" Goto Qbug
	S tFL=$E(tFL,2,9999)  ;Remove Init comma
	D SFL^dvs(toiFL) ; tsid, @toiFL : ^TG(tsid=tsidp) updated vars
	;KILL @$P(toiFL,"_"),@$P(dtFL,"_")  ; Sic  temp cleanup  vs NFL^
	Goto Q
;*
III     S (Cpx,Csx)="",tFL=""  ;Accumulate all vn in tFL
        KILL ^TG(tsid)
        D NFL^TOIs(toiFL),NFL^TOIs(dtFL)  ; variant No G test/break
        D ITG^TOIimg  ; Static parts of ^TG TOIa support
        D ITVN  ; Apx,Asx, patL, pa ^TG(0,
        Q
;*
XTG(TSL) I $G(TSL)="" D bug^dv Q
        NEW vn,G,TL,wj,pvn,px,sx,ty,tys,vn,an,val,Vsq
        S G=$P(TSL,"_",2),TL=$P(TSL,"_"),Vsq=0
          ; D b^dv("Log XTG","TSL,TL")
        F wj=1:1:$L(TL,",") S pvn=$P(TL,",",wj) DO
t1        .S px=$E(pvn) I px?1P S Q="" DO  Q:Q'=""
             ..S ty=$G(^TG(0,"PTYpx",px))  ;vs Apx
             .. I ty="" D b^dv("Unregis px punct","px,pvn,wj,TSL") Q
             ..S vn=$E(pvn,2,99),Qv=$$vvn(vn) ; vn', vty
             ..  I Qv'="" S ty="" Q
             ..S ^TG(tsid,"PX",px)=vn
             ..S Cpx=Cpx_px,Q=1
t2        .S sx=$E(pvn,$L(pvn)),Q="" I sx?1P DO   Q:Q ; Q success, done with pvn
             ..;S ty=$G(^TG(0,"PTYsx",sx)) ; vs Asx
             ..; I ty="" D b^dv("Unregis sx punct","sx,pvn,wj,TSL") Q
             ..I Asx'[sx D b^dv("Unregis sx punct","sx,Asx,pvn,wj,TSL") Q             
             .. S vn=$E(pvn,1,$L(pvn)-1),Qv=$$vvn(vn) I Qv'="" Q
             ..S ^TG(tsid,"SX",sx)=vn,Csx=Csx_sx,Q=1
t3b        .I pvn["=" S Q="" DO  Q:Q  ; VNmode, ...
             ..S vn=$P(pvn,"="),val=$P(pvn,"=",2,9)
             ..I vn="" D bug^dv Q  ; =prefix in sTFL ?
             ..S Qv=$$vvn(vn) I Qv'="" D bug^dv Q  ;already b^dv
             ..S x=$G(^TG(0,"AN",vn)) I x="" D b^dv("Unrecog Var=","an,wj,TSL") Q
             ..  ; sic this is same fn, diff method ???
             ..S F=0 F fi=1:1:$L(toiFL,",") I $P(toiFL,",",fi)=vn S F=1 Q
             ..I 'F D b^dv(" Var an not in toiFL?","an,toiFL,wj,TSL") Q
             ..S ^TG(tsid,"VEQ",vn)=val,Q=1  ; @vn=val by TOIp  fixed value
t4        .I pvn?1.L.2N S Q="" DO  Q:Q'=""  ; simple vn, assign in order wds left, always Quits
             ..S vn=pvn,Qv=$$vvn(vn) I Qv'="" Q  ; b^dv in vvn
             ..S Vsq=Vsq+1,^TG(tsid,"VQ",Vsq)=vn,vqlst=vn,wklst=wj,Q=1  ;number (Vsq) vs ty
t5        .I pvn[":" DO   S pvn=$TR(pvn,":","/")      ;Dup syntax   Kludge
                ..;D b^dv("Log pvn colon to /","pvn")
          .I pvn["/" S Q="" DO  Q:Q'=""   ;; special var after / or : eg d12 in 
             ..S vnty=$P(pvn,"/",2) I vnty="" D b^dv("End sx slash / not suffix","pvn,vnty,wj,TL") Q  ;end / not sx ?
             ..S vntyL="dts,d12,d8,d8s,nalf,nafl,n,int,num,dol,de,email,tel,url,tty"  ; sic config here vs ITVN
             ..I ","_vntyL_","'[(","_$P(vnty,".")_",") D b^dv("Err allowed /var ","vnty,vntyL,wj,TL") Q
             ..S vn=$P(pvn,"/"),Qv=$$vvn(vn)
             ..  I Qv'="" D b^dv("Err in : or / vn ?","vnty,vntyL,vn,Q,wj,TL") Q
             ..I vnty="d12"!(vnty="dts")!(vnty["d8") S vndt=1  ; vndt is general date flag 1/0null was vnd12
             ..S vnty0=$G(^TG(tsid,"VCU",vnty)) I vnty0'="" S vnty=vnty0_","_vnty
             ..S ^TG(tsid,"VCU",vnty)=vn,Q=1
          .S Q="Extra Unrecog src " D b^dv(Q,"Q,pvn,wj,TL,TSL")
        I Q=1 S Q=""  ;Kludge convert Q=1 nonstd to std Q success Q=""
        Goto Q
;*
Q     Q:$Q Q Q:Q=""
Qbug  D qd Q:$Q Q  Q
qd   D b^dv("Err "_$T(+0),"Q,tsid,tFL") Q
;*
;*$$ test format, registration TOI-var for vn, Accum vn List in tFL
;*    vn~vna  : vn',  vty, tFL'
vvn(vna)  I $G(vna)="" S Q="vn Null !" D ^dvstk,b^dv(Q,"Q,vna,an,wj,TL,TSL,Q") Q Q
         S vn=vna
         I vn[":" S vn=$TR(vn,":","/") D b^dv("Sub : to / in TOIa TFL","vn")
         S vty="" I vn["/" S vty=$P(vn,"/",2),vn=$P(vn,"/")
         I $G(vn)'?1.2L.7A.2n S Q="Unrecog Var Fmt ?1.2L.7A.2n ?" D b^dv(Q,"Q,vn,wj,TL,TSL") Q Q
         S tFL=tFL_","_vn
         Q ""
;*        
;*  : pnaL, Apx, Asx, patL	^TG(0,"PTYpx"  & "PTsx"   Link Punct to PunctName
;*   Apx Allowed Prefix Punct   ie esp not + -   special-care $
ITVN  NEW vn,pi,p,pk,fs,ty,tys
      S pnaL=".dot,/slash,\bkslash,<lt,>gt,&amp,~tilde,`bktic,!bang,#hash,@at,$dol,%per,^caret,*ast,-hyp,_und,=eq,+plus,|vbar,:colon,;semicolon"
      S Apx="/$#@&*=~\" D SV0(Apx,"px")
      S Asx="/.!#:" D SV0(Asx,"sx")
      S patL="dts,d12,email,tel,url,nalf,nafl"      
      F vn="pnaL","Apx","Asx","patL" S ^TG(0,vn)=@vn
      Q
;*  ^TG(0, "PTYpx"   and "PTYsx",p)=ty  (eg. pxslash  for prefix "/" )
SV0(L,pre) F pi=1:1:$L(L) S p=$E(L,pi) DO  ;
         .S pk=$F(pnaL,p) I 'pk D bug^dv Q
         .S fs=$E(pnaL,pk,999),ty=$P(fs,",")
         .I ty="" D bug^dv Q
         .S tys=pre_ty
         .S ^TG(0,"PTY"_pre,p)=tys
      Q
;*
