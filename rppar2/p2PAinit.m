p2PARinit ;CKW/ESC i26mar24 umep./ rppar2/ ;2024-0401-45;Init SR for Parser
;
;
;
Init  D IKILL
      D Istb
      Q
;*
IKILL   KILL STK S StkP="0?"
      KILL PTx  
      Q
;*
Istb   D stbtse^pps  ; "tse"
    D stb^dv3("InitGRAB","grab:10,StkP:4,grts:4,grde:20")
    D stb^dv3("grabPASS","QB:3,grab:10,gran:10,grts:4,grte:4,gropsr:10,#")
      ;  Rn:4,grulst:25,tok:8,toty:2,
    D stb^dv3("grabFAIL","QB:10/,grab:10,QB:10,QG:10,QT:10,#")
    D stb^dv3("InitGRAN","gran:10,StkP:4\,gnts,grts,grulst:25,#")
    D stb^dv3("granPASS","QN:3,gran:10,gnC:10,gnts:3,gnte:3,Rn:4,grulst:25,tok:8,toty:2,gropsr:10,#")
    D stb^dv3("granFAIL","QN:10,gran:10,Rn:4,grulst:25,tok:8,toty:2,gropsr:10,#")
    D stb^dv3("InitTOK","tok:8,toty:4,gran:8,Rn:3,grulst:20")
    D stb^dv3("termPASS","gnn:10,gran:10,Rn:4,grulst:25,tokt:8,toty:2,gropsr:10,gnC:10,gnts:3,gnte:3")
    D stb^dv3("termFAIL","gnn:10,grab:10,gran:10,Rn:4,grulst:25,tok:8,toty:2,gropsr:10,#")
    D stb^dv3("StkP","StkP:3,grab:10,Gn:3,gran:10,grulst:25,Rn:4,tok:8,toty:2,gropsr:10")
    Q
;*
