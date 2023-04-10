TOIaid(tsida)  ;CKW/ESC  i4apr18 ; 20180404-55 ; List & Audit ^TG(0 and tsid,
  ;      in gmsa/ rTOI3ucal/ 
  ;   SIC:  ^TG(0  and ^TG(tsid,  @toiFL  are TWO SEPARATE THINGS 
  ;      and within ^TG(0, (units and tsidCur ?)
  ;
  ;	Refs by ^cqDG  Menu: dix.  Duc.
  I $G(tsida)="" S tsida=$G(^TG(0,"tsidCur")) I tsida="" D bug^dv Q
  S tsid=tsida
  I $D(^TG(tsid))=0 D b^dv("tsid is UNDEF in ^TG","tsid,tsida") Q
  D D1,D2
  Q
;;toiFL:sTFL,tFL,VNmode,WQP,dictL,vnd12,d8vn,vqlst,Cpx,Csx,cdL,wtL,cTS,ctxde_^TG(tsid)  
;* tsid
D1  D ^TOIimg  ; toiFL, dtFL
    D GFL^dvs(toiFL) ; tsid : @toiFL
    D ^dv("summary ^TG(tsid, all of toiFL ","tsid,toiFL,"_toiFL)
    Q
;*  Structures  PTYpx, PTYsx, WDt(), Dict ?
D2  F ax="PTYpx","PTYsx" DO  ;
       .I $D(^TG(tsid,ax)) W:$X ! zwr ^TG(tsid,ax) W ! Q
       .W:$X ! W "UNDEF:  ^TG(tsid,'' ",ax,!
    W ! Q
;*
;*
;*     ****************
;*  ; ^TG(0,
TG0  KILL tsid W:$X ! W "Base ^TG(0 -",!
    F ax="px","sx","XUw","XUv","XUl","DWL","MOL" I $D(^TG(0,ax)) W:$X ! zwr ^TG(0,ax) W !
    Q  
