// Qalorie custom JS file

//var $ = jQuery.noConflict();

$(document).ready(function(){

    // landing page
    // show price motn
    $('.buttons_sec .btn-default2').click(function(){
        $(".price_year").fadeOut('slow', function(){
            $(".price_month").fadeIn('slow');
        });
        return false;
    });
    // show price year
    $('.buttons_sec .btn-success').click(function(){
        $(".price_month").fadeOut('slow', function(){
            $(".price_year").fadeIn('slow');
        });
        return false;
    });


    // dashboard boxes
    $('.points a').click(function(){
        var aux = $(this).attr('href');
        if ($('.points' + aux).css('display') === "block")
        {

            $(this).removeClass('icon-close');
            $(".points" + aux).fadeOut('slow', function(){
                $(".shadow" + aux).animate({opacity: 0},'slow');
                $(".point" + aux).fadeIn('slow');
            });
        }
        else {

            var active = $(this).parent().find('.icon-close').attr('href');

            if (active !== '')
            {
                $('.points a').removeClass('icon-close');
                $(".points" + active).fadeOut('slow', function(){
                    $(".shadow" + active).animate({opacity: 0},'slow');
                    $(".point" + active).fadeIn('slow');
                });
            }


            $(this).addClass('icon-close');
            $(".point" + aux).fadeOut('slow', function(){
                $(".shadow" + aux).animate({opacity: 0.7},'slow');
                $(".points" + aux).fadeIn('slow');
            });

        }

        return false;

    });

    // comparison slider
    if($("#slider").length > 0){
        $("#slider").slider();
    }

    // custom checkbox registration
    $('.terms input').iCheck({
        checkboxClass: 'icheckbox_minimal-green'
    });

    $('.login input, .box_main .right input, .box_creditcard .right input').focus(function(){
        $('section').addClass('dim');
    });
    $('.login input, .box_main .right input, .box_creditcard .right input').blur(function(){
        $('section').removeClass('dim');
    });


    // sign up page
    // custom checkbox registration
    $('.terms input').iCheck({
        checkboxClass: 'icheckbox_minimal-green'
    });

    // show first post
    $('.right form button').click(function(){
        $(".box_main").slideUp(1000, function(){
            $(".certification").slideDown(1000);
            $(".box_creditcard").slideDown(1000);

        });
        return false;
    });

});
