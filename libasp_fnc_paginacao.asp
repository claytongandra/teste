<%

Function fnpaginacao(vPagina)
	vtipo = vtipo
	var01 = Len(vPagina) 'Lê o tamanho do numero
	var02 = var01 - 1 'subtrai um da variavel , retirando o digito menos sig.
	var03 = Left(vPagina,var02) 'obtem os digitos mais  sig. do numero
	var04 = Right(vPagina,1)    'obtem o digito menos sig. do numero
	var05 = var03 & 0 ' Acrecenta ZERO no final
	If var04 <> 0 Then       ' condição se o digito menos sig. é Zero
		inicial = var05 + 1
		final = inicial + 9  
	Else
		inicial = var05 - 9  
		final = var05
	End If

	indice_i = var04 - 1 'ultimo digito  - 1
	indice_f = 10 - var04 ' 10 - digito menos sig.

	vsomaProximo = (CInt(vTotalPag) - CInt(final))

	If vsomaProximo <=10 Then
		If vsomaProximo > 1 Then
			vtexto = "Listar as próximas "& (CInt(vTotalPag) - CInt(final)) & " páginas."
		Else
			vtexto = "Exibir a próxima página."
		End If
	Else
		vtexto = "Listar as próximas 10 páginas."
	End If

If CInt(final) > CInt(vTotalPag) Then final = vTotalPag
		If vPagina > 1 Then
			'Se for a primeira página, Mostra apenas o botão Próximo e Ultima
			Response.Write("<B><font color=""#660066"" size=""1"" face=""Verdana"">") 
			Response.Write("<a href='default.asp?prmpag=" &  1 & "' title='Exibir a primeira página '>")
			Response.Write("Primeira") 
			Response.Write("</a></font></B>  ")
			
			Response.Write("<B><font color=""#660066"" size=""2"" face=""Verdana"">") 
			Response.Write("<a href='default.asp?prmpag=" & vPagina - 1 & "' title='Exibir a página anterior'>")
			Response.Write("Anterior") 
			Response.Write("</a></font></B>  ")

		If vPagina > 10 Then
			Response.Write("<B><font color=""#660066"" size=""2"" face=""Verdana"">") 
			Response.Write("<a href='default.asp?prmpag=" & inicial - 1 & "' title='Listar as 10 páginas anteriores'>")
			Response.Write("...") 
			Response.Write("</a></font></B> ")
		Else
			Response.Write("<B><font color=""#CCCCCC"" size=""2"" face=""Verdana"">") 
			Response.Write("...") 
			Response.Write("</font></B>  ")
		End If
	Else
		Response.Write("<B><font color=""#EEEEEE"" size=""1"" face=""Verdana"">") 
		Response.Write("Primeira") 
		Response.Write("</font></B>  ")
		
		Response.Write("<B><font color=""#CCCCCC"" size=""2"" face=""Verdana"">") 
		Response.Write("Anterior") 
		Response.Write("</font></B> ")
		
		Response.Write("<B><font color=""#CCCCCC"" size=""2"" face=""Verdana"">") 
		Response.Write("...") 
		Response.Write("</font></B>  ")
	End If

'---------------------- NUMEROS  ---------------------------
	For i = inicial To final
		If CInt(i)=CInt(vPagina) Then
			Response.Write "<font color=""#000000"" size=""1"" face=""Verdana"">[ <B style=""background:#EBEBEB;"">" & Right("0"& i,2) & "</B> <font color=""#000000"">]</font>  "
		End If
		If CInt(i) < CInt(vPagina) Then
			Response.Write "<font color=""#660066"" size=""1"" face=""Verdana""><a href='default.asp?prmpag=" & i & "' title='Exibir a página "& Right("0"& i,2) &" '>" & Right("0"& i,2) & "</a></font>  "
		End If
		If CInt(i) > CInt(vPagina) Then
			Response.Write "<font color=""#660066"" size=""1"" face=""Verdana""><a href='default.asp?prmpag=" & i & "' title='Exibir a página "& Right("0"& i,2) &" '>" & Right("0"& i,2) & "</a></font>  "
		End If
	Next
'------------------------------------------------------
	If CInt(vPagina) <> CInt(vTotalPag) Then
		p1 = Left(vPagina,var02) 
		p2 = Left(vTotalPag,var02)
		p3 = Left(vTotalPag,var02) & 0

			If (CInt(vTotalPag) > CInt(final)) Then 
				'Response.Write("If (p1 > vPagina) or ((vPagina <= 10) and (vTotalPag > 10)) Then ") Original
				Response.Write("<B><font color=""#660066"" size=""2"" face=""Verdana"">")
				Response.Write("<a href='default.asp?prmpag=" & final + 1 & "' title='"& vtexto& "'>")
				Response.Write("...")
				Response.Write("</a></font></B>  ") 
			
			Else
				Response.Write("<B><font color=""#CCCCCC"" size=""2"" face=""Verdana"">")
				Response.Write("...") 
				Response.Write("</font></B>  ")
			
			End If
	
		Response.Write("<B><font color=""#660066"" size=""2"" face=""Verdana"">")
		Response.Write("<a href='default.asp?prmpag=" & vPagina + 1 & "' title='Exibir a próxima página '>")
		Response.Write("Próxima")
		Response.Write("</a></font></B>  ") 
		
		Response.Write("<B><font color=""#660066"" size=""1"" face=""Verdana"">")
		Response.Write("<a href='default.asp?prmpag=" & vTotalPag & "' title='Exibir a última página '>")
		Response.Write("Última")
		Response.Write("</a></font></B> ")        
		
	Else
	
		Response.Write("<B><font color=""#CCCCCC"" size=""2"" face=""Verdana"">")
		Response.Write("...") 
		Response.Write("</font></B>  ")
		
		Response.Write("<B><font color=""#CCCCCC"" size=""2"" face=""Verdana"">")
		Response.Write("Próxima") 
		Response.Write("</font></B>  ")
		
		Response.Write("<B><font color=""#EEEEEE"" size=""1"" face=""Verdana"">")
		Response.Write("Última") 
		Response.Write("</font></B>  ")
	End If 
	
	Response.Write("<br>")
	Response.Write("var01 = Len(vPagina): "& var01 &"<br>")
	Response.Write("var02 = var01 - 1: "&var02&"<br>")
	Response.Write(" vPagina: "&vPagina&"<br>")
	Response.Write("var03 = Left(vPagina,var02): "&var03&"<br>")
	Response.Write("var04 = Right(vPagina,1): "&var04&"<br>")
	Response.Write("var05 = var03 & 0: "&var05&"<br>")
	Response.Write("inicial = var05 + 1: "&inicial&"<br>")
	Response.Write("final = inicial + 9 : "&final &"<br>")
	Response.Write("indice_i = var04 - 1: "&indice_i&"<br>")
	Response.Write("indice_f = 10 - var04: "&indice_f&"<br>")
'	Response.Write(" "&&"<br>")
'	Response.Write(" "&&"<br>")
'	Response.Write(" "&&"<br>")
'	Response.Write(" "&&"<br>")
'	Response.Write(Request.ServerVariables("HTTP_REFERER")&"<br>")
	
End Function
%>
