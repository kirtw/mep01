pps ;CKW/ESC i3mar24 umep./ rppar1/ ;2024-0303-76;SR for ^pp*
;
;
;
;*  Sets Q null or err, saves caller from having to do this, sic bug if ;out
;;  label(arg1,arg2) NEW Q I $$arg^cmds("arg1,arg3") Goto Q ;shared exit
;;    Q is set null if args ok, not returned in $$, as 0/1 returned as $$ for branching
;;  Null ok, set null if UNDEF   arg2:null   extend super list colon2 props --- ?
;*  also sets Q null or Err, returns $$ branch 0 ok, 1 Err (ie $$~ Q'="" )
arg(VL)  NEW ARY,FL,vn,vi S Q=""  ; Q is NOT NEWed here, but set null or returned
        I $G(VL)="" S Q="Null arg VL" Goto Qa
        S ARY=$P(VL,"_",2),FL=$P(VL,"_")  ; tolerate, not reqd
        S argFL=FL
        F vi=1:1:$L(FL,",") S vn=$P(FL,",",vi) DO  ;
          .I $D(@vn)=0 S Q=Q_"$$arg "_vn_" UNDEF," Q
          .I $G(@vn)="" S Q=Q_vn_" Null," Q
          .;further tests ?  def vs null, ARY vs base node undef, null ?
        S argNvi=vi
Qa      S argQ=Q,argRet=(Q'=""),argDolQ=$Q,argVL=VL
        I Q'="" D ^dvstk,b^dv(Q,"Q,argVL")
        Q Q'=""  ; $$ is not Q, but 0/1 if ERR for branching I $$arg
;*
