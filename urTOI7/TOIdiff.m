TOIdiff(d1,d2)  ;CKW/ESC  i23jan18 ; 20180123-02 ; Diff d2-d1 time interval
  ; d1, d2 both ?12n
  I $G(d1)'?12n D b^dv("Err d1 fmt ?12n","d1,d2") Q
  I $G(d2)'?12n D b^dv("Err d2 fmt ?12n","d2,d1") Q
;  d1,d2 :  dy, hr, min  diff d2-d1
A  NEW bhr,bdy
   S (bhr,bdy)=0
   S dh1=$$d8dh^dd($E(d1,1,8)),dh2=$$d8dh^dd($E(d2,1,8))
   S min=$E(d2,11,12)-$E(d1,11,12) I min<0 S min=min+60,bhr=-1
   S:min?1n min=0_min
   S hr=$E(d2,9,10)-$E(d1,9,10)+bhr I hr<0 S bdy=-1,hr=hr+24
   S:hr?1n hr=0_hr
   S dy=dh2-dh1+bdy
   Q
;*
T  S d1=201801212300,d2=201801220100,A="0,2,0" D A,W
   S d1=201801212300,d2=201801240100,A="2,2,0" D A,W
   S d1=201801212300,d2=201801222300,A="1,0,0" D A,W
   S d1=201801212355,d2=201802220105,A="31,1,10" D A,W
   W:$X ! W "Completed Series T^TOIdiff",!
   Q
;* Write on Error
W  W:$X ! I (+dy'=$P(A,","))!(+hr'=$P(A,",",2))!(+min'=$P(A,",",3)) DO
      .D b^dv("Err ","A,dy,hr,min,d1,d2")
   Q
   
   