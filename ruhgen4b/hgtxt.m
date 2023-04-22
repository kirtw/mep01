hgtxt   ;CKW/ESC i19feb22 ten8/  r  ; 20220219-03 ;Write GUTS text file for HGen transition
;
;
top     BREAK  BREAK  HALT  ; No top entry ^hgtxt
;   returns $I is devt, ready to just WRITE to it
HGS(devt)  NEW Q S Q=""
        I $G(devt)="" D bug^dv S Q="arg devt" Goto QS
        S Q=$$OFW^devIO(devt) I Q'="" USE $P Goto QS
        USE devt D HD  ; TI*
        ;I $G(TIVL)'="" D ^dv("Vars-",TIVL)
        ;D ^dv("Footer-","TIft")
        W !
QS      Q:$Q Q I Q'="" D b^dv("HGS Err ","Q,devt")
        Q
;*
HD      W !,$G(TIdraw),!
        ;D ^dv("Header ^hgtxt ","TIdraw,TItb")
        Q
;*
;*      ;Now write GITS
;*
HGE(devt)   NEW Q S Q=""
        I $G(devt)="" D bug^dv S Q="arg devt" Goto QE
        S Q=$$OFR^devIO(devt) I Q'="" Goto QE
        USE devt W !
        D CFW^devIO(devt)
        USE $P W:$X ! W "Completed inner text file ",devt,!
QE      Q:$Q Q  I Q'="" D b^dv("HGE Err ","Q,devt")
        Q
;*
;*
GUTS(devt)  NEW Q S Q=""
        S Q=$$CF^devIO(devt)
        S Q=$$OFR^devIO(devt) I Q'="" Goto QG
        D sv^hgh("<pre>")  ; HTS(), HTE(), ...
        F rdi=1:1 USE devt R X S ZEOF=$ZEOF  USE $P Q:ZEOF  D sv^hgh(X)
        D sv^hgh("</pre>")  ; HTS(), HTE(), ...
        S Q=$$CFM^devIO(devt)
        USE devt
        D b^dv("Log devt written","devt")
QG      Q:$Q Q  I Q'="" D b^dv(Q,"Q,devt")
        Q
        
        
        
        
