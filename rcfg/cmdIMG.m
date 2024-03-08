cmdIMG ;CKW/ESC i23jun23 umad./ rcfg/ ;2023-0623-62;  HGen CMD Practice records TOC pages db
;
;
;
top   S dirFL="dna,durl,di,dde,dtxt,nfi,ffi,dnsl_dirA(dnax)"
      S filFL="fil,fna,fnax,fext,ffi,fde,furl,hurl,ftxt,fnsl,fndt_filX(dfi)"
      ;
      S VVL="dirFL,filFL"
      Q
;*   By caller, once each startup ^cmdMenu    
audFL D ^cmdIMG,^kfmUafl("umad")  ; 2nd arg Save MRou code (not yet)
      Q
;*
Q    Q:$Q Q  Q:Q=""  ;falls thru
Qb   D b^dv("Err ^"_$T(+0),"zrid,pid,PB,W2B")
     Q:$Q Q  Q
;*      
;*
FKILL(pid)  NEW Q S Q=""
      I $G(pid)="" S pid="0kw"
;*  Delete All secondary HGen files in ww2mbr/  *.*2.html
F2KILL(W2x)  NEW Q I $$arg^cmds("W2x") Goto Qb
        S zsy1="cd "_W2x_"; rm -v *2.html" 
        S zsy2="cd "_W2x_"; rm -v *2.txt"         
          D ^dv("Log zsy ","zsy1,zsy2,W2x")
        ZSY zsy1 
        ZSY zsy2
        Goto Q      
;*
IKILL ;
      ;Interactive ?
      ;KILL ^?
      Q
;*
;*   Arrays not mGbls di, dfi are transient, 
;*   dnax not stable yet, still seq-dependent
;;dirA(dnax)  Main directory Analysis Array, cmd subfunctions
;;filFL(dfi)  Main db for FIles in MR3a/ <pid> /  Structures
;;Dxurl(durl)=dnax  Index durl/unique-key to data key di
;;Dxax(dnax)=dnax   Index mnemonic key dnax to di
;;
;;filX(dfi)  Main File db fields
;;fi   is sequential file id within its parent sundir
;;dfi  is di-fi where each is sequential, Array -not mGbl subscript
;;
;;Fxurl(furl)=dfi   Index furl to dfi data
;;fnax is mnemonic and unique key fo files, ? to fna
;;Fxax(fnax)=fna  Index fnax to find unique fnax from fna
;;Fx1ax(fnax)=furl  .mdk primary file
;;Fx2ax(fnax)=furl  .*2.html  compiled file
;;
;;DDun(di)=1 vs $G() when already used in HGen Output
;;FDun(dfi)=1  for Files already included
;;
;;
      
