ppzCGEV ;CKW/ESC i8mar24 umep./ rppar1/ ;2024-0308-50; Change Every profiles ^pp* rppar1/
;
;    FRTO(fi,"FR"  and "TO"
;    CHGmo [ "SV" 
;
;gopsr to gropsr to fit name stem pattern 8mar23
g1    D II
      S FR="gopsr",TO="gropsr" D S1
      S FR="grulFL",TO="grabFL" D S1
      S CHGmo="X"  D ^keCHGEV ; CHGmo, szro, FRTO()
      Q
;*
S1    S fi=fi+1
      D SFL^kfm(frtoFL)
      Q
;*
II    KILL  ;Everything
      I $zro'["gmsa/rmide" D b^dv("Needs access to gmsa utility","X") Q
      ;
      S fi=0
      S CHGmo="X"  ; vs 'SV'
      S frtoFL="FR,TO_FRTO(fi)"
      S szro=$zro
      Q
