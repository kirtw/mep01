dzzl(zro)   ;CKW/ESC i7sep20 gmsa/ rzro3/ ; 20200907-80 ; Start sequence zdir, delo, mumps/gtm compile Pause
;	chg order dzMdup 16sep20
;  RefBy:   ^gma 
;
A     I $G(zro)="" S zro=$zro D b^dv("Default $zro vs arg","zro")  
  ;
z5    NEW sdir,odir,zBase,zsl,zsd,mpr,mpf,zl,zd,di8,ZC,ZRM
      D ^dzroz(zro) ;  zro : zdir(oi,si)
      D zdir^dzdelo()  ;  Delete $PB/o/*.o   Not ou  or gtm_dist / gtm
      D zdir^dzMdup()   ; Ck for duplicate MRou refs (hidden code)      
      D zdir^dzcomp()  ;  Compile via ZSY mumps LCmd
      S Q=$$pz  ; Pause
Qz5   KILL:1 zdir,odir,sdir,zro
      Q
;*
;*$$Q  Pauze to see results of compile-
pz()	W:$X ! W "Finished gtmy compile mumps source to o/*.o  by ^",$T(+0),!!
        NEW X
	W "Pause to see any syntax errors- ",! R X 
	I X="." Q "."
	Q ""
