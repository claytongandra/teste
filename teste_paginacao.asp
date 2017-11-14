<% Option Explicit%>

    
<!--#include file="scripts/Funcoes.asp"-->    
<!--#include file="scripts/inc_fn_paginacao.asp"-->  
<%
    'teste_paginacao.asp
Dim objEstacaoAtendente
Dim rsRetorno
Dim vPagina, vTotalReg, vTotalPag, vContador

'Constante de dentro da Função de Paginação (Número impar no minimo 5)
'--------------------------------------------------------------
    constFnPagiNumeroMax = 7 ' Número máximo de botões exibidos na paginação -- [<<][01][02][03][04][05][06][07][>>] --
'--------------------------------------------------------------

Set objEstacaoAtendente = CreateObject("ALAtendimento.CEstacaoAtendente")

Set rsRetorno = objEstacaoAtendente.BuscarPorStatus("A")  
  
rsRetorno.PageSize 		= 15 'qtd de registros por página

vTotalReg = rsRetorno.RecordCount 'total de registros
vTotalPag = rsRetorno.PageCount

Set objEstacaoAtendente = Nothing

vPagina = (Request.Form("hidpagina"))
If vPagina = "" Then
	vPagina = (Request.QueryString("prmpag"))
	if vPagina = "" then
		vPagina = 1
	End If			
End If
If Cint(vPagina) > vTotalPag Then
	vPagina = rsRetorno.PageCount 
End If

If rsRetorno.RecordCount > 0 Then
    rsRetorno.AbsolutePage = vPagina
End If
vContador 			= 1

Function fnDescricaoStatus(prmStatus)
    Dim vfnStatusNome
    Select Case prmStatus
    Case "A"
      vfnStatusNome = "Ativo"
   Case "I"
      vfnStatusNome = "Inativo"
    End Select
    fnDescricaoStatus = vfnStatusNome
End Function

Function fnLegendaPaginacao(prmPagina, prmTotalReg, prmTotalPag, prmNomeRegistro)
    Dim vFnLegPag

    If prmNomeRegistro = "" Or IsNull(prmNomeRegistro) Then
        prmNomeRegistro = "registro"
    End If

    If CInt(prmTotalReg) <= 0 Then
        vFnLegPag = "Nenhum  " & prmNomeRegistro & "localizado."
    Else
         If CInt(prmTotalReg) > 1 Then
            prmNomeRegistro = fnPlural(prmNomeRegistro)
        End If
        vFnLegPag = "Localizado " & Right("00" & prmTotalReg,2) & " " & prmNomeRegistro & ". Página " & Right("00" & prmPagina,2) & " de " & Right("00" & prmTotalPag,2) & "."
    End If

   

    fnLegendaPaginacao = vFnLegPag
End Function

Function fnPlural(prmPalavra)  
   
        
    fnPlural = Trim(prmPalavra & "s")
End Function

    '-Recupera parametros dinamicos
    '------------------------------------------
    Dim vprmTeste1, vprmTeste2 , vprmTeste3
    
    vprmTeste1 = (Request.Form("hidteste1"))
    If vprmTeste1 = "" Then
	    vprmTeste1 = (Request.QueryString("prmteste1"))
    End If

    vprmTeste2 = (Request.Form("hidteste2"))
    If vprmTeste2 = "" Then
	    vprmTeste2 = (Request.QueryString("prmteste2"))
    End If

    vprmTeste3 = (Request.Form("hidteste3"))
    If vprmTeste3 = "" Then
	    vprmTeste3 = (Request.QueryString("prmteste3"))
    End If
    '-----------------------------------------------


'    Response.Write("vprmTeste1: "&vprmTeste1&"<br>")
'    Response.Write("vprmTeste2: "&vprmTeste2&"<br>")
'    Response.Write("vprmTeste3: "&vprmTeste3&"<br>")

'    Response.Write("rsRetorno.PageSize: "&rsRetorno.PageSize&"<br>")

%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=9" />
        <title>Estação de Atendente</title>
        <link rel="stylesheet" type="text/css" href="css/Bootstrap/bootstrap-3.3.7.min.css">
        <link rel="stylesheet" type="text/css" href="../css/alfanet.css">
        <style>
            hr {
                 margin:2px 0;
            }
            /*#div_paginacao {
                text-align: center;
            }*/
            .pagination > .active > a, .pagination > .active > a:focus, .pagination > .active > a:hover, .pagination > .active > span, .pagination > .active > span:focus, .pagination > .active > span:hover {
                color: #fff;
                background-color: #070f3d;
                border-color: #ddd;
            }
            .legend-pagination{
                line-height: 32px;
                padding:3px;
                color: #070f3d;
                font-weight:bold;/**/
                font-size: 8pt;
                border:1px none #000;
            }
            thead{
                background-color: #070f3d;
	            color: #fff;
            }
            .tablehead{
                background-color: #070f3d;
	            color: #fff;
                font-size:8px;
            }

            .btn-primary-alfa{
                background-color:#070f3d;
                color:#fff;
                border:1px solid #070f3d;
            }


            .panel-table .panel-body{
              padding:0;
              margin:10px;
            }


            .panel-table .panel-body .table-bordered{
              margin:0;
              font-size: 9pt;
            }

            .panel-table .panel-body .table-bordered > thead > tr > th:last-of-type,
            .panel-table .panel-body .table-bordered > tbody > tr > td:last-of-type {
              border-right: 0px;
            }

            .panel-table .panel-body .table-bordered > thead > tr > th:first-of-type,
            .panel-table .panel-body .table-bordered > tbody > tr > td:first-of-type {
              border-left: 0px;
            }

            .panel-table .panel-body .table-bordered > tbody > tr:first-of-type > td{
              border-bottom: 0px;
            }

            .panel-table .panel-body .table-bordered > thead > tr:first-of-type > th{
              border-top: 0px;
               
            }

            .panel-table .panel-footer .pagination{
              margin:0; 
            }

            .panel-table .panel-heading .col h3{
             line-height: 30px;
            }

            .panel-title {
                color: #070f3d; /*#006699;*/
                font-weight:bold;
                font-size: 11pt;
            }
            .panel-heading, .panel-footer {
                padding: 5px;
                
            }

        </style>
    </head>
    <body>
<% 
 '       <div class="container container-fluid" style="border:1px none #5cb85c; padding-top:50px;">
 '           <div class="row col-md-12">
 '               <%' If rsRetorno.RecordCount = 0 Then% >
 '                   <div class="alert alert-warning" style="position:relative; margin-top:20px; width:608px; " role="alert">
 '                       Nenhuma item encontrado.
'                    </div>

 '               <%' Else% >
 '               <div class="row col-md-8 col-md-offset-2 text-right">
 '                   <a href="teste_paginacao.asp">[Recarregar]</a>
 '                   <hr />
 '               </div>
 '               <div class="row col-md-8 col-md-offset-2">
 '                   <table class="table table-bordered table-striped table-condensed"  style="width:100%; margin:0 auto">
 '                       <thead>
 '                           <tr class="tablehead"> 
 '                               <th width="250" style="text-align:left">Nome</th>
 '                               <th width="90" style="text-align:left">Login</th>
 '                               <th width="80" style="text-align:left">Máquina</th>
 '                               <th width="60" style="text-align:center">Status</th>
 '                               <th width="50">&nbsp;</th>
 '                           </tr>
 '                       </thead>
 '                       <tbody>
 '                       <%'While Not rsRetorno.EOF  And vContador <= rsRetorno.PageSize% >
  '                          <tr>
  '                              <td style="text-align:left"><%'=rsRetorno("NomeAtendente") % ></td>
  '                              <td style="text-align:left"><%'=rsRetorno("LoginAtendente") % ></td>
  '                              <td style="text-align:left"><%'=rsRetorno("CodEstacao") % ></td>
  '                              <td style="text-align:center"><%'=fnDescricaoStatus(rsRetorno("StatusEstacao")) % ></td>
  '                              <td style="text-align:center">
  '                                  <a href="javascript:fnPostEstacaoAlteracao(<%'=rsRetorno("Id") % >)">Alterar</a>
  '                              </td>
  '                          </tr>
 '                       <%
                        '    vContador = vContador + 1
                        'rsRetorno.MoveNext
                        'Wend
 '                       % >
'                            <!-- <tr align="center">
'		                        <td colspan="5">
'	                               <a href="teste_paginacao.asp">zera paginação</a>
' 		                        </td>
'	                        </tr>-->
 '                       </tbody>
 '                   </table>
 '                   <div id="div_paginacao">
                      
  '                      <%'=fnPaginacao(vTotalPag, vPagina, "teste_paginacao.asp", "pagination-sm pull-center", "Post", "" )% >

 '                       <%'=fnPaginacao(vTotalPag, vPagina, "teste_paginacao.asp", "pagination-sm pull-right", "Post", "hidteste1:teste hidden 1;hidteste2:texto hidden 2;hidteste3:3" )% >
'
 '                       <%'=fnPaginacao(vTotalPag, vPagina, "teste_paginacao.asp", "pagination-sm pull-right", "Get", "prmteste1:teste querystring 2;prmteste3:texto querystring 3" )% >


'                    </div>
'                </div>
 '               <%'End If% >
'            </div>
 '       </div>
 '       <%'Set rsRetorno = Nothing  % >




%>
        <div class="container " style="border:1px none #5cb85c; padding-top:50px;"">
            <div class="row">
                <div class="col-md-10 col-md-offset-1">
                    <div class="panel panel-default panel-table">
                        <div class="panel-heading">
                            <div class="row">
                                <div class="col col-xs-6">
                                    <h3 class="panel-title">Estação de Atendente</h3>
                                </div>
                                <div class="col col-xs-6 text-right">
                                    <a class="btn btn-sm btn-default" href="teste_paginacao.asp">Recarregar</a>
                                    <button type="button" class="btn btn-sm btn-primary btn-primary-alfa btn-create">Cadastrar Nova</button>
                                </div>
                            </div><!--div class="row"-->
                        </div><!--div class="panel-heading"-->
                        <div class="panel-body">
                        <% If rsRetorno.RecordCount = 0 Then%>
                            <div class="alert alert-warning" style="position:relative; margin-top:20px; width:100%; " role="alert">
                                Nenhum item encontrado.
                            </div>
                        <% Else%>
                            <div class="row">
                                <div class="col col-xs-12 text-right">
                                      <span class="legend-pagination"><%=fnLegendaPaginacao(vPagina, vTotalReg, vTotalPag, "")%></span> 
                                </div><!--div class="col col-xs-12"-->
                            </div><!--div class="row"-->
                            <table class="table table-striped table-bordered table-condensed">
                                <thead>
                                    <tr>
                                        <th width="250">Nome</th>
                                        <th width="90">Login</th>
                                        <th width="80">Máquina</th>
                                        <th class="text-center" width="60">Status</th>
                                        <th width="50"></th>
                                    </tr> 
                                </thead>
                                <tbody>
                                     <%While Not rsRetorno.EOF  And vContador <= rsRetorno.PageSize%>
                                    <tr>
                                        <td class="text-left"><%=rsRetorno("NomeAtendente") %></td>
                                        <td class="text-left"><%=rsRetorno("LoginAtendente") %></td>
                                        <td class="text-left"><%=rsRetorno("CodEstacao")%></td>
                                        <td class="text-center"><%=fnDescricaoStatus(rsRetorno("StatusEstacao"))  %></td>
                                        <td class="text-center"><a href="javascript:fnPostEstacaoAlteracao(<%=rsRetorno("Id") %>)" class="">Alterar</a></td>
                                    </tr>
                                    <%
                                        vContador = vContador + 1
                                        rsRetorno.MoveNext
                                    Wend
                                    %>
                                </tbody>
                            </table>
                        <%End If%>
                        </div><!--div class="panel-body"-->
                        <div class="panel-footer">
                            <div class="row">
                                <!--<div class="col col-xs-4">
                                      <span class="legend-pagination"><%'=fnLegendaPaginacao(vPagina, vTotalPag)%></span> 
                                </div>--><!--div class="col col-xs-4"-->
                                <div class="col col-xs-12 text-center ">
                                    <%'=fnPaginacao(vTotalPag, vPagina, "teste_paginacao.asp", "pagination-sm", "Get", "prmteste1:teste querystring 2;prmteste2:texto querystring + 2;prmteste3:texto querystring #3" )%>
                                    <%=fnPaginacao(vTotalPag, vPagina, "teste_paginacao.asp", "pagination-sm", "Post", "hidteste1:teste hidden 1;hidteste2:texto hidden 2;hidteste3:3" )%>
                                    <%
                                        '   hidteste1:teste hidden 1;hidteste2:texto hidden 2;hidteste3:3  
                                        '   prmteste1:teste querystring 2;prmteste2:texto querystring + 2;prmteste3:texto querystring #3
                                    %>
                           
                                </div><!--div class="col col-xs-8-->
                            </div><!--div class="row"-->
                        </div><!--div class="panel-footer"-->
                    </div><!--div class="panel panel-default panel-table"-->
                </div><!--div class="col-md-10 col-md-offset-1"-->
            </div><!--div class="row"-->
        </div><!--div class="container"-->
         <%Set rsRetorno = Nothing  %>


    </body>
</html>
