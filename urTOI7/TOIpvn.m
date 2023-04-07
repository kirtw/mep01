TOIpvn ;CKW/ESC i22mar23 gmsa./ rTOI7/ ;20230322-98; Vty, vde for TOI Vars
;
;
;
top    D ^kacIMG
       Q
;*
;;toiFL xxFL Simple vars in ^TG(tsid) compiled from TOI TFL Syntax
;;
;;tsid  identifies a TOI line type/Syntax  by ^TOIa Assemble, used by ^TOIp, ^TOId
;;
;;sTFL cdl-vnSyntax Syntax for TOI vn List   vn with pfx or sfx punct, /vnty
;;~TFL cdl-vn simple vars comma-delimited list
;;vki int piece num for var in TFL
;;vn vn is the simple field name in piece vki, MGbl subscr and @vn is local var
;;vnty vc is the general type to be matched to var vn {de,d12,d8,num,int,dol,nafl,nalf, ema,tel...}
;;wki int is word number in Tin/T/L  input string to parse into fields, after $DSP
;;Wpnd(wki) Init =1 ea wki, killed when Used and assigned to vnty and maybe vn
;;WD(wki) str is cased val ue of word wki
;;Wlc(wki) slc is $$LC(WD)  lower case word
;;Wr(wki) tvn is result value from word wki, eg d8 ?8n, ...
;;Wty(wki) vc {de,num,dol,d12,d8, } is vnty pattern id
;;Wvn(wki) vn field name assigned from this word
;;Wtr(wki) str is trace of processes, Ltr
;;
