ppTokVars ;CKW/ESC i7feb24 umep./  rppar1/ ;2024-0207-41;Vars and FL Doc  mumps table-driven parser
;
;  RM()  ri, rj  -> TK(ti)  {tna, 
;  TK(ti)   tokens  
;;tokFL:tkcod,tks,tkcs,tkce_TKV(ti)
;;tks s  Input string chars, eg var name %abc, or punct ^
;;tkcod s token code, terminal code
;;tkty  s -> Terminal vs rule code
;;
;    Grammar rules   gr*  
;;grulFL:grab,grun,gran,grlst,grde_GRv(gri)
;;grcod  ~grab Rule name, ref in other rules list
;;grcdn  ~gran  grcod + .i  alt variant number
;;grulst   Rule List, space delim
;;
;; Parse Table  States
;;
;; Input ptrs start, end/current token list ptrs
;; Cur input for me, not algo
;;

;*  Grammar fields
;;gab ruleab
;;gan rulab qualified by .i alternate id if multiple exist, .1 if only one
;;  GRq is seq list, space delim, tokens or ruleab's
IG    KILL GR S GR=0
      S GR(1.1)="Scom:"
;*  Grammar Table - toi ?
;Spaces never explicit in grammar rules, space delim for sequence
;gcod:  sets the rule ab code, no explicit dot unless alt .n
;No quotes around punct, representing itself
;wsp treated as token, preprocessed  then is good as delimiter in rules
;Scom is set command words, eg S or s or set or SET, token preprocessed
;Vwd. is token for var name, %, n after Alpha
;A. is Alpha, N. is digit
;Int.  maybe as integer, signed or not ?
;
GR    ;
;;Scom:Swd. wsp. Vn = Exp
;;Vn:Vwd.
;;Exp:Vn
