hghTest  ;CKW/ESC i19jul22   gmsa/ rhgen4b/ ;20220719-40;Tests for ^hgh code
;
;
;
;*  Test encoding of < > &
enc(Qt) S Qt=$G(Qt)
      S X="123<456",Ye="123&lt;456" D TE
      S X="123<>456",Ye="123&lt;&gt;456" D TE
      S X="123><456<>777",Ye="123&gt;&lt;456&lt;&gt;777" D TE
      S X="<123<456>",Ye="&lt;123&lt;456&gt;" D TE
      S X="<>",Ye="&lt;&gt;" D TE
      S X="123<456&789",Ye="123&lt;456&amp;789" D TE
      S X="123<&>456&789",Ye="123&lt;&amp;&gt;456&amp;789" D TE
      Q
TE    S Ya=$$enc^hgh(X)  I Ya'=Ye D b^dv("Error enc^hgh ","X,Ye,Ya")
      Q
;*
