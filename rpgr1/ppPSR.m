ppPSR ;CKW/ESC i7mar24 umep./ rpg1/ ;2024-0307-04;Post rule processes
;  was ^ppP0 vs ^ppPO  confusion renmes  and ^p2PSR in rppar2/
;  generic, all post grab, log
gen  ;
     USE devlog
     D TX2
     W:$X ! W "Logpost grab:",grab,"  gran:",gran,"   '",grstr,"'  ",!
     Q
;*  grts,grte : grstr, tn~colspan
TX2()  I Q'="" D bug^dv Q
     NEW Q S Q=""
     I '$G(grts) S Q="arg:grts="_grts G Qb  ;of grab/gran
     I '$G(grte) S Q="arg:grte="_grte G Qb
     S tn=grte-grts+1 I tn<1 S Q="arg order grts-grte" G Qb
     S colspan=tn
     S grstr="" F tkj=grts:1:grte S str=$G(TKv(tkj,"str")),grstr=grstr_str
     G Q
;*
Q      Q:$Q Q Q:Q=""
Qb     D b^dv("Err ^"_$T(+0),"Q,grab,gran,grts,grte,colspan,grstr")
       Q:$Q Q  Q     
;   @gropsr^ppPO
;Inputs  grab,gran,  grts,grte start/end token ptrs : colspan, grstr string from Input
;  mrou, cbid, ri, ...    LM, ri, lab,I ?
;  Set Vn  left side, tks is the value, ^ or % or ^% $E/$P
Svn  I $E(tks)'?1A,$E(tks)'="%" Q  ;Ignore mGbl, $E, $P for now
     D SVna("S")
     ;log cross ref Var SET
     Q
;*  tks
Karg  I $E(tks)'?1A,$E(tks)'="%" Q  ; Ignore
     D TX2 ; grts,grte : nspan, grstr
     D SVna("K")
     Q
     ;
;* tks : Vna     
SVna(VT) S Vna=tks
     I Vna["(" S Vna=$P(tks,"("),VAarg=$P($P(tks,"(",2),")")
     S XRV(Vna,cbid,VT)=LM
     Q
     
