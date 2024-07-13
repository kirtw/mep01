p2PSR ;CKW/ESC i7mar24 umep./ rppar2/ ;2024-0513-58;Post rule processes ^p2PAR gropsr
;
;  generic, all post grab, log ??? NOT
gen  ;
     USE devlog
     D TX2
     W:$X ! W "Logpost gran:",gran,"   '",gnstr,"'  ",!
     Q
;*  tkcs,tkce : grstr, tn~colspan
TX2() NEW Q S Q=""
     I '$G(grts) S Q="arg:grts="_grts G Qb  ;of gran
     I '$G(grte) S Q="arg:grte="_grte G Qb
     S tn=tkce-tkcs+1 I tn<1 S Q="arg order tkcs-tkce" G Qb
     S colspan="" I tn>1 S colspan=tn
     S grstr=$E(LM,tkcs,tkce)
     G Q
;*
;  tkcs,tkce : grstr, Vna
Svna NEW Q I $$arg^p2s("tkce") G Qb
     S grstr=$E(LM,tkcs,tkce)
     S Vna=grstr     
     ;log cross ref Var SET
     Q
;* Vna, LM, cbid :  XRV() for MBR code analysis
XRna(VarActTy)  NEW Q I $$arg^p2s("LM,Vna,VarActTy") G Qb 
     I $G(cbid)="" S cbid="TestLine"
     S ssVna=Vna I Vna["(" S ssVna=$P(Vna,"("),VAarg=$P($P(Vna,"(",2),")")
     I ssVna="" D b^dv("Lost Vna ","ssVna,Vna,grstr,tkcs,tkce") Q
     S XRV(ssVna,cbid,VarActTy)=LM  ; for MBR xref Vars
     Q
;*     
Q      Q:$Q Q Q:Q=""
Qb     D b^dv("Err Post granPASS sr gropsr in ^"_$T(+0),"Q,grab,gran,grts,grte,colspan,grstr")
       Q:$Q Q  Q   
;*     * * * * *       
;   @gropsr^p2PSR
;
;*  
KVn  NEW Q I $$arg^p2s("LMi") G Qb
     D TX2 ; tkcs,tkce : grstr
     S Vna=grstr
     I grstr="" D b^dv("Err no grstr/Vna of gran gropsr","Vna,grstr,grts,grte,gran,gropsr") G Qb
     D XRna("K") ; 
     Q
     ; Var in exp
Svn  NEW Q I $$arg^p2s("LMi,tkcs,tkce") G Qb
     D TX2 ; : grstr
     S Vna=grstr
     D b^dv("Log gropsr of Svn","grstr,gran")
     D XRna("E")  ;expr var ref
     S QT=""
     Q
     
