gtIpg	;CKW/ESC  i15Jan16 ; 20160116-29 ; Manage Page Names
  ;
  ;Potential Parameters-
  ; SYS		{TP7r, U412, T1u, ...}
  ; Vers
  ; TimeStamp
  ; Dir
  ; NaApp 
  ; foid
  ; MRou
  ; MGbl
  ; VarList
  ; pty   Page Type - creator MRou  ~ Label here ?  ^gt* individually
  ;
  ;  fil=$$gt   : wFil
gt(SYS,pty)  I $G(pty)="" B  Q
  I $G(SYS)="" B  Q
  I "T7r,TP7r,U412"'[SYS S zro=$zro d ^dv("SYS","SYS,zro")  Q
  I $L(pty)>10 d b^dv("pty $L","pty,SYS,zro") Q
  S fil="gt-"_SYS_"-"_pty_".html"
    S wFil="gtmu/"
  Q fil
  ;
