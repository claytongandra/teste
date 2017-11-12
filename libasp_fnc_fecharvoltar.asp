<%
Function fncGerarBarraFecharVoltar(prmTipo, prmUrl)
	If prmTipo = "V" Then
		fncGerarBarraFecharVoltar = "<div style=""width:100%;text-align:right;border:solid 1px #ccc;background:#444;color:#fff;text-decoration:none;""><a href=""../../default.asp"" target=""_parent"">Voltar</a></div>"
	Else'tb_show('Login', 'lab_login/lablog_login.asp?placeValuesBeforeTB_=savedValues&TB_iframe=true&height=300&width=300&modal=true','');
		fncGerarBarraFecharVoltar = "<div style=""width:100%;text-align:right;border:solid 1px #ccc;background:#444;color:#fff;text-decoration:none;""><a href=""#"" OnClick=parent.tb_remove();>Fechar</a></div>"
	End If
	
	
End Function
%>
