dvzb(%cb,%VL) ;CKW/ESC i13oct20 gmsa/ rd2vl/ ; 20201013-77 ; zb target sr
;
;    Caller  ZSH S:%AZSH D ^dvzb   vs zb  Alt
;    Maily list vars in %VL, %VL could come from %cb & ^Q* something
;    Eg  zb QS^dgmg:"D ^dvzb(""SFL^dgmg"","G,FL,SFL,%vi,%vn,%val,%old")
;
;
A     ;I $D(%AZSH)=0 S Q="Caller Utility Error ^"_$T(+0) USE $P W:$X ! W Q,! B  Q  ;
      NEW %vi,%vn,%val,%D
      S %cb=$G(%cb)  ; MRou code block  mrou-label
      S %VL=$G(%VL)
      D DVL
      Q
;*
DVL   F %vi=1:1:$L(%VL,",") S %vn=$P(%VL,",",%vi) I %vn'="" D V1
      W Q
      Q
;*
V1    W:$X !
      S %val=$G(@%vn),%D=$D(@%vn)
      I %D=0 S %val="<UNDEF>"
      I %D=10 S %val="<UNDEF x Array>"
      W %vn,": ",%val,!
      