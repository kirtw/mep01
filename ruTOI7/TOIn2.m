TOIn2  ;CKW/ESC
;  wd, WD, wki : dQ, Wr
;
;
top  S nwd=$TR(wd,",")
     I nwd?1.n!(-nwd?1.n) D S9^TOIp("int",nwd,"?n") Q
     I +wd=wd D S9^TOIp("num",wd,"+wd") Q
     I wd["$" 
      
