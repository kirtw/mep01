dvcaller  ;CKW/EESC i13oct20 gmsa/ rd2vl/ ; 20201013-76 ; Identify sr caller from stack
;
; Returns RLL()  bad design...
;
;Experiment in Caller id in ^dgmg  - removed, ?bug in SFL^dgmg 13oct20
  
X    zsh :A D ^dvcaller DO  ;  This is Call Sequence in Utility  sic A bad choice of var  %A?
    .NEW:1 RSZ,Rc,TRc,R2c,TR2c,R,FLn,L2n
    .MERGE RSZ=A("S")  ;remove first subscr "S"
    .I $G(RSZ(1))'["SFL" D b^dv("Err Caller","RSZ(1)")
    .S Rc=$G(RSZ(2))
    .S TRc="" I Rc["^" S TRc=$T(@Rc)
    .S R2c="",TR2c="" I Rc["FL" S R2c=$G(RSZ(3))
    .  I R2c["^" S R=Rc,Rc=R2c,R2c=R,RcTR2c=TRc,TRc=$T(@Rc)
    .S FLn=$P(TRc,"FL(",2),FLn=$P(FLn,")"),L2n=$P(FLn,",",2),FLn=$P(FLn,",")
    .;D b^dv("SFL Log:","Rc,TRc,R2c,TR2c,FLn,L2n,SFL,L2")
    .I FLn'="",Rc'="" S RLL(FLn,Rc)=TRc  ; first crack
