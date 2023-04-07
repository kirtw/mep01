KGD     ;CKW/ESC i26jul22  gmma/ rmGP3/ ;20220726-12; GT.M %GD utility - global directory
; mod from %GD, %GSEL combined and non-interactive, hgen
        ;
        NEW %ZG,%ZL
        I '$D(%zdebug) NEW $et S $et="zg "_$zl_":ERRgd^KGD" USE $p:(ctrap=$c(3):exc="KILL %ZG ZG "_$ZL_":LOOPgd^KGD")
        W !,"Global Directory",!
        D GD^KGSEL,EXITgd
        Q
ERRgd     USE $P W !,$P($ZS,",",2,99),!
        S $ec=""
        ; Warning: Fall-through!
EXITgd    USE $p:(ctrap="":exc="")
        Q
LOOPgd    D GD^KGSEL,EXITgd
        Q
;*        
KGSEL   ;GT.M %GSEL utility - global select into a local array
        ;invoke ^KGSEL to create %ZG - a local array of existing globals, interactively
        ;
        NEW add,beg,cnt,d,end,g,gd,gdf,k,out,pat,stp,nfe
        D init,main
        USE:$D(d("use")) @d("use")
        USE:$D(d("io")) d("io")
        Q
GD      ;
        NEW add,beg,cnt,d,end,g,gd,gdf,k,out,pat,stp,nfe
        S cnt=0,(out,gd,gdf)=1
        D main
        I gdf S %ZG="*" DO  ;
           .D setup,it 
           .W !,"Total of ",cnt," global",$S(cnt=1:".",1:"s."),!
        USE:$D(d("use")) @d("use")
        USE:$D(d("io")) d("io")
        Q
 
CALL    ;invoke KGSEL without clearing %ZG (%ZG stores the list of globals from KGSEL searches)
        NEW add,beg,cnt,d,end,g,gd,gdf,k,out,pat,stp,nfe
        S (cnt,gd)=0
        I $D(%ZG)>1 S g="" FOR  S g=$O(%ZG(g)) Q:'$L(g)  S cnt=cnt+1
        I $G(%ZG)'?.N S out=0 D setup,it S %ZG=cnt Q
        S out=1
        D main
        USE:$D(d("use")) @d("use")
        USE:$D(d("io")) d("io")
        Q
;*
init    ;
        KILL %ZG
        S (cnt,gd)=0,out=1
        Q
 
main    ;
        S d("io")=$IO
        I '$D(%zdebug) NEW $ETRAP S $ETRAP="ZGOTO "_$ZL_":ERR^"_$T(+0) DO  ;
        . NEW x
        . ZSHOW "d":d       ; save original $p settings
        . S x=$P($P(d("D",1),"CTRA=",2)," ")
        . S:""=x x=""""""
        . S d("use")="$P:(CTRAP="_x_":EXCEPTION=",x=$P(d("D",1),"EXCE=",2),x=$ZWR($E(x,2,$L(x)-1))
        . S:""=x x=""""""
        . S d("use")=d("use")_x_":"_$S($F(d("D",1),"NOCENE"):"NOCENABLE",1:"CENABLE")_")"
        . USE $P:(CTRAP=$C(3,4):EXCEPTION="":NOCENABLE)
        FOR  D inter Q:'$L(%ZG)  ; Q:%ZG=""
        S %ZG=cnt
        Q
 
inter   ;
        S nfe=0
        READ !,"Global ^",%ZG,! Q:'$L(%ZG)
        I $E(%ZG)="?",$L(%ZG)=1 D help Q
        I (%ZG="?D")!(%ZG="?d") D cur Q
        I $E(%ZG)="?" S nfe=1 D nonfatal Q
        D setup I nfe>0 S nfe=0,gdf=0 Q
        D it
        W !,$S(gd:"T",1:"Current t"),"otal of ",cnt," global",$S(cnt=1:".",1:"s."),!
        Q
 
setup   ;Handles the base case of no range
        NEW g1,et
        I gd S add=1,cnt=0,g=%ZG KILL %ZG S %ZG=g
        ELSE  I "'-"[$E(%ZG) S add=0,g=$E(%ZG,2,999)
        ELSE  S add=1,g=%ZG
        S g1=$TR(g,"?%*","aaa") ;Substitute wildcards for valid characters
        DO  ;
        . S et=$ETRAP NEW $ETRAP,$ESTACK S $ETRAP="S $ECODE="""",$ETRAP=et D setup2",g1=$QSUBSCRIPT(g1,1)
        . S:$F(g,"(")'=0 $E(g,$F(g,"(")-1,$L(g))=""
        . S:$E(g)="^" $E(g)=""
        I "?"=$E(g,$F(g,":")) S nfe=1 D nonfatal Q
        S g=$TR(g,"?","%"),beg=$P(g,":",1),end=$P(g,":",2)
        I end=beg S end=""
        Q
 
setup2  ;Handles the case of a range argument
        NEW p,q,x,di,beg1
        S p=$L(g1,":")
        I p<2 S nfe=2 D nonfatal Q
        ELSE  I p>2 S q=$L(g1,"""")-1 F x=2:2:q S $P(g1,"""",x)=$TR($P(g1,"""",x),":","a")
        DO  ;
        . S beg=$P(g1,":",1),end=$P(g1,":",2)
        . NEW $ETRAP,$ESTACK S $ETRAP="S nfe=2 D nonfatal",beg1=$QSUBSCRIPT(beg,0),end=$QSUBSCRIPT(end,0)
        Q:nfe>0
        S di=$L(beg),beg=$E(g,1,di),end=$E(g,di+2,$L(g))
        S:$F(beg,"(")'=0 $E(beg,$F(beg,"(")-1,$L(beg))=""
        S:$E(beg)="^" $E(beg)=""
        S:$F(end,"(")'=0 $E(end,$F(end,"(")-1,$L(end))=""
        S:$E(end)="^" $E(end)=""
        S g=beg_":"_end
        Q
 
it      ;
        S gdf=0
        I end'?."*",end']beg Q
        S g=beg D pat
        I pat["""" D start FOR  D search Q:'$L(g)  D save
        I pat["""",'$L(end) Q
        S beg=stp
        S:'$L(g) g=stp
        S pat=".E",stp="^"_$E(end)_$TR($E(end,2,9999),"%","z")
        D start FOR  D search Q:'$L(g)  D save
        S g=end D pat
        I pat["""" S:beg]g g=beg D start FOR  D search Q:'$L(g)  D save
        Q
 
pat     ;
        NEW tmpstp
        S:"%"=$E(g) g="!"_$E(g,2,9999)
        S pat=g
        FOR  Q:$L(g,"%")<2  DO  ;
        .S g=$P(g,"%",1)_"#"_$P(g,"%",2,999),pat=$P(pat,"%",1)_"""1E1"""_$P(pat,"%",2,999)
        FOR  Q:$L(g,"*")<2  DO  ;
        .S g=$P(g,"*",1)_"$"_$P(g,"*",2,999),pat=$P(pat,"*",1)_""".E1"""_$P(pat,"*",2,999)
        S:"!"=$E(g) g="%"_$E(g,2,9999),pat="%"_$E(pat,2,9999)
        I pat["""" S pat="1""^"_pat_""""
        S tmpstp="z",$P(tmpstp,"z",30)="z"
        S g="^"_$P($P(g,"#"),"$"),stp=g_$E(tmpstp,$L(g)-1,31)
        Q
 
start   ;
        S:"^"=g g="^%"
        I g?@pat,$D(@g) D save
        Q
 
search  ;
        FOR  S g=$O(@g) S:g]stp g="" Q:g?@pat!'$L(g)  ;Q:g=""  Q:g?@pat
        Q
 
save    ;
        I add,'$D(%ZG(g)) S %ZG(g)="",cnt=cnt+1 D prt:out
        I 'add,$D(%ZG(g)) KILL %ZG(g) S cnt=cnt-1 D prt:out
        Q
 
prt     ;
        W:$X>70 ! W g,?$X\10+1*10
        Q
 
help    ;
        W !,?2,"<RET>",?25,"to leave",!,?2,"""*""",?25,"for all"
        W !,?2,"global",?25,"for 1 global"
        W !,?2,"global1:global2",?25,"for a range"
        W !,?2,"""*"" as a wildcard",?25,"permitting any number of characters"
        W !,?2,"""%"" as a wildcard",?25,"for a single character in positions other than the first"
        W !,?2,"""?"" as a wildcard",?25,"for a single character in positions other than the first"
        Q:gd
        W !,?2,"""'"" as the 1st character",!,?25,"to remove globals from the list"
        W !,?2,"?D",?25,"for the currently selected globals",!
        Q
 
cur     ;
        S g=""
        FOR  S g=$O(%ZG(g)) Q:'$L(g)  W:$X>70 ! W g,?($X\10+1*10)
        W !,$S(gd:"T",1:"Current t"),"otal of ",cnt," global",$S(cnt=1:".",1:"s."),!
        Q
        I gd W "Total of ",cnt," MGlobal"
        E   W "Current total of ",cnt," MGlobal"
        W:cnt>1 "s"  W ".",!
        Q
nonfatal
        NEW ecde
        S $ECODE=""
        I nfe=1 S ecde="U257"
        ELSE  I nfe=2 S ecde="U258"
        W $T(+0),@$P($T(@ecde),";",2),!
        Q
 
ERR     ;
        USE:$D(d("use")) @d("use")
        USE:$D(d("io")) d("io")
        S $ECODE=""
        Q
 
LOOP
        D main
        USE $P:(ctrap=$CHAR(3,4):exc="")
        Q
 
;       Error message texts
U257    ;"-E-ILLEGALUSE Illegal use of ""?"". Only valid as 1st character when ""?D"" or ""?d"""
U258    ;"-E-INVALIDGBL Search string either uses invalid characters or is improperly formated"

