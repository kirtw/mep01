;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;								;
; Copyright 2001, 2006 Fidelity Information Services, Inc	;
;								;
; Copyright (c) 2018 YottaDB LLC and/or its subsidiaries.	;
; All rights reserved.						;
;								;
;	This source code contains the intellectual property	;
;	of its copyright holder(s), and is made available	;
;	under a license.  If you do not know the terms of	;
;	the license, please stop and do not read further.	;
;								;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
%patcode	; ; ; Pattern Code Control
	;
get()	q $v("PATCODE")
	;
set(tab)
	n ok,$et
	s $et="s $ec="""" s ok=0",ok=1
	i ok v "PATCODE":tab
	q ok
