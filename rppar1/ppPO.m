ppPO ;CKW/ESC i7mar24 umep./ rppar1/ ;2024-0307-04;Post rule processes
;
;  generic, all post grab, log
gen  ;
     USE devlog
     D TX2
     W:$X ! W "Logpost grab:",grab,"  gran:",gran,"   '",grstr,"'  ",!
     Q
;*  grts,grte : grstr, tn
TX2  I Q'="" D bug^dv Q
     I '$G(grts) S Q="arg:grts="_grts Q  ;of grab/gran
     I '$G(grte) S Q="arg:grte="_grte Q
     S tn=grte-grts I tn<1 S Q="arg order grts-grte" Q
     S grstr="" F tkj=grts:1:grte S str=$G(TKv(tkj,"str")),grstr=grstr_str
     Q
;   @gposr^ppPO
;Inputs  grab,gran,  grtks,grtke start/end token ptrs, grs string from Input
;  mrou, cbid, ri, ...    LM, ri, lab,I ?
;  Set Vn  left side, tks is the value, ^ or % or ^% $E/$P
Svn  I $E(tks)'?1A,$E(tks)'="%" Q  ;Ignore mGbl, $E, $P for now
     D SVna("S")
     ;log cross ref Var SET
     Q
;*
Kvn  I $E(tks)'?1A,$E(tks)'="%" Q  ; Ignore
     D SVna("K")
     Q
     ;
;* tks : Vna     
SVna(VT) S Vna=tks
     I Vna["(" S Vna=$P(tks,"("),VAarg=$P($P(tks,"(",2),")")
     S XRV(Vna,cbid,VT)=LM
     Q
     
