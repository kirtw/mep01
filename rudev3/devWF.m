devWF(RIL,devwf) ;CKW/ESC  i23aug20 gmsa/ rd2io/ ; 20200823-82 ; Write File from Array
;$$Q     Arg .RIL by ref  vs Array name ala devRD
;
A    NEW Q,nW,wi,L  S Q=""
     ;
     I $G(RIL)="" S Q="RIL missing" D b^dv(Q,"RIL,devwf") Q Q
     S Q=$$OFW^devIO(devwf) I Q'="" D b^dv("Err open to write ","Q,devwf") Q Q
     ;
     DO  ; Do one of two modes
        .I $D(RIL)'>9 D IR1 Q
        .D IR2
     S Q=$$CFM^devIO(devwf) I Q'="" Q Q
     USE $P
     Q Q
;*  Arg by Ref .RIL variant
IR1  S nW=@RIL
     F wi=1:1:nW S L=$G(RIL(wi)) USE devwf W L,!
     Q
;* Passes Array name as literal RIL     
IR2  S nW=RIL  ; # nodes in @RIL
     F wi=1:1:nW S L=$G(RIL(wi)) USE devwf W L,!
     Q
;*  twf. in MRmenu
TWF  KILL WM
     S WM(1)="This is a test"
     S WM(2)="This is more of the test"
     S WM=2
     S dev="WMtest.txt"  ; in gmma/x/
     S dev2="WMtest2.txt"  ; in gmma/x/
     S Q=$$^devWF(.WM,dev) I Q'="" G Q
     S Q=$$devWF("WM",dev2) I Q'="" G Q
     ;
Q    I Q'="" D b^dv("Err TWF","Q,dev")
     Q
