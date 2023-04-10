hghTemplate ;CKW/ESC i23jun22 gmma/ rbrzm1/ ;20220623-98;Simple Page HGen Template
;
;
;
top   NEW Q I $$arg^mws("zrid") Goto Qbug
    S nmr=0,ncb=0
    S Q=$$devFil^mwIpg("aa-TOC-All") ; : devFil  destination html page
    D Init^hgh  ; Init Buffers
    S TItb="aa-TOC-All"
    S TIhd="Contents List - All MRou, All rdir"
    S TIft="by ^"_$T(+0)_"  "_$ZD($H,"YY MM DD 12:60AM")
    D Hcss
    D HGS^hgh
    D guts
    D HGE^hgh
    D WH^hgh(devFil)
    Goto Q
Q   Q:$Q Q I Q'="" D qd
    Q
Qbug  D qd Q:$Q Q  Q
qd    D b^dv("Err ^"_$T(+0),"Q,dev")
      Q
;*
Hcss    D css^hgh(".line","font-size: 2em; background-color: lightblue;")
        D css^hgh(".line","write-space: pre-wrap;")
        D flexrow^hgh(".line",".h1td:1 .h2td:1")
        Q
;*   RL() devFil   : HGen
guts    For ri=1:1:RL S tx=RL(ri) DO line
        Q
line    S text1=$P(tx,"_"),text2=$P(tx,"_",2)
        D ot^hgh(.line)
        D ot^hgh(".h1td"),sv^hgh(text1),ct^hgh
        D ot^hgh(".h2td"),sv^hgh(text2),ct^hgh
        D ct^hgh(".line")
        Q
;*

