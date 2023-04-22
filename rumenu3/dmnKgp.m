dmnKgp   ;CKW/ESC i4feb23 gmsa./ rmenu3/ ;20230204-30;Cleanup KILL after menu, before op start
;
;  --- NEW vs KILL kw  ok since menu starts, no caller higher level
;  NOT dopLR
menu   KILL mSys,FL,L,LR,Lop,Q,RI,T,X,curFL,curmab,dBdv,dnxt2,dvM
       KILL dwd,zro,f,mSysArg,mSysMRou,mmo,mpreVL,msys0FL,newMenu,opD,opFL,opde,vi,vn
dz     ;KILL zrid,czro,izro,izgl,rzro,wzro,zzro,mpjDir,kwsys,kwmpj,LUser
       KILL %ZSH,RXU,Ru
dv     KILL %D,%KMO,%c,%v,%vn,%zshc,VVL,dBdv,dvM,rdid,rdide,zoi
       I 0 DO  ;
         .USE $P W !! zwr  ;
         .W !!,"Add menu var cleanup?"
         .I 0 BREAK
       Q
;*



