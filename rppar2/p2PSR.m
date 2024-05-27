p2PSR ;CKW/ESC i7mar24 umep./ rppar2/ ;2024-0513-58;Post rule processes ^p2PAR gropsr
;
;  generic, all post grab, log ??? NOT
gen  ;
     USE devlog
     D TX2
     W:$X ! W "Logpost gran:",gran,"   '",gnstr,"'  ",!
     Q
;*  grts,grte : TKv(), grstr, tn~colspan
TX2() NEW Q,tkj,tn S Q=""
     I '$G(grts) S Q="arg:grts="_grts G Qb  ;of gran
     I '$G(grte) S Q="arg:grte="_grte G Qb
     S tn=grte-grts+1 I tn<1 S Q="arg order grts-grte" G Qb
     S colspan="" I tn>1 S colspan=tn
     S grstr="" F tkj=grts:1:grte S str=$G(TKv(tkj,"tks")),grstr=grstr_str I str="" D b^dv("Err tks null","str,tkj,grstr,tki")
     G Q
;*
;  tki : tks, Vna
Svna NEW Q I $$arg^p2s("tki") G Qb
     D GFL^kfm(tokFL) ; tki -> tks,tkcs,tkce
       I tks="" D b^dv("Err tks null in tki","tks,tki,tkcod")
     I $E(tks)'?1A,$E(tks)'="%" Q  ;Ignore mGbl, $E, $P for now
     S Vna=tks     
     ;log cross ref Var SET
     Q
;;tokFL:tkcod,tks,tkcs,tkce,tkri_TKv(tki)
;* Vna, LM, cbid :  XRV() for MBR code analysis
XRna(VarActTy)  NEW Q I $$arg^p2s("tki,Vna,TKv,VarActTy") G Qb 
     I $G(cbid)="" S cbid="TestLine"
     I $G(LM)="" S LM=$G(TKv(0,"LM")) I LM="" S LM="K X,Y"  ; sic fudge/kludge
     S ssVna=Vna I Vna["(" S ssVna=$P(Vna,"("),VAarg=$P($P(Vna,"(",2),")")
     I ssVna="" D b^dv("Lost Vna ","ssVna,Vna,tks,tki") Q
     S XRV(ssVna,cbid,VarActTy)=LM  ; for MBR xref Vars
     Q
;*     
Q      Q:$Q Q Q:Q=""
Qb     D b^dv("Err Post granPASS sr gropsr in ^"_$T(+0),"Q,grab,gran,grts,grte,colspan,grstr")
       Q:$Q Q  Q   
;*     * * * * *       
;   @gropsr^p2PSR
;
;*  tki & TKv(tki  tkiFL 
KVn  NEW Q I $$arg^p2s("tki") G Qb
     D TX2 ; grts,grte : grstr
     S Vna=grstr
     I grstr="" D b^dv("Err no grstr/Vna of gran gropsr","Vna,grstr,grts,grte,gran,gropsr") G Qb
     D XRna("K") ; 
     Q
     ;
