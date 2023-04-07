hght()  ;CKW/ESC  i14aug20 gmsa/  rhgen4/ ; 20200814-33 ;sr for table, line-cols HGen
;
;  Entry: I^hght(xHFL)  Init/Compile super list,  HD ?,  WH^hgh(devh)  to write out HGen file
;     top or HLn - one line,  @vn by caller
;   
     Q $$HLn()
     Q  ;safety
;
;  Init  *HFL super var incl :2 width, :3 th col header
;    total line width
;
;  Each line, @vn  by caller, then can add vars like n, line num, not fromdb
;   but usu GFL^dgmg(rdirFL)   assoc super var list, order
;
;  Use cases:  1) ns fields	^gunHns2
;       2)  KAcf  and KA1  transactions
;   xHFL  seq and attr of fields : TFA()
I(xHFL)  I $G(xHFL)="" D bug^dv Q
       NEW Q,HFL,fi,L     NEW:0 vn,fw,fhd,fq,fn,tw
       I $zro'["rd3hg",$zro'["rhgen" D ^dzs D b^dv("Needs rd3hg/rhgen4+ ^hgh version","zro")
       S tw=0  KILL TFA  S T2=$P(xHFL,"_",2),gHFL=$P(xHFL,"_")
       F fi=1:1:$L(gHFL,",") DO  ;
         .S fp=$P(gHFL,",",fi),vn=$P(fp,":")
         .S fw=$P(fp,":",2) I 'fw S fw=8  ; in % of line width
         .S tw=tw+fw
         .S fhd=$P(fp,":",3) I fhd="" S fhd=vn
         .S fq=fi
         .S vc="vn-"_vn D css^hgh("."_vc,"width:"_fw_"% ;")         
         .S tfaL="vn,fw,fhd,fp,vc" 
         .F vi=1:1:$L(tfaL,",") S fn=$P(tfaL,",",vi),TFA(fq,fn)=@fn,TFA=fq

       I tw'=100 USE $P W:$X ! W "Total width % is ",$G(tw),", vs 100%",!
       I T2'["width:" S T2="Width: 800px;"
       D css^hgh(".line",T2)  ; must be proper prL  width mainly  width: 800 px
       D flexrow^hgh(".line",".lbox")
       Q
;*
TTFA   I $D(TFA)'=11 D b^dv("Need TFA - S Q=$$I^hght(xxxHFL)","TFA") Q
       S Q=$$HLn()
       Q Q
;*$$Q
HD()   ;
       Q ""
;*
;  Entry  vs top  S Q=$$HLn^hght()   ; no actual argument, @vn by caller
HLn()  NEW Q,Qt  S Qt=""
       ; Line wrap, alt background, ...  tr ?
       S Q=$$ot^hgh(".line") I Q'="" S Qt=Qt+1_Q Q Qt
       F fq=1:1:TFA S Q=$$H1L() I Q'="" S Qt=Qt+1_" "_Q
       S Q=$$ct^hgh(".line") I Q'="" S Qt=Qt+1_Q
       Q Qt
;*  fq
H1L()  F vi=1:1:$L(tfaL,",") S fn=$P(tfaL,",",vi),@fn=TFA(fq,fn)
       S Q=$$ot^hgh(".lbox "_vc) I Q'="" Q Q
       S fv=$G(@vn) S fv=" "_fv
       D sv^hgh(fv)
       S Q=$$ct^hgh()  ; ".lbox .vn-*"
       Q Q
;*       
