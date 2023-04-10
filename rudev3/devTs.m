devTs  ;CKW/ESC  i1mar19 ; 20190301-10 ; Test SR
  ;  in gmsa/  rudev/
  ;
  ;
;*  Qn  Save Error & Count  ?Call by Ref to incr, vs implicit arg ???
;  implicit Qn, in, update/incr
SE(M,Qe,VL) S Qn=$G(Qn)+1  ; just dont crash
      S:$G(E)="" E="?" S QER(E)=Qe
      I $G(VL) DO
        .F vi=1:1:$L(VL,",") S vn=$P(VL,",",vi),QER(Qe,vn)=$G(@vn)  ; KILL @vn  ;? Clean Up/No reuse
      Q
;*

