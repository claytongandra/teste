var OESP_Args=function(){this.queryString="",this.redes={facebook:1,linkedin:2,twitter:3},this.init=function(){this.getRefer(),this.getProdutos()},this.getProdutos=function(){var e=this;$.get("/servicos/assinantes/",{},function(t){"undefined"!=typeof t&&t.ok&&(e.queryString+=t.dados)},"json")},this.getRefer=function(){var e=document.referrer,t=new RegExp("facebook.|fb.|linkedin|twitter.");t.test(e)&&(e=e.replace(/http(s)?:\/\/(www\.)?/g,"").split("."),"undefined"!=typeof this.redes[e[0]]&&(this.queryString="&redesocial="+e[0]))}};oespargs=new OESP_Args,function(){oespargs.init()}();