cmdIpg ;CKW/ESC i23jun23 umad./ rcfg/ ;2023-0623-62; Page Names from params ^cmd
;
;
;
;DIR TOC pages - param dna   ->href for link, to hgen the page
; cDIR-dna-pid.2.html  : devdna
dna(dna,pid) NEW Q I $$arg^cmds("dna,pid") G Qb
      S dev="cDIR-"_dna_"-"_pid_".c2.html"
      S devdna=dev
      G Q
;*
Qb  D b^dv("Err ^"_$T(+0),"Q,pid,dev,fil,fol") Q:$Q Q  Q
Q   Q:$Q Q Q:Q=""  G Qb
;*
;* PtB, pid : devolf
olf(pid,folf) NEW Q,dev I $$arg^cmds("pid") G Qb
   I $G(PtB)="" D ERIB I $G(PtB)="" G Qb
   S fil=$G(folf)
   I fil="" S fil="CMD-TOC-"_pid_".olf"  ;default
   S dev=PtB_"aid/"_fil
   S s=$ZSEARCH(dev) I s="" S Q="Cannot find devolf file "_dev G Qb
   S devolf=dev
   G Q
;*  PtB undef
ERIB  ;     vs PtB^cmdIO(pid)   ; : PtB and W2B
   S PtB="/home/kw/MR3a/"_pid_"/"
   Q
;*  ; devTOC
TOCpid(pid) NEW Q I $$arg^cmds("pid") G Qb
   D ERIB  ; pid : PtB
   S fil="HTOC-"_pid_".2.html"
   S fol="ww2mr/"
   S devTOC=PtB_fol_fil
   G Q
