dmnIMG  ;CKW/ESC  i1mar21 gmsa/ rmenu3/ ; 20210301-92 ; *FL for ^mnu*
;  was in IMG^dmnCom
;
top  ;D IMG^dmnCom
     S curFL="mSysCur_^MNU(0)"
     S msys0FL="mmo,curmab,mnL,mpreLR,zro_^MNU(mSys,0)"     
     S mabFL="dPRP,dDE,dnxt1_^MNU(mSys,mab)" 
     S opFL="dopLR,dopMnu,dopab,dopde,dnxt2_^MNU(mSys,mab,moi)"
     ;
     D T^dws("msys0FL:mmo,curmab,mnL,mpreLR,zro_^MNU(mSys,0)")
     D T^dws("mabFL:dPRP,dDE,dnxt1_^MNU(mSys,mab)")
     D T^dws("opFL:dopLR,dopMnu,dopab,dopde,dnxt2_^MNU(mSys,mab,moi)")
     Q
;*
;^MNU("tdProd",0,"curmab")="mm"
;^MNU("tdProd",0,"mmo")="#"
;^MNU("tdProd",0,"mnL")="mm,config,g,mem,rep,test"
;^MNU("tdProd",0,"mpreLR")="^dmnDIS"
;^MNU("tdProd",0,"zro")=

;
