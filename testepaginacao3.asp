<%
Dim rsSelectPag, sqlSelectPag

Dim vErroPagina, vErroPaginaDescricao

Dim vTotalReg, vPagina, vLegenda, vTotalPag, vcorlinha

%><!--#include file="bib_clayton_teste/bib_asp/bib_legendapaginacao.asp"--><%
%><!--#include file="bib_clayton_teste/bib_conexao/testeconexao.asp"--><%
%><!--#include file="bib_clayton_teste/bib_acesso/bib_crsenha.asp"--><%
%><!--#include file="bib_clayton_teste/bib_asp/bib_funcao_paginacao.asp"--><%
vcorlinha =  "#F0F7FF"
Call Abre_Teste
sqlSelectPag = "SELECT " 
sqlSelectPag = sqlSelectPag & " * FROM art_clayton_cadusuario"
sqlSelectPag = sqlSelectPag & " ORDER BY usu_nome"

Set rsSelectPag = Server.CreateObject("ADODB.Recordset")

rsSelectPag.CursorLocation  = 3
rsSelectPag.PageSize 		= 5'qtd de registros por página

rsSelectPag.open sqlSelectPag,objTeste,3,3

vTotalReg = rsSelectPag.RecordCount 'total de registros
vTotalPag = rsSelectPag.PageCount



While Not rsSelectPag.Eof

	If 	vStrNomes <> "" Then
		vStrNomes = vStrNomes & "," 
	End If
	vStrNomes = vStrNomes &"'"&Trim(rsSelectPag("usu_nome")&" "&rsSelectPag("usu_sobrenome"))&"'"
	
	If 	vStrEmail <> "" Then
		vStrEmail = vStrEmail & "," 
	End If
	vStrEmail = vStrEmail &"'"&Trim(rsSelectPag("usu_email"))&"'"
'--------------------------------------------------------------------------------	
	If rsSelectPag.absoluteposition < rsSelectPag.RecordCount Then
		If 	vStrSobreNomes <> "" Then
			vStrSobreNomes = vStrSobreNomes & ", " 
		End If
	Else
		vStrSobreNomes = vStrSobreNomes & " e " 
	End If
	vStrSobreNomes = vStrSobreNomes &Trim(rsSelectPag("usu_sobrenome"))
rsSelectPag.moveNext
Wend
'Response.Write(vStrNomes&"<br><br><br><br>")
'Response.Write(vStrSobreNomes&"<br><br><br><br>")
'Response.Write(vStrEmail)

If rsSelectPag.eof and rsSelectPag.bof Then
	vErroPagina = 1
	vErroPaginaDescricao = ""
Else

	vPagina = (Request.Form("hidpagina"))
	If vPagina = "" Then
		vPagina = (Request.QueryString("prmpag"))
		if vPagina = "" then
			vPagina = 1
		End If			
	End If
	If Cint(vPagina) > vTotalPag Then
		vPagina = rsSelectPag.PageCount 
	End If
	rsSelectPag.AbsolutePage = vPagina
	vContador 			= 1
'Response.Write( "vTotalReg"& vTotalReg& "<br>"& "vPagina" &vPagina& "<br>"& "vTotalPag "& vTotalPag)

	vLegenda = fnLegendaPaginacao(rsSelectPag.PageSize,vTotalReg,vPagina,"Ligação")
	vLegenda = replace(vLegenda,"Localizado","Localizada")
	vLegenda = replace(vLegenda,"Ligaçãos","Ligações")
End If
%>
 <style>
	a:link    {color:#000066; text-decoration: none;}
	a:visited {color:#000066; text-decoration: none;}
	a:hover   {color:#FFCC00; text-decoration: none;}
	a:active  {color:#000066; text-decoration: none;}
	td
	{
		font-family:Verdana;
		font-size:10px;
		color:#000066;
	}
	th
	{
		font-family:Verdana;
		font-size:11px;
		color:#000066;
	}
</style>
<table width="544" border="0" align="center">
  <tr> 
		<td width="287"><%=("<font color=""#000066"" size=""1"" face=""Verdana""><strong> Página " & vPagina & " de " & vTotalPag & " </strong></font> - ")%></td>
		<td width="265" align="right"><font color=""#006600"" size=""2"" face=""Verdana""><strong><%="<font color=""#000066"" size=""1"" face=""Verdana""><strong>"&fnLegendaPaginacao(rsSelectPag.PageSize,rsSelectPag.RecordCount,vPagina,"Registro")& " </strong></font> "%></strong></font></td>
	</tr>
</table>
<table width="543" border="0" style="border:solid #000066 1px;" align="center">
	<tr> 
		<td colspan="2" align="center" background="imagens/borda_h[1].jpg"><strong>Teste de paginação</strong></td>
	</tr>
	<tr> 
		<td colspan="2" style="font-size:1; background:#000066; height:2px;"></td>
	</tr>
	<tr align="left" bgcolor="#DCDCDC">
		<th>Nome</th>
		
    <th>Sobrenome</a></th>
	</tr>
	<%
	While Not rsSelectPag.eof And vContador <=rsSelectPag.pagesize%>
	<tr bgcolor="<%=vcorlinha%>">
		<td>
			<%=rsSelectPag("usu_nome")%>
		</td>
		<td>
			<%=rsSelectPag("usu_sobrenome")%>
		</td>
	</tr>
	<%
	vContador = vContador + 1
	rsSelectPag.movenext
	If vcorlinha = "#F0F7FF" Then
		vcorlinha = "#DCECFD"
	Else
		vcorlinha = "#F0F7FF"
	End If
	Wend
	%>
	<tr>
		<td width="162"></td>
		<td width="369"></td>
	</tr>
	<tr> 
	  
 	<td colspan="2" style="font-size:1; background:#000066; height:2px;"></td>
	</tr>
	<tr align="center">
		<td colspan="2" background="imagens/pagebar[1].jpg">
	<%=fnpaginacao(vPagina)%>
 		</td>
	</tr>
</table> 
<%
Call Fecha_Teste
%>
 
<div style="position:relative; top:70px; text-align:center; width: 581px; height: 253px; left: 0px;"> 
 <p>O Exemplo acima demonstra uma páginação <br>
  listando as páginas de 10 em 10 dividindo em <%=rsSelectPag.PageSize%> registros por página.<br>
  Com opções de avançar para Próxima página ou para Ultima,<br>
  voltar para Anterior ou para a Primeira, clicando em ... são <br>
  listadas as próximas 10 ou 10 anteriores páginas <br>
  <br>
  Primeira Anterior ... 01 02 03 04 05 06 [ 07 ] 08 09 10 ... Próxima Ultima </p>
 <%=fnCripSenha(":§\;&}§,&? \-^+&")%> </div>
    <%'=fnSenhaCrip("VISUALIZAR SENHA")%> </div>
 
