GP6(GBL,devg)	;CKW/ESC  ir15aug20 gmsa/ rmGP3/ ; 20220613-75;HGen MGbl Dumps, two-level
	;
	;
	; GBL  is Global Base- Name, or Node, Used in @GBL@ syntax
	; S1 is Subscript 1 below GBL, Ref in G1 ~ @GBL@(S1)
	;   V1 is Value in a Node
	;   D1 is $D of Node --or"T" (10) Tree and "V" Value (1)
	;	Although they should be treated Separately, ie not in same breath !
	;
	; Global Scan Syntax - relates to Above and Ranges for Si Subscripts
	;   Range as Start, End values, Pattern,  or all, or all-except zero,
	;      type like integer, non-zero
	;
	I $G(devg)="" S devg="x/MGbl-"_GBL_".2.html"
 	;
	; Field Dictionary-test values,
	;	expand vals (output transforms included, eg dates)
    ;HG(GBL,SIMO,S1rs,S1re,S1rn,Fil) S Fil=$G(Fil) 
    I $zro'["rd3hg",$zro'["rmGP" DO  Q
           .S zro=$zro 
           .D b^dv("^GP6 $zro needs vers rd3hg or rmGP*  of HGen  ^hgh* etc.","zro")
        ;   
	S S1rs=$G(S1rs),S1re=$G(S1re),S1rn=$G(S1rn),S1MO=$G(S1MO)
        D Init^hgh  ; TI(), HT()  etc
          I $E(GBL)="^" S TI("hd")="MGbl "_GBL
          E  S TI("hd")="Array "_GBL
          S TI("title")=GBL
          S TI("VVL")="byGP",byGP="by ^"_$T(+0)
        S gbHFL="S1:10,V1:30"   D I^hght(gbHFL)  ; Compile
        D Icss
	S Q=$$HGS^hgh I Q'="" D b^dv("Err HGS","Q,devg") Q
	D PR(GBL,S1MO,S1rs,S1re,S1rn)  ; guts : HT()
	S Q=$$HGE^hgh I Q'=""  ;?
	S Q=$$WH^hgh(devg) I Q'="" D b^dv("Err Writing out devg","Q,devg") Q
	Q
	;
	; WRITES  converted to ^hgh  (wrapped in html by caller(S) )
PR(GBL,SIMO,S1rs,S1re,S1rn)  S S1rs=$G(S1rs),S1re=$G(S1re),S1rn=$G(S1rn),S1MO=$G(S1MO)
        D BrLn
	S S1=S1rs F NS1=0:1 D SN1 S S1=$O(@GBL@(S1)) Q:S1=""    Q:$$P1E
	I NS1=0 W:$X ! W !,"MGlobal '",GBL,"'  is UnDefined.",!
	Q
;*  GBL : Gnm, D1, D1t, D1v, V1
SN1     I S1="" Q
        S D1=$D(@GBL@(S1)),V1=$G(@GBL@(S1))
        S D1t=D1>9  ; 0/1 
        S D1v=D1#2  ; 0/1
        I D1v,V1="" S V1=" - Null Stored."
	I GBL'["(" S Gnm="("
	E  S Gnm=","
	S Gnm=Gnm_""""_S1_""""
	I D1v S Gnm=Gnm_")="
	;D b^dv("Log S1","GBL,Gnm,D1,D1t,D1v,S1,V1")
	D P1
    Q
;*$$Q	;Next S1, Range/Quit Tests -> Q
P1E()	S Q=0 I S1="" Q 1
	I S1re'=""&(S1]S1re) Q 2
	I S1rn&(S1'<S1rn) Q 3
	S GBLundef='NS1
	Q ""
	;
	; GBL : Gnm, S1, D1, V1
P1	D ot^hgh(".P1")
	I D1v DO  ;
	     .D ot^hgh(".s1"),sv^hgh(Gnm),ct^hgh(".s1")
	     .D ot^hgh(".v1"),sv^hgh(V1),ct^hgh(".v1")
	I D1t D P2
	D ct^hgh(".P1")
	Q
;*
;*   *** ???	Second variable subscript
P2	S S2=""
	F N2=0:1 S S2=$O(@GBL@(S1,S2)) Q:S2=""  D SN2,DS2  ;
	Q
;*  GBL, Gnm, S1, S2 : Gnm2, D2, D2t, D2v, V2
SN2     S D2=$D(@GBL@(S1,S2)),V2=$G(@GBL@(S1,S2))
        S D2t=D2>9  ; 0/1 
        S D2v=D2#2  ; 0/1
        I D2v,V2="" S V2=" - Null Stored."
	S Gnm2=Gnm_","
	;S Gnm2=Gnm2_""""_S2_""""
	;D b^dv("Log S2","GBL,Gnm2,D2,D2t,D2v,S2,V2")
        Q

;*  Gnm2, S2
DS2     I S2="" Q
        D ot^hgh("#P2")
        D ot^hgh(".g2"),sv^hgh(Gnm),ct^hgh(".g2")
	D ot^hgh(".s2"),sv^hgh(""""_S2_""""),ct^hgh(".s2")
	I D2t D ot^hgh(".pls"),sv^hgh("+ "),ct^hgh(".pls")
        I D2v D ot^hgh(".v2"),sv^hgh(")=="),sv^hgh(V2),ct^hgh(".v2")
        D ct^hgh("#P2")
	Q
;* devg : Braceline
BrLn    S n=$L(devg,"/"),brFol=$P(devg,"/",n-1),brB=$P(devg,"/",3,n-2)
        S brDt=$ZD($H,"DAY 12AM DD-MON-YYYY","","Sun,Mon,Tue,Wed,Thu,Fri,Sat")
        S h="   { "_brB_"/,   "_$$LNK^hgh(brFol_"/*","./")_"  } "_brDt
        D ot^hgh("#brln"),sv^hgh(h),ct^hgh("#brln")
        
;*  	
Icss    ;  .P1 [ .g1, .s1, .pls, .v1, .P2  [ .g2, .s2, .v2 ] ]
        D css^hgh("body","max-width: 800px;")
        D css^hgh(".g1","background-color: #D7BDE2;")         
        D css^hgh(".s1","background-color: #D7BDE2;")
        D css^hgh(".v1","background-color: #D7BDE2;")  ; lt blue       
        D flexrow^hgh(".P1",".g1 .s1 .v1")
        D flexrow^hgh(".P2",".g2 .s2 .pls .v2")        
        D css^hgh(".g2","background-color: #D7BDE2;")
        D css^hgh(".s2","background-color: #D7FFFF; text-align: right;")
        D css^hgh(".pls","background-color: #D7BDE2;")        
        D css^hgh(".v2","background-color:yellow;flex: 8;")
        Q
;*
T()     Q 1  ; See tgp6^GPTest  Test & debug
