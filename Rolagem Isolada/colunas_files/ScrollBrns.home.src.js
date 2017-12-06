/**
* SCROLLBRNS.JS
* Funcionalidade: Impede que webdevs se suicidem ao implementar scroll dinâmico em widgets
* Versão: 1.2
* Autores: Brunno Benatti <contato@bbenatti.com.br>, Bruno Gomes <bruno@bgsouza.com>
* Licença: MIT
**/
$.fn.scrollBrns = function(opts) {

	//Crossbrowser hack
	window.innerHeight = window.innerHeight|| document.documentElement.clientHeight || document.body.clientHeight;
	
	//Inicializa a variáveis globais
	var toTop    = false;
	var sticky   = this;
	sticky.css("position", "relative");
	//Define o topo limitador
	if($('.related').length){
		opts.catcher = typeof $('.related').html() != "undefined" ? '.related' : opts.catcher;
		var topLimit = $(opts.catcher).offset().top + $(opts.catcher).outerHeight(true);
	}
	else if(opts.catcher == ".sub")
		var topLimit =  $(opts.catcher).offset().top + $(opts.catcher).outerHeight(true) + $(".headermain").outerHeight(true);
	else if(opts.catcher == ".headermain")
		var topLimit =  $(opts.catcher).outerHeight(true)-10;
	else
		var topLimit = $(opts.catcher).offset().top + $(opts.catcher).outerHeight(true);

	//Footer limitador
	var botLimit = $(opts.limit).offset().top;
	var header 	 = $(opts.header).outerHeight();
	
	//Nome do objeto	
	if(sticky.hasClass('tools'))
		var nomeObj = "tools";
	else if(sticky.hasClass('col2-3'))
		var nomeObj = "col2-3";
	else if(sticky.hasClass('col1-3'))
		var nomeObj = "col1-3";

	var nomeObj = sticky.attr('class').replace("-","");
	//Se é um elemento pequeno ou grande
	var botCatch =  nomeObj != "tools";
	
	var varsScr = new Array();
	varsScr[nomeObj] = {
		stickyTop: 	0,
		scrollY: 	0,
		upFixed: 	false,
		downFixed: 	false,
		topHit: 	false,
		botHit: 	false
	};
	
	//Exorciza a tecla "home" e "end"
	$("body, html").keydown(function(e)
	{	
		if(e.keyCode==36){
			sticky.css({top: 0});
		 	$(document).scroll();
		 	$(document).scrollTop(0);
		}

		if(e.keyCode==35){
			sticky.css({top: botLimit-(topLimit + sticky.outerHeight(true))});
		 	$(document).scroll();
		 	$(document).scrollTop();
		}
		
	});
	
	$(window).scroll(function(){
		
		//Define o topo limitador
		if($('.related').length){
			opts.catcher = typeof $('.related').html() != "undefined" ? '.related' : opts.catcher;
			var topLimit = $(opts.catcher).offset().top + $(opts.catcher).outerHeight(true);
		}
		else if(opts.catcher == ".sub"){
			var topLimit =  $(opts.catcher).offset().top + $(opts.catcher).outerHeight(true) + $(".headermain").outerHeight(true);
		}
		else if(opts.catcher == ".headermain"){
			var topLimit =  $(opts.catcher).outerHeight(true);
		}
		else{
			var topLimit = $(opts.catcher).offset().top + $(opts.catcher).outerHeight(true);
		}
			
		//console.log("top", topLimit);
		botLimit = $(opts.limit).offset().top;
		header 	 = $(opts.header).outerHeight();

		//Booleans aqui por questões de organização
		varsScr[nomeObj].stickyTop = $(sticky).offset().top;
		varsScr[nomeObj].scrollY   = $(window).scrollTop();
		varsScr[nomeObj].upFixed   = varsScr[nomeObj].scrollY+header > (botCatch ? topLimit+sticky.outerHeight(true)-(window.innerHeight-header) : topLimit)  && !toTop;
		varsScr[nomeObj].downFixed = varsScr[nomeObj].scrollY  <= botLimit && toTop;
		varsScr[nomeObj].topHit    = varsScr[nomeObj].stickyTop < topLimit && toTop || varsScr[nomeObj].scrollY <= topLimit;
		varsScr[nomeObj].botHit    = varsScr[nomeObj].scrollY+window.innerHeight  >=  (botCatch ? botLimit : botLimit+(window.innerHeight-header-sticky.outerHeight(true)));
		varsScr[nomeObj].setFixed  = (varsScr[nomeObj].upFixed||varsScr[nomeObj].downFixed)  && !varsScr[nomeObj].botHit;
		
		//Alto incremento para manter fixo
		if(varsScr[nomeObj].setFixed){
			
			stickyoffsetTop = varsScr[nomeObj].scrollY+header-topLimit - (botCatch ? sticky.outerHeight(true)-window.innerHeight+header : 0) + (opts.catcher == '.related' ? 20 : 0);			
			if(opts.catcher == ".headermain")
				stickyoffsetTop -= 10;
			sticky.css({top: stickyoffsetTop});
		}
		
		//Se voltou para o topo
		if(varsScr[nomeObj].topHit) {
			//console.log(nomeObj, "topLimit", topLimit);
			toTop = false;
			sticky.css({top: 0});
		}
		
		//Ao entrar no bottom
		if(varsScr[nomeObj].botHit){
			//console.log(nomeObj, "bot");
			toTop = true;
			if(nomeObj != "tools")
				sticky.css({top:  botLimit-(topLimit + sticky.outerHeight(true))});
		}
	});
};

/*está aqui para efeito de teste já que a home principal é sobreescrita toda hora*/
$.fn.scrollBrns.init = function() {

	$(document).ready(function() {
		if(window.location.href.indexOf("economia") > -1 && window.location.href.match(/\//g).length == 3)
			var catcher = ".destaques";
		else if($(".related").length)
			var catcher = ".related";
		else if($("#OAS_Position1").length)
			var catcher = "#OAS_Position1";
		else
			var catcher = ".headermain";

		

		var limit   = $('#OAS_Frame2').length ? "#OAS_Frame2" : ".col3-3 .footermain";
		// $('#OAS_Position1').height(90); //força se não tiver publi
		// $('#OAS_Frame2').height(100); //força se não tiver publi
				
		$('#sPOP').remove();
				
		//Instancia do ScrollBrns
		if($('.tools').length && !$('.tools').hasClass('thorizontal')) {
			$('.tools').scrollBrns({catcher: catcher, header: 'header.headermain', limit: $('#OAS_Position2').length ? limit : limit,padding: 130});
		}
		
		$('.col2-3').scrollBrns({catcher: catcher,header: 'header.headermain', limit: limit,padding: 0});
		$('.col1-3').scrollBrns({catcher: catcher,header: 'header.headermain', limit: limit,padding: 0});
		
	});


	
}


/*está aqui para efeito de teste já que a home principal é sobreescrita toda hora*/
$.fn.scrollBrns.iniciaHome = function() {
	var limit = typeof $('.col3-3.home #colFooter').html() != "undefined" ? '.col3-3.home #colFooter' : '.col3-3 .footermain';
	var catcher = '#OAS_Position1';

	if(typeof $('section.breaking').html() != "undefined" ){
		$('section.breaking').last()[0].id = "lastBreaking";
		catcher = "#lastBreaking";
	}
	var maiorNome = "";
	var maiorAtual = 0;
	var confs = {'.col3-1':{'padding':0, 'catcher': (catcher == '#lastBreaking' && $(catcher).width() > 400 ? '#lastBreaking' : '#OAS_Position1')},
				 '.col3-2':{'padding':0, 'catcher': (catcher == '#lastBreaking' && $(catcher).width() > 650 ? '#lastBreaking' : '#OAS_Position1')},
				 '.col3-3':{'padding':0, 'catcher': (catcher == '#lastBreaking' && $(catcher).width() > 700 ? '#lastBreaking' : '#OAS_Position1')}
				};
	//console.log(confs);
	for(i in confs) {
		if($('.col3-3.home '+i).outerHeight() > maiorAtual) {
			maiorAtual = $(i).outerHeight();
			maiorNome = i;
		}
		$('.col3-3.home '+i).css("position","relative");
		$('.col3-3.home '+i).scrollBrns({catcher: confs[i].catcher, header: 'header.headermain', limit: limit,padding: confs[i].padding});
	}
	
	/*for(i in confs) {
		if(maiorNome != i) {
			$('.col3-3.home '+i).scrollBrns({catcher: confs[i].catcher, header: 'header.headermain', limit: limit,padding: confs[i].padding});
		}
	}*/
}
