ppTokVars ;CKW/ESC i7feb24 umep./  rppar1/ ;2024-0207-41;Vars and FL Doc  mumps table-driven parser
;
;  RM()  ri, rj  -> TK(ti)  {tna, 
;  TK(ti)   tokens  
;;tokFL:tkcod,tks,tkcs,tkce_TKV(ti)
;;tks s  Input string chars, eg var name %abc, or punct ^
;;tkcod s token code, terminal code
;;tkty  s -> Terminal vs rule code
;;
;;tokt s Token cod =tkcod, some tok
;;tokgrFL:ttde_GRt(tkcod)
;;
;    Grammar rules   gr*  
;;grabFL:grde,grnun,grri_GRv(grab)  # gr* stem
;;grab  ~grab Rule name, ref in other rules list
;;
;;granFL:grulst,gropsr,grtt_GRc(gran)  # gr* stem
;;gran  ~gran  grcod + .i  alt variant number
;;grulst   Rule List, space delim
;;
;; Parse Table  States
;;
;; Input ptrs start, end/current token list ptrs
;; Cur input for me, not algo
;;

;*  Grammar fields
;;grab:s,sub/GRv rule abbr, mnemonic key, ?1A5.20AN
;;gran:s,sub/GRc rulab qualified by .i alternate id - one or more
;;  GXsq is seq list, space delim, tokens or ruleab's
;;
;;gFil:Grammar Source FileName  in rppar1/ currently
;;devgr:Grammar source file uri
;;devlog: Log source file
;;deverr: Pgm-Error/bug Log File
;;devGR:Grammar HGen
;;devMR:Mumps Routine Text and TXv(txi,
;;
