ppPAtokt(tokt)  ;CKW/ESC i26mar24 umep./ rppar1/ ;2024-0327-97;Terminal tokt process 
;
;
;  tokt, toty="T" : QT
    NEW Q,DD,QTest  I $$arg^pps("tokt,toty") G Qb
      I toty'="T" D bug^dv G Qb
    S DD=$D(GRt(tokt)) I DD=0 S Q="Undef tokt '"_tokt_"'" G Qb    
    S QTest=(tokt=TKc)
    I 'QTest S QT="X tokt-Failed"_TKc_"'="_tokt D TermNO G Q
    D TermMch  
    S QT="" ;QTest matches !
    D Iin^ppPAsr    ;Now bump tki, TKc, tk*
    I QI'="",tki=""   ;No more input
    G Q
;*
Q      Q:$Q Q Q:Q=""
Qb     D b^dv("Err ^"_$T(+0),"Q,RG,devrg,gi,grab,gran") Q:$Q Q  Q
;*
;* Terminal matched Input tokt=TKc~tkcod/Input tki : TKc null means finished TKv input
;  Bumps both Input, tki, and rule ptr, Rn, after finding a terminal match
TermMch   S grce=tki,grstr=grstr_tks
      D SFL^kfm("gran,grstr","_PTx(tkcs,StkP)")
      ;W:$X ! W "TermMch ",tokt," in ",gran," #",Rn,"  vs tki:",tki,"  <",tks,"> ->",grstr,!
      D bln^dv3("termPASS")
      Q
;* Terminal does not match, rule fails (or tried to use Undef term)
;*  Fails QN gran if any terminal doesnt match next TKc~tkcod
TermNO S QT="X:"_tokt_" at "_$G(gnn)
      W:$X ! W "TTX x ",gran," Failed at ",tokt,"   [",grulst,"] #",Rn,!
      D bln^dv3("termFAIL")
      D pze^pps("Log End TermNO","QT,QI,tokt,tki,TKc")
      Q
;*
 
