/*
 * wkp-main.js - versão 1.0
 * Funções básicas do Portal de Soluções
 * 
 * Criado por  em 04/02/2015
 */

$(document).ready(function () {

    // MetsiMenu
    $('#side-menu').metisMenu();

    // minimaliza o menu
    $('.navbar-minimalize').click(function () {
        $("body").toggleClass("mini-navbar");
        SmoothlyMenu();
        autoCollapse();
    })

    // Altura completa da barra lateral (sidebar)
    function fix_height() {
        var heightWithoutNavbar = $("body > #wrapper").height() - 61;
        $(".sidebard-panel").css("min-height", heightWithoutNavbar + "px");
        var windowWidth = $(window).height();
        $("#page-wrapper").css("min-height", windowWidth + 'px');
    }

    $(window).bind("load resize click scroll", function () {
        if (!$("body").hasClass('body-small')) {
            fix_height();
        }
    })

    fix_height();

    // Inicia Handlers

    setIframeResizerTimer();
    searchMenu();
    addMenuItemToFavorite();
    removeMenuItemFromFavorite();

    // Adiciona Handler no evento click dos elementos marcados com a tag "data-link".
    // Através desta tag os elementos clicados também são atualizados no grupo "Recentes" do menu.

    $('a[data-link]').on('click', function (e) {
        e.preventDefault();

        var a = $(this);
        var href = a.data('link'),
            title = a.children('span').text(),
            uid = a.data('menu-uid'),
            li = a.parent(),
            recentList = $('.recent-list');

        createPage(href, title);

        var recent = li.clone(true);

        recentList.find('li > a[data-menu-uid="' + uid + '"]').parent().remove();
        recentList.prepend(recent);

        if (recentList.children('li').size() > 5) {
            recentList.children('li').last().remove();
        }
        return false;
    });


});

// Função que trata do encolhimento automático das abas quando elas ultrapassarem o tamanho disponível na tela.
// Atualmente a função checa se a linha onde as abas estão alocadas ultrapassa o tamanho de 48 px para encolher as abas

function autoCollapse() {

    var tabs = $('#tab-links');
    var tabsHeight = tabs.innerHeight();
    var tabsCollapsed = $('#tabs-collapsed').children('li')

    // Remover todas as abas do menu 
    while (tabsCollapsed.size() > 0) {
        $(tabsCollapsed[0]).removeClass('tabCollapsed');
        $(tabsCollapsed[0]).insertBefore(tabs.children('li:last-child'));
        tabsCollapsed = $('#tabs-collapsed').children('li')
    }

    // Remover menu contraído 
    $('#tabLast').addClass('invisible');
    tabsHeight = tabs.innerHeight();

    // Colocar novamente itens no menu se ultrapassar o limite
    if (tabsHeight > 48) {

        $('#tabLast').removeClass('invisible');
        tabsHeight = tabs.innerHeight();

        while (tabsHeight > 48) {
            var children = tabs.children('li:not(:last-child)');
            var count = children.size();

            $(children[count - 1]).prependTo('#tabs-collapsed');
            tabsHeight = tabs.innerHeight();
        }
    }

    // Marcar abas contraidas
    tabsCollapsed = $('#tabs-collapsed').children('li')
    if (tabsCollapsed.size() > 0) {
        for (var i = 0; i < tabsCollapsed.size() ; i++) {
            $(tabsCollapsed[i]).addClass('tabCollapsed');
        }
    }
};

// Função que cria uma nova aba e abre via iframe o conteúdo nesta aba.
// Depende de dois parâmetros: o link que será aberto (href) e o nome da aba (tabName)

function createPage(href, tabName) {

    var tabId = Date.now();

    var li = '<li class="active"><a href="#tab-pane-' + tabId + '" id="tab-' + tabId +
             '" data-toggle="tab">' + tabName + '<button accesskey="x" class="close" type="button">X</button></a></li>';

    var tabPane = '<div class="tab-pane active" id="tab-pane-' + tabId + '">' +
                  '<iframe id="src-' + tabId + '" width="100%" height="100%" src=' + href + ' frameborder=0></iframe></div>';

    $("#tab-links li").removeClass('active');
    $("#tab-links li:first").after(li);

    $(".tab-pane").removeClass('active');
    $(".tab-pane:first").after(tabPane);
    $('#tab-pane-' + tabId).tab('show');

    autoCollapse();
}

// Minimaliza o menu quando a tela é menor que 768px

$(function () {
    $(window).bind("load resize", function () {
        if ($(this).width() < 769) {
            $('body').addClass('body-small')
        } else {
            $('body').removeClass('body-small')
        }
    })
})

// Funcão que contrai/expande o menu de navegação e dá o efeito visual ao realizar esta tarefa.

function SmoothlyMenu() {
    if (!$('body').hasClass('mini-navbar') || $('body').hasClass('body-small')) {
        // Hide menu in order to smoothly turn on when maximize menu
        $('#side-menu').hide();
        // For smoothly turn on menu
        setTimeout(
            function () {
                $('#side-menu').fadeIn(500);
            }, 100);
    } else if ($('body').hasClass('fixed-sidebar')) {
        $('#side-menu').hide();
        setTimeout(
            function () {
                $('#side-menu').fadeIn(500);
            }, 300);
    } else {
        // Remove all inline style from jquery fadeIn function to reset menu state
        $('#side-menu').removeAttr('style');
    }
}

// Handler que monitora o evento de clique no botão de fechar a aba
// Este evento fecha a aba clicada, posiciona o foco na próxima aba, dependendo da posição, e reajusta as abas encolhidas

$(document).on("click", ".nav-tabs > li > a .close", function () {
    var tabContentId = $(this).parent().attr('href');
    var li = $(this).parent().parent();
    var activeTab;

    // Seleciona Tab que terá o foco
    if ($(li).next().attr("id") != "tabLast")
        activeTab = $(li).next();
    else
        activeTab = $(li).prev();

    var activeTabId = $(activeTab).children('a').attr('href');

    $(".nav-tabs .active").removeClass("active");

    $(activeTab).addClass("active");
    $(activeTabId).addClass("active");

    // Remove Tab e Conteúdo clicado
    $(li).remove();
    $(tabContentId).remove();

    autoCollapse();
});

// Handler que monitora o clique em uma aba contraída e "joga" para a lista de abas visíveis logo após ao painel do usuário

$(document).on("click", ".tabCollapsed", function () {
    var tab = $(this);
    var tabs = $('#tab-links');

    $(tab).insertAfter(tabs.children('li:first-child'));
    $(tab).removeClass('tabCollapsed');

    autoCollapse();
});

// Handler que monitoria o clique de contrair o menu de navegação e reajusta as abas contraídas.

$(document).on("click", "#menu-resize", function () {
    autoCollapse();
});

// Handler que monitora o resize da página para realizar a contração das abas

$(window).resize(function () {
    autoCollapse();
});

// Função que pega o height do body interno de um iframe e aplica o valor no 'style.height' do iframe.
// O sistema faz essa atualização a cada 300 milisegundos.

function setIframeResizerTimer() {
    setInterval(function () {

        var iframe = document.querySelector(".tab-content .active iframe");

        if (iframe && iframe.contentDocument && iframe.contentDocument.documentElement) {
            var contentDocument = iframe.contentDocument;

            if (contentDocument) {
                var contentHeight = $(contentDocument).height();

                iframe.style.height = Math.max(contentHeight, 550) + "px";
            }
        }
    }, 300);
}

// Função que ordena alfabeticamente os itens de uma lista.
// Utiliza o componente List.js.

function sortListItems(containerId) {

    try {
        var options = {
            valueNames: ['menu-name']
        };

        var menuList = new List(containerId, options);
        menuList.sort('menu-name', { order: 'asc' });
    } catch (e) {
        console.error('Erro ao ordenar a lista. Error Message: ' + e);
    }
}

// Função que realiza a pesquisa de acordo com as informações digitadas.
// Essa função só realiza pesquisa dos itens de menu.

function searchMenu() {
    $('input[type="text"].search-query').keyup(function () {
        var searchText = $(this).val(),
            resultList = $('.search-menu-group'),
            lists = $('.nav.nav-list li.menu-group');

        if (searchText == "") {
            resultList.hide();
            lists.show();
        } else {
            var hasMatch = false;

            resultList.children('ul').children('li.search-result-no-match').hide();
            resultList.find('ul li:not(.search-result-no-match)').remove();

            $('.submenu:not(.favorite-list) > li span.menu-name').each(function () {
                var currentLiText = $.trim($(this).text().toUpperCase()),
                    showCurrentLi = currentLiText.indexOf(searchText.toUpperCase()) !== -1;

                if (showCurrentLi) {
                    hasMatch = true;
                    var li = $(this).closest('li').clone(true);
                    li.show();
                    resultList.children('ul').append(li);
                }
            });

            if (!hasMatch) {
                resultList.children('ul').children('li.search-result-no-match').show();
            }

            sortListItems(resultList.attr('id'));
            lists.hide();
            resultList.show();
            $(resultList.children('ul')).addClass('collapse in');
        }
    });
}

// Função que adiciona um item de menu para o grupo de favoritos

function addMenuItemToFavorite() {
    $(document).on('click', '.add-favorite', function (e) {

        var li = $(this).closest('li'),
            a = $(li).children('a'),
            favList = $('.favorite-list'),
            uid = a.data('menu-uid'),
            liToChange = $('a[data-menu-uid=' + uid + ']').parent();

        if (favList[0].childElementCount > 10) {
            return false;
        }

        var menuGroup = favList.closest('li');

        // Altera ícone de favorito de todos os itens, mesmo quando estes estão sendo exibidos no resultado da pesquisa.
        liToChange.children('i').each(function () {
            $(this).removeClass('fa-star-o').addClass('fa-star');
            $(this).removeClass('add-favorite').addClass('remove-favorite');
        });

        favList.append(li.clone(true));

        favorite(uid);

        hideShowNoFavoriteMenuItem();

        var menuGroupId = "";

        if (menuGroup.attr('id') == undefined)
            menuGroup.attr('id', 'favorite-menu-list');

        menuGroupId = menuGroup.attr('id');

        sortListItems(menuGroupId);

        e.preventDefault();
        return false;
    });
}

// Função que remove um item de menu, seja ele no grupo favoritos ou não, do grupo de favoritos

function removeMenuItemFromFavorite() {
    $(document).on('click', '.remove-favorite', function (e) {

        var favList = $('.favorite-list'),
            li = $(this).closest('li'),
            uid = $(li).children('a').data('menu-uid');

        $('.favorite-list li a[data-menu-uid=' + uid + ']').closest('li').remove();

        var a = $('li.menu-group a[data-menu-uid=' + uid + ']');
        a.parent().children('i')
        .removeClass('fa-star').addClass('fa-star-o')
        .removeClass('remove-favorite').addClass('add-favorite');

        favorite(uid);

        hideShowNoFavoriteMenuItem();

        e.preventDefault();
        return false;
    });
}

// Função que mostra ou esconde um item de menu do grupo de favoritos

function hideShowNoFavoriteMenuItem() {
    var favList = $('.favorite-list');

    if (favList.children('li:not(.no-favorite)').length == 0) {
        favList.children('li.no-favorite').show();
    } else {
        favList.children('li.no-favorite').hide();
    }
}

// Função que realiza a gravação do item de menu nas definições de usuário.
// Esta funcão realiza através de uma requisição AJAX o uso do controlador /Home/FavoriteMenu para realizar esta ação.

function favorite(menuUid) {
    try {
        var url = '/Home/FavoriteMenu';

        if ($.trim(url) == "")
            alert('Erro em localizar a URL.');

        $.ajax({
            url: url,
            data: {
                menuUid: menuUid
            },
            success: function (data) {
                console.log('Success: ' + data.status);
            },
            error: function (jqXHR, textStatus, errorThrown) {
                console.error('Error: ' + errorThrown);
            }
        });
    } catch (e) {
        console.error(e);
    }
}

