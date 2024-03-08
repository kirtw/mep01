dimVar ;CKW/ESC i24nov23 umep./ rDIM/ ;2023-1124-65;Vars in ^dim*  modified from ^DIM*
;
;
;
;; X  input line
;; X -> %X MX input string, consumed
;; %END
;; %LAST
;; %ERR ERR Bool 0/1 Error not specified
;; %ARG ARG label & arguments (space, not tab delimiter)
;; %C C CH Current Char from %X EX
;; %C1  C1 alt C value...
;; %I II Char ptr into %X EX
;; %COM COM  Cmd letter (transiently word)
;;   %COM(1)  wierd, single var vs %COM1 
;; STK(-1,1)
;; STK(-1,2) 
;; STK(0,1)
;; STK(0,2)
;; STK(0,3)
;; %  Mult Uses (SIC!)  TERRIBLE to search for !
;;  %(%N, vn)  STK(SP,vn)   vn 0,1,"F" ="FN" flag function
;;      vn=0  FNP  3 pieces, ; and ^  
;;        vn=1
;;       vn=2
;;        vn=3  
;;        vn="F"  val "FN" for function ... 
;;  %N SP Stack Ptr  some -1 values ??
;;  % PC (new PCn bool PC="" ie PC is null) in ^dim  postcond string
;;  % EX input to ^dim1  expression string
;;  % EX in ^dim4
;;
;;  %F Cnx  Next Char ~C
;;  %F ^dim1  FNP ?
;;  %F1 ^dim2  nFc  Cpv  Prev Char ~C
;;  %F1 FNP in ^dim1, ^
;; %FN  FN  ^dim1
;; %FZ  FZ  ^dim1
;; %A  CA0
;; %A1 CA1
;; %A2 CA2
;; %P PL  Paren Level
;; %P1
;; %L  CL  Char Mode of Search ^dim3, ^dim4
;; %Z  For %Z=0:0 never used ^dim4  Removed F novar sp sp ...
;; %Z1  PL1  Punct List
;; %Z2  PL2  Punct List
;; %T  
