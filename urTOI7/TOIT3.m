TOIT3  ;CKW/ESC  i13oct19 ; 20191013-05 ; FUrther Test Profiles for ^TOI*
   ; in gmsa/  rTOI7/   data like ^TOIT2
RTX  ; Tset ?
     KILL TCL  S TCL=0
     F iT=1:1 S T=$T(TESpat+iT)  Q:T'[";;"  DO  ;
     .S L=$P(T,";;",2,9) I L="" Q
     .S TCL=TCL+1,TCL(TCL)=L
   Q
;*
;*  Test ^TOI Pattern List (Null Tset)
;  Note PL!Tin  does all 3 Sets Tin=t2, PL!  and TL!   for efficiency
;  Same line result (ejln:  once), variant formats
TESpat ;  Either vn:value or Tcmd!   vn in TvnFL  test vis VNT(vn)=vn
;;tsidT:TestTOId
;;sTFL:tesd12:dts,tesde,tesab.,/tescat_TES(tsid)
;;CA!
;;eja1:
;;eja2:
;;TA!
;;ejln:tesd12:'201910011200',tesde:'Test Date Results',tesab:'',tescat:''
;;Tin:10/1/19 12pm  Test Date Results
;;PL!
;;TL!
;;ejln:tesd12:'201910011200',tesde:'Test One Results',tesab:'tes.',tescat:'/cat1'
;;PTL!10/1 12pm Test One Results  /cat1 tes.  # def year last of 7 is tesab
;;PTL!10/1 12pm Test One Results  tes. /cat1 # def year
;;PTL!  tes.   10/1 12pm Test /cat1 One  Results  # def year
;;PTL!tes. /cat1 1Oct 12pm Test One Results  # def year
;;ejln:tesd12:'201910011200',tesde:'Test One Results',tesab:'tes.',tescat:'/cat1'
;;PTL!tes. /cat1 10/1/19 12pm Test One Results  
;;ejln:tesd12:'201910011200',tesde:'Test One Results',tesab:'tes.',tescat:'/cat1'
;;PTL! tes. /cat1 10/1/2019 12pm Test One Results  
;;ejln:tesd12:'201910010700',tesde:'descr',tesab:'',tescat:''
;;PTL!  201910010700  descr    # test date variants (only)
;;PTL!  20191001 7am  descr
;;PTL!  10/1 7  descr
;;PTL!  10/1 7a  descr
;;PTL!  10/1 07:00  descr
;;PTL!  10/1 7:00  descr
;;PTL!  10/1 0700  descr
;;PTL!  2019  descr
;;PTL!  7am  descr
;;PTL!  2019 wk40 Tue descr
;;ejln:tesd12:'201910011900',tesde:'descr',tesab:'',tescat:''
;;PTL!  20191001 7pm  descr
;;PTL!  10/1 19  descr
;;PTL!  10/1 7p  descr
;;PTL!  10/1 19:00  descr
;;PTL!  10/1 7:00pm  descr
;;PTL!  10/1 1900  descr
;;PTL!  2019  descr          # def last time
;;ejln:tesd12:'201910011901',tesde:'descr',tesab:'',tescat:''
;;PTL!  20191001 701pm  descr
;;PTL!  10/1 1901  descr
;;PTL!  10/1 701p  descr
;;PTL!  10/1 19:01  descr
;;PTL!  10/1 7:01pm  descr
;;PTL!  2019  descr          # def last time, Dlst()