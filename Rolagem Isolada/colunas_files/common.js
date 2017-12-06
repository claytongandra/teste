$(document).ready(function(){
	HomeTop();
	TopFixed();
});


function TopFixed(){
	var submenu =  $(".sub").length;
	if (submenu) { var hh = $(".headermain").height() + $(".sub").height() +10 } else {
	var hh = $(".headermain").height() +10}
	$("body").css("padding-top",hh);
	//$(".headermain").css("position","fixed");
	$(".sub").css("position","fixed");
	window.bh	      	  = $("html").height()-($(".footermain").height()*2);
	window.bh 	     	 += $(".proxtexto").size() ? $(".proxtexto").height()*0.5 : 400;
}

function HomeTop(){
	$(window).scroll(function(){
		var top = $(this).scrollTop();
		if (top > 10){
			$("#homebar").addClass("compacta");
			$(".titlesectionbar.big").removeClass("big");
			$(".submenufixo").removeClass("big");
			$(".headermain").css("position","fixed");
			/*$("#ads_richmedia_Bottom3_wrapper").css("top","79px");
			$("#peel,#ads_richmedia_Bottom3_wrapper").css("top","79px");*/
			TopFixed();
			//$(".assine").css("position","fixed");
		} else {
			$("#homebar").removeClass("compacta");
			$(".titlesectionbar").addClass("big");
			$(".submenufixo").addClass("big");
			$(".headermain").css("position","absolute");
			/*$("#ads_richmedia_Bottom3_wrapper").css("top","113px");
			$("#peel,#ads_richmedia_Bottom3_wrapper").css("top","113px");*/
			TopFixed();
			//$(".assine").css("position","fixed");
		}
		
	})
	
}
