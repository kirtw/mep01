ppPAgrab(grab) ;CKW/ESC umep./ rppar1/ ;2024-0401-45;TRVgrab/top and TRVgran modules
;  : QB output, null pass, else fails parse,  $$ is Q Error/bug, grammar error
;
;  : QB null pass, else fails
top   NEW Q,QN I $$arg^pps("grab,StkP") G Qb
        ; Process TKv(tki, vs grab  Recursive
        NEW grde,grri,grnun,grun,gran,grulst,gropsr,Rn,tok,toty,Gn ; not grts,grte
        S QB="??"   ;must be set by 
        S grts=tki,grte="?"  ; S grun=1 
        D GFL^kfm("grnun,grde",grabFL) ; GRv(grab : grde, grnun  
        D bln^dv3("InitGRAB")
        S StkP=StkP+1
        F Gn=1:1:grnun DO  I QN="" D grabPASS G QB
          .;NEW gnts,gnte
          .S grun=Gn,gran=grab_"."_grun 
          .S Q=$$^ppPAgran(gran)   ; QN, gnts,gnte
          .S grte=gnte
          .D ^dv("Post PAgran gran-grab ","gnte,grte,gran,grab,StkP")
          .I gran="Karg.1",gnte'=3 D b^dv("Err gnte","gran,gnte,grte")
          .I Q="",QN="" S QB=""
        ;If finishes alt list, grun) without passing, fails grab QB still "??"
        D grabFAIL  
QB      I QB="??" S Q="Err no QB set" D bug^dv(Q,"QB,grab,StkP") G Qb
        G Q
;*
Q      Q:$Q Q Q:Q=""
Qb     D b^dv("Err ^"_$T(+0),"Q,RG,devrg,gi,grab,gran") Q:$Q Q  Q
;*      
;;grabFL:grde,grnun,grri_GRv(grab)
;*  grab, gran (grun),    granPASS any one of alts/grans so grab PASSes
grabPASS S QB=""
        S grte=$G(gnte) 
           I grte="" D b^dv("Err grte/gnte","grab,gran,grte,gnte")
        D bln^dv3("grabPASS")    
        I grab="Karg",grte'=3 D b^dv("Err grte grabPASS","grab,gran,grte,gnte") 
        ;D pze^pps("Pop gnts","gran,grts,gnts,grte,gnte,gnn,grC")     
        ;D tse1^pps("end grabPASS",grab)   
sgrabFL  ;;sgrabFL:grab,grnun,grts,grte,grde,grri_HQT(StkP)
sgranFL  ;;sgranFL:gran,gnts,gnte,grulst_HQT(StkP)        
        D PSHb^ppPAsr  ; : STK(StkP)
        Q
;*
grabFAIL S QB="Failed "_grab_" x"_gn 
        D bln^dv3("grabFAIL")
        D pze^pps("grabFAIL: Syntax Err?","QB,grab,gran,tki,TKc,StkP")
        Q



