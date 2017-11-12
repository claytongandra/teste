<!--#include file="../lab_library/lib_asp_conexao/libasp_conexao_areadeteste.asp"-->
<!--#include file="../lab_library/lib_asp_functions/libasp_fnc_resumirtexto.asp"-->
<%

Response.CacheControl = "Private"
Response.Expires = 0

Dim sqlSelectPosts, rsSelectPosts
Dim vContRegistro, vPagina, vTotalReg, vTotalPag
Call Abre_AreaTeste

	sqlSelectPosts = "SELECT"
	sqlSelectPosts = sqlSelectPosts & " a.pos_id, a.pos_titulo, a.pos_postconteudo, a.pos_postcomentar,a.pos_datapublicacao," 
	sqlSelectPosts = sqlSelectPosts & " CONVERT(Char(10),a.pos_datapublicacao,103)AS pos_datapublicacao,"
	sqlSelectPosts = sqlSelectPosts & " CONVERT(Char(10),a.pos_datapublicacao,100)AS pos_datacalendario,"
	sqlSelectPosts = sqlSelectPosts & " b.cat_categoria, c.usu_nome+' '+usu_sobrenome AS autor"
	sqlSelectPosts = sqlSelectPosts & " FROM lab_claytongandra_posts AS a"
	sqlSelectPosts = sqlSelectPosts & " LEFT OUTER JOIN lab_claytongandra_posts_categorias AS b ON a.pos_fk_categoria = b.cat_id" 
	sqlSelectPosts = sqlSelectPosts & " INNER JOIN lab_claytongandra_usuarios AS c ON a.pos_fk_usuarioautor = c.usu_id"  
	sqlSelectPosts = sqlSelectPosts & " WHERE pos_status = 'P'" 
	sqlSelectPosts = sqlSelectPosts & " AND a.pos_perfil >= "&Session("TipoUsuario")
	sqlSelectPosts = sqlSelectPosts & " ORDER BY a.pos_datapublicacao DESC"  

'	Response.Write("<textarea>"&sqlSelectPosts&"</textarea>")
	Set rsSelectPosts = objAreaTeste.Execute(sqlSelectPosts)
'	Set rsSelectPosts = Server.CreateObject("ADODB.Recordset")

'	rsSelectPosts.CursorLocation  = 3
'	rsSelectPosts.PageSize 		= 2'qtd de registros por página
	
'	rsSelectPosts.open sqlSelectPosts,objAreaTeste,3,3
	
'	vTotalReg = rsSelectPosts.RecordCount 	'Total de registros
'	If Not rsSelectPosts.EOF And Not rsSelectPosts.BOF Then
'		vPagina = Request.Form("hidpagina")
'		If vPagina = "" Then
'			vPagina = 1
'		End If
'		If Cint(vPagina) > rsSelectPosts.PageCount Then
'			vPagina = rsSelectPosts.PageCount 
''		End If
	'
'		rsSelectPosts.AbsolutePage = vPagina
'		vContRegistro 	= 0
'	End If

	
%>

<%If rsSelectPosts.eof And rsSelectPosts.bof Then%>
	<ul id='erro_post'>
		<li>Nenhum Post localizado.</li>
	</ul>
<%Else
	While Not rsSelectPosts.eof%>
		<div class="post" id="post_<%=rsSelectPosts("pos_id")%>">
			<div class="posttime">
				<div class="m"><%=Left(MonthName(Month(rsSelectPosts("pos_datacalendario"))),3)%></div>
				<div class="d"><%=Right("00" & Day(rsSelectPosts("pos_datacalendario")),2)%></div>
			</div>
			<div class="posttitle">
				<span class="comment">Nenhum Comentário</span>
				<h2><a href="#" title="<%=rsSelectPosts("pos_titulo")%>" rel="bookmark"><%=rsSelectPosts("pos_titulo")%></a></h2>
				<div class="postmeta">
					<span class="category"><%=rsSelectPosts("cat_categoria")%></span>
					<span class="date"><%=rsSelectPosts("pos_datapublicacao")%></span>
					<span class="author"><%=rsSelectPosts("autor")%></span>
					<div class="postmeta_right"></div>
				</div>
			</div>
			<div class="content">
				<%=Replace(fnResumindo(rsSelectPosts("pos_postconteudo"),500),Chr(13),"<br>")%>
				<%If Len(rsSelectPosts("pos_postconteudo")) > 500 Then%><br /><a href="posts.asp?prmpost=" target="_self">[Continuar lendo...]</a><%End If%>
				<div class="fixed"></div>
			</div>
			<div class="postfooter">
				<%If Session("TipoUsuario") = 1 Then%>
				<span class="edit">Editar</span>
				<%End If%>
			</div>	
		</div>
	<%
		vContRegistro = vContRegistro + 1
		rsSelectPosts.movenext
	Wend
	rsSelectPosts.Close
	Set rsSelectPosts = nothing
	%>
	<br style="clear:both;" />
	<div id="paginacao">
		<%'=fnpaginacao(vPagina)%>
	</div>

<%End If%>	
<%
Call Fecha_AreaTeste
%>			