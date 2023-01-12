
(function($) {
    $(document).ready(function() {
    $('#cssmenu > ul > li > a').click(function() {
            var checkElement = $(this).next();
            if ((checkElement.is('ul')) && (checkElement.is(':visible'))) {
                $('#cssmenu > ul > li').removeClass('nothassub');
                $('#cssmenu > ul > li').addClass('hassub'); 
                checkElement.slideUp('normal');
                
            }
            else 
            {
                $('#cssmenu > ul > li').removeClass('hassub');
                $('#cssmenu > ul > li').addClass('nothassub');
                $('#cssmenu ul ul:visible').slideUp('normal');
                checkElement.slideDown('normal');
            }
        
        });
    });
})(jQuery);