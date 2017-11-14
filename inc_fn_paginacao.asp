<%
'Assinatura para implementação 
'--------------------------------------------------------
'fnPaginacao(metodo, "url da pagina", Pagina atual, Total de paginas)

'   prmTotalPag:       Total de páginas geradas na lista ("PageCount" do Recordset).
'   prmPagina:         Página que será exibdida.
'   prmUrlPagina:      Caminho/pagina.asp [página que a páginação direciona].
'   prmCSSClass        Classe(s) CSS [pagination-lg pagination-sm pull-left pull-right] 
'   prmMetodoEnvio:    Post para Form ou Get para querystring.
'   prmParametros:     nome do campo : valor separados por ponto e virgula. Ex: "campo:valor;campo2:valor 2".

'Constante de dentro da Função de Paginação (Número impar no minimo 5)
'--------------------------------------------------------------
Dim constFnPagiNumeroMax ' Número máximo de botões exibidos na paginação. Ex: = 7 -- [<<][01][02][03][04][05][06][07][>>] --
'--------------------------------------------------------------

Function fnPaginacao(prmTotalPag, prmPagina, prmUrlPagina, prmCSSClass, prmMetodoEnvio, prmParametros )

    Dim vFnPagiMeio, vFnPagiSobra,vFnPagiSobraIni ,vFnPagiSobraFin
    Dim vFnPagiInicial, vFnPagiFinal, vFnPagiParametrosQuerystring
    Dim vArrayFnParametros
    Dim vFnPagHrefAction
    Dim vFnPagiRetornoHtml
    Dim vFnPagiLoopPaginas

    vFnPagiParametrosQuerystring = ""
    vFnPagiRetornoHtml = ""

    If prmTotalPag = "" Or IsNUll(prmTotalPag)  Then
        prmTotalPag = 0
    End If

    If CInt(prmTotalPag) > 0  Then
        
        If constFnPagiNumeroMax = "" Or IsNull(constFnPagiNumeroMax) Then
            constFnPagiNumeroMax = 5
        End If

        If (constFnPagiNumeroMax Mod 2) = 0 Then
            constFnPagiNumeroMax = constFnPagiNumeroMax +1
        End If
    
        If CInt(constFnPagiNumeroMax) < 5 Then
            constFnPagiNumeroMax = 5
        End If

        vFnPagiMeio = CInt(constFnPagiNumeroMax / 2)
        vFnPagiSobra = (constFnPagiNumeroMax Mod vFnPagiMeio) - 1

        If (vFnPagiSobra Mod 2 = 0) Then
            vFnPagiSobraIni =   vFnPagiSobra / 2
            vFnPagiSobraFin = vFnPagiSobraIni
        End If

        vFnPagiInicial = Trim(Request.QueryString("prmfnpagini"))
        If vFnPagiInicial = "" Then
	        vFnPagiInicial = Trim(Request.Form("hidfnpagini"))
        End If

        vFnPagiFinal = Trim(Request.QueryString("prmfnpagfin"))
        If vFnPagiFinal = "" Then
	        vFnPagiFinal = Trim(Request.Form("hidfnpagfin"))
        End If

        If prmMetodoEnvio = "" Or IsNull(prmMetodoEnvio) Then
            prmMetodoEnvio = "Get"
        End If

     '   Response.Write("prmMetodoEnvio: "&prmMetodoEnvio&"<br />")
     '   Response.Write("prmParametros: "&prmParametros&"<br />")
     '   Response.Write("prmTotalPag: "&prmTotalPag&"<br />")

        vArrayFnParametros = Split(prmParametros,";")

        If vFnPagiInicial = "" Or IsNull(vFnPagiInicial) Then
            vFnPagiInicial = 1
        End If
        If vFnPagiFinal = ""  Or IsNull(vFnPagiFinal)  Then
            vFnPagiFinal = constFnPagiNumeroMax
        End If

        If CInt(vFnPagiFinal) > prmTotalPag Then
            vFnPagiFinal = prmTotalPag
        End If   

        If CInt(prmPagina) > 1  Then
            If CInt(vFnPagiInicial) = CInt(prmPagina)  Then
                vFnPagiInicial = prmPagina  - vFnPagiMeio + vFnPagiSobraIni
                vFnPagiFinal = prmPagina + vFnPagiMeio - vFnPagiSobraFin
            
                If CInt(vFnPagiInicial) < 1  Then
                    vFnPagiInicial = 1
                    If CInt(constFnPagiNumeroMax) < prmTotalPag  Then 
                        vFnPagiFinal = constFnPagiNumeroMax
                    Else 
                        vFnPagiFinal = prmTotalPag
                    End If
                End If
            End If

            If (CInt(vFnPagiFinal) = CInt(prmPagina)) And (CInt(vFnPagiFinal) < prmTotalPag)  Then
                vFnPagiInicial = prmPagina  - vFnPagiMeio + vFnPagiSobraIni
                vFnPagiFinal = prmPagina + vFnPagiMeio - vFnPagiSobraFin
                If CInt(vFnPagiFinal) > prmTotalPag  Then
                    vFnPagiInicial = (prmPagina  - vFnPagiMeio + vFnPagiSobraIni) - (vFnPagiFinal - prmTotalPag)
                    vFnPagiFinal = prmTotalPag
                End If
            End If
        End If

        If prmMetodoEnvio = "Get" Then
            vFnPagiParametrosQuerystring = fnMontaParametros(prmMetodoEnvio, vArrayFnParametros)  
        End If

        
        vFnPagiRetornoHtml = "<nav aria-label=""Page navigation"">"
        vFnPagiRetornoHtml = vFnPagiRetornoHtml & "  <ul class=""pagination " & prmCSSClass & """>"
        If prmPagina > 1 Then
            vFnPagiRetornoHtml = vFnPagiRetornoHtml & "    <li class=""page-item"">"
            vFnPagiRetornoHtml = vFnPagiRetornoHtml & "      <a class=""page-link"" href="&fnMontaHrefAction(prmMetodoEnvio,prmUrlPagina,(prmPagina - 1),vFnPagiInicial,vFnPagiFinal)& vFnPagiParametrosQuerystring &" aria-label=""Previous"">"
            vFnPagiRetornoHtml = vFnPagiRetornoHtml & "        <span aria-hidden=""true"">&laquo;</span>"
            vFnPagiRetornoHtml = vFnPagiRetornoHtml & "        <span class=""sr-only"">Anterior</span>"
            vFnPagiRetornoHtml = vFnPagiRetornoHtml & "      </a>"
            vFnPagiRetornoHtml = vFnPagiRetornoHtml & "    </li>"
        Else
            vFnPagiRetornoHtml = vFnPagiRetornoHtml & "    <li class=""page-item disabled"">"
            vFnPagiRetornoHtml = vFnPagiRetornoHtml & "      <a class=""page-link"" href=""#"" aria-label=""Previous"">"
            vFnPagiRetornoHtml = vFnPagiRetornoHtml & "        <span aria-hidden=""true"">&laquo;</span>"
            vFnPagiRetornoHtml = vFnPagiRetornoHtml & "        <span class=""sr-only"">Anterior</span>"
            vFnPagiRetornoHtml = vFnPagiRetornoHtml & "      </a>"
            vFnPagiRetornoHtml = vFnPagiRetornoHtml & "    </li>"
        End If
        For vFnPagiLoopPaginas = vFnPagiInicial To vFnPagiFinal
            If CInt(vFnPagiLoopPaginas)=CInt(prmPagina) Then
                vFnPagiRetornoHtml = vFnPagiRetornoHtml & " <li class=""page-item active""><a class=""page-link"" href=""#"">" & Right("0"& vFnPagiLoopPaginas,2) & "</a></li>"
            Else
                vFnPagiRetornoHtml = vFnPagiRetornoHtml & " <li class=""page-item""><a class=""page-link"" href="&fnMontaHrefAction(prmMetodoEnvio,prmUrlPagina,vFnPagiLoopPaginas,vFnPagiInicial,vFnPagiFinal)& vFnPagiParametrosQuerystring &">" & Right("0"& vFnPagiLoopPaginas,2) & "</a></li>"
            End If
        Next
        If CInt(prmPagina) <> CInt(prmTotalPag) Then
            vFnPagiRetornoHtml = vFnPagiRetornoHtml & "    <li class=""page-item"">"
            vFnPagiRetornoHtml = vFnPagiRetornoHtml & "      <a class=""page-link"" href="&fnMontaHrefAction(prmMetodoEnvio,prmUrlPagina,(prmPagina + 1),vFnPagiInicial,vFnPagiFinal)& vFnPagiParametrosQuerystring &" aria-label=""Next"">"
            vFnPagiRetornoHtml = vFnPagiRetornoHtml & "        <span aria-hidden=""true"">&raquo;</span>"
            vFnPagiRetornoHtml = vFnPagiRetornoHtml & "        <span class=""sr-only"">Próximo</span>"
            vFnPagiRetornoHtml = vFnPagiRetornoHtml & "      </a>"
            vFnPagiRetornoHtml = vFnPagiRetornoHtml & "    </li>"
        Else
            vFnPagiRetornoHtml = vFnPagiRetornoHtml & "    <li class=""page-item disabled"">"
            vFnPagiRetornoHtml = vFnPagiRetornoHtml & "      <a class=""page-link"" href=""#"" aria-label=""Next"">"
            vFnPagiRetornoHtml = vFnPagiRetornoHtml & "        <span aria-hidden=""true"">&raquo;</span>"
            vFnPagiRetornoHtml = vFnPagiRetornoHtml & "        <span class=""sr-only"">Próximo</span>"
            vFnPagiRetornoHtml = vFnPagiRetornoHtml & "      </a>"
            vFnPagiRetornoHtml = vFnPagiRetornoHtml & "    </li>"
        End If
        vFnPagiRetornoHtml = vFnPagiRetornoHtml & "  </ul>"
        vFnPagiRetornoHtml = vFnPagiRetornoHtml & " </nav>"

        If prmMetodoEnvio = "Post" Then
            vFnPagiRetornoHtml = vFnPagiRetornoHtml & " <form method=""post"" name=""frmFnPaginacao"" id=""frmFnPaginacao"" action="&prmUrlPagina&">"
            vFnPagiRetornoHtml = vFnPagiRetornoHtml & "     <input type=""hidden"" name=""hidfnpagini"" id=""hidfnpagini"" value="&vFnPagiInicial&" />"
            vFnPagiRetornoHtml = vFnPagiRetornoHtml & "     <input type=""hidden"" name=""hidfnpagfin"" id=""hidfnpagfin"" value="&vFnPagiFinal&" />"
            vFnPagiRetornoHtml = vFnPagiRetornoHtml & "     <input type=""hidden"" name=""hidpagina"" id=""hidpagina"" value="""" />"
            vFnPagiRetornoHtml = vFnPagiRetornoHtml &       fnMontaParametros(prmMetodoEnvio, vArrayFnParametros)  
            vFnPagiRetornoHtml = vFnPagiRetornoHtml & " </form>"

            vFnPagiRetornoHtml = vFnPagiRetornoHtml & " <script type=""text/javascript"">"
            vFnPagiRetornoHtml = vFnPagiRetornoHtml & "    function fnSubmitPaginacao(prmJsPagina) {"
            vFnPagiRetornoHtml = vFnPagiRetornoHtml & "        document.getElementById(""hidpagina"").value = prmJsPagina;"
            vFnPagiRetornoHtml = vFnPagiRetornoHtml & "        document.getElementById(""frmFnPaginacao"").submit();"
            vFnPagiRetornoHtml = vFnPagiRetornoHtml & "    }"
            vFnPagiRetornoHtml = vFnPagiRetornoHtml & " </script>"
        End If
    End If

    fnPaginacao = vFnPagiRetornoHtml

End Function

Private Function fnMontaHrefAction(prmMetodo, prmUrlPagina,  prmPagina, prmPagiInicial, prmPagiFinal)
    Dim vFnHrefActionRetornoHtml
    vFnHrefActionRetornoHtml = ""
    If prmMetodo = "Get" Then
       vFnHrefActionRetornoHtml = prmUrlPagina&"?prmpag=" & (prmPagina) & "&prmfnpagini="&prmPagiInicial&"&prmfnpagfin="&prmPagiFinal 
    Else
        vFnHrefActionRetornoHtml = "javascript:fnSubmitPaginacao("&prmPagina&");"
    End If
    fnMontaHrefAction = vFnHrefActionRetornoHtml
End Function

Private Function fnMontaParametros(prmMetodo,prmParametros)
    Dim vFnParametrosRetornoHtml
    Dim vFnPagiLoopArrayParametros
    Dim vArrayFnCamposValores

    For vFnPagiLoopArrayParametros = 0 to UBound(prmParametros)
        vArrayFnCamposValores   =   Split(prmParametros(vFnPagiLoopArrayParametros),":")
        If prmMetodo = "Get" Then
            vFnParametrosRetornoHtml = vFnParametrosRetornoHtml & "&" &vArrayFnCamposValores(0)&"="&Server.URLEncode(vArrayFnCamposValores(1))&""
        Else
            vFnParametrosRetornoHtml = vFnParametrosRetornoHtml & "  <input type=""hidden"" name="""&vArrayFnCamposValores(0)&""" id="""&vArrayFnCamposValores(0)&""" value="""&vArrayFnCamposValores(1)&""" />"
        End If
    Next

    fnMontaParametros = vFnParametrosRetornoHtml
End Function

%>
