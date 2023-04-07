mwPET(cod) ;CKW/ESC i12oct22 umbr./ rmw1/ ;20221012-98;Parse mumps with Earley table
;
;
;
top    D ^mwIGM ; : MG()  mumps grammar
       D IPT  ; parse table
       ; D lex(cod) ; : LX(pi)
       ;D PAR  ; LX(pi) : ET(), Ptr
       ;D Dtr
       Q
;*  :  PT(sti,rui)    ptFL
IPT    S ptFL="rudi,rudn"
       ;...
       Q
;;sti  State number 0:1
;;rudn Dot position
;;ruist  input start
;;ruiend input end
;;
;Each rule is a list of entities
;Rules come from grammar
;left-side/rule name
; right side is list of rules or lex entities
;
