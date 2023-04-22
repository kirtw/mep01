dzIMG  ;CKW/ESC  i2jun20 gmsa/ rd2zro/ ; 20200602-92 ; ^dz* zro SuperFL lists
;
;
A      S zroFL="szro,qzro,mFol,mBase,mpj,fPro,qSB,qGB,qPB,qL_^QZRO(qzid)"  ; sic vs ^mwIMG mbr ^ZWZ
       D T^dws("zroFL=szro,qzro,mFol,mBase,mpj,fPro,qSB,qGB,qPB,qL_^QZRO(qzid)")
       ;
       ;
       Q
;*$$Q  : qzid
qzidNxt()  S qzid=$G(^QZRO(0,"qzidNxt")) I qzid="" S qzid=100
           S ^QZRO(0,"qzidNxt")=qzid+1
           Q ""  ; No errors yet
;*
;*  Special Set of Folder Variables
;  RefBy: gmgu/ 
IB      S SB="/home/kw/km3a/"	; vs ^devIB
        S GB=SB_"gmsa/"
        S MB=SB_"gmma/"
        S PB=MB  ; here ?
        S WB=PB_"wwm/"
        Q
;
;  zr0FL="zzro,czro,izro,rzro,nrd,nmr,ncb,rd,devHzd_^ZWZ(zrid)"
