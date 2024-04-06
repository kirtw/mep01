ppPgrab(grab,StkP) ;CKW/ESC umep./ rppar1/ ;2024-0401-45;TRVgrab/top and TRVgran modules
;  : QB output, null pass, else fails parse,  $$ is Q Error/bug, grammar error
;
;  : QB null pass, else fails
top   NEW Q,QN I $$arg^pps("grab,StkP") G Qb
        ; Process TKv(tki, vs grab  Recursive
        NEW grde,grri,grnun,grun,gran,grulst,gropsr,Rn,tok,toty,gn ; not grts,grte,grstr
        NEW QN  ;must be set by 
        S grun=1 S QB="??"  S grts=tki
        D GFL^kfm(grabFL) ; GRv(grab : grde, grnun  
        D bln^dv3("InitGRAB")
        F gn=1:1:grnun DO  I QN="" D grabPASS G QB
          .S grun=gn,gran=grab_"."_grun 
          .S Q=$$^ppPAgran(gran)   ; QN, gnts,gnte
        ;If finishes alt list, grun) without passing, fails grab QB still "??"
        D grabFAIL  
QB      I QB="??" S Q="Err no QB set" D b^dv(Q,"QB,grab") G Qb
        G Q
;*
Q      Q:$Q Q Q:Q=""
Qb     D b^dv("Err ^"_$T(+0),"Q,RG,devrg,gi,grab,gran") Q:$Q Q  Q
;*      
;;grabFL:grde,grnun,grri_GRv(grab)
;*  grab, gran (grun),     Passed one of alts/grans so grab PASSes
grabPASS S QB=""
        S grte=$G(gnte)
          ; xx S grts=$G(gnts)
        D bln^dv3("grabPASS")    
        ;D pze^pps("Pop gnts","gran,grts,gnts,grte,gnte,gnn,grC")        
        Q
;*
grabFAIL S QB="Failed "_grab_" x"_gn 
        D bln^dv3("grabFAIL")
        D pze^pps("grabFAIL: Syntax Err?","QB,grab,gran,tki,TKc,StkP")
        Q



