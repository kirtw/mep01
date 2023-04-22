devPZ(M)  ;CKW/ESC i18sep20 gmsa/ rd2io/ ; 20200918-75 ; Pause sr
;
;
;
A      I $G(M)="" S M="Pause to Review Screen."
RX     NEW %D,X S %D=$IO USE $P
       W !,M," ",!
       R "'Hit Enter' to Continue:",X
       I %D'=$P USE %D
       Q:$Q Q  Q
       