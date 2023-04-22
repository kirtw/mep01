TOIcom(Txi)  ;CKW/ESC  i12aug18 gmsa/ rTOI7/ ; 20180812-32 ; Modify Txi for Comment, $C(9,13)
  ;       Call by Ref dot Txi;  20sep20 dverr -> deverr
  ;
A   I $G(Txi)="" D:$D(Txi)=0 ER("Undef Text ?","Txi") S Txi="" Q
    S Tcom=""
    I Txi["#" S:$E(Txi)="#" Tcom=Txi,Txi="" S:Txi[" # " Tcom=$P(Txi," # ",2,9),Txi=$P(Txi," # ") Q:Txi=""
    S Txi=$TR(Txi,$C(9,13)," ")
    Q
;*
ER(M,VL) D ^deverr($G(M),$G(VL)) Q

     