ppPO ;CKW/ESC i7mar24 umep./ rppar1/ ;2024-0307-04;Post rule processes
;
;
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
     
