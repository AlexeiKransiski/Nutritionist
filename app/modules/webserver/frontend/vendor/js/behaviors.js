// Qalorie custom JS file

var $e = jQuery.noConflict();

$e(document).ready(function(){  
    
    // custom file
    if($e(".custom_file").length > 0){
        $e(":file").jfilestyle({input: false, buttonText: "", icon: false});
    }        
    // picture button
    $e(".picture, .picturenew").hover(function() { 
        $e(this).find(".custom_file").fadeIn(400);
        }, function(){
        $e(this).find(".custom_file").fadeOut(400); 
    }); 
    
    // edit user info button
    $e(".info_center").hover(function() { 
        $e("#edit_user").fadeIn(400);
        }, function(){
        $e("#edit_user").fadeOut(400); 
    });
            
    // hide info user 
    $e('#edit_user').click(function(){                            
        $e('.info_user').fadeOut('fast');                
        $e("#edit_user").attr("id","edit_change").fadeOut('');
        $e('.info_user_edit').fadeIn('3000');                            
        return false;
    });
    
    // show edit info user
    $e('.info_user_edit #close, .info_user_edit .btn-default').click(function(){                            
        $e('.info_user_edit').fadeOut('fast');                        
        $e("#edit_change").attr("id", "edit_user").fadeIn('');
        $e('.info_user').fadeIn('3000');
        return false;
    });      
    
    // track tabs
    $e('#mytrack, #mychecklist, #mysearch, #mysearchex, #myprogresstab').tab();
    
    // emoticons
    $e('.emo').click(function(){
        //$e(this).parent().parent().parent().find('.emoticons').slideDown('slow');
        if ($e(this).parent().parent().parent().find('.emoticons').css('display') === 'none')
        {
            $e(this).parent().parent().parent().find('.emoticons').slideDown('slow');
            $e(this).find('.caret').hide('fast');
            $e(this).addClass('active');
        }
        else{
            $e(this).parent().parent().parent().find('.emoticons').slideUp('slow');
            $e(this).find('.caret').show('fast');
            $e(this).removeClass('active');
        }
    });
    $e('.emoticons label').click(function(){
        var icon = $e(this).find('span').attr('class');        
        $e(this).parent().parent().parent().find('.emoticons').slideUp('slow');
        $e(this).parent().parent().parent().find("button span[class*='icon-']").attr('class',icon);
        $e(this).parent().parent().parent().find('.caret').show('fast');
        $e(this).parent().parent().parent().find('.emo').removeClass('active');
    });
        
    // next search
    $e('#nexts').click(function(){                            
        $e('#select_food').slideUp('1000', function(){
            $e("#search").slideDown('slow');
        });                                        
        return false;
    });
    
    // submit search
    $e('#searchs form').submit(function(){                            
        $e('#search').slideUp('1000', function(){
            $e("#comment_food").slideDown('slow'); 
        });                                       
        return false;
    });
    
    // next exercise
    $e('#nexte').click(function(){                            
        $e('#select_exercise').slideUp('1000', function(){
            $e("#searchex").slideDown('slow'); 
        });                                       
        return false;
    });    
    
    // submit search exercise
    $e('#searchsex form').submit(function(){                            
        $e('#searchex').slideUp('1000', function(){
            $e("#comment_exercise").slideDown('slow'); 
        });                                       
        return false;
    });
    
    // submit measurement
    $e('#measurements form').submit(function(){                            
        $e(this).slideUp('1000', function(){
            $e("#measu_com").slideDown('slow'); 
        });                                       
        return false;
    });
    
    // edit boxes user info
    $e(".box_status").hover(function() { 
        $e(this).find("a").fadeIn('slow');
        }, function(){
        $e(this).find("a").fadeOut('slow'); 
    });
    
    $e('.dropdown-toggle').dropdown();

    // show edit info user
    $e('.edit_comment').click(function(){ 
        var id = $e(this).attr('href');
        $e(this).parent().slideUp('slow', function(){
            $e('#' + id).slideDown('5000');
        });                        
        
        return false;
    });    
    
    // custom scrollbar  
    if($e(".today").length > 0){
        $e(".today").mCustomScrollbar({
            autoHideScrollbar:true,
            advanced:{
                updateOnContentResize: true
            }
        });
    }
    if($e(".weeks").length > 0){
        $e(".weeks").mCustomScrollbar({
            autoHideScrollbar:true,
            advanced:{
                updateOnContentResize: true
            }
        });
    }
    if($e(".month").length > 0){
        $e(".month").mCustomScrollbar({
            autoHideScrollbar:true,
            advanced:{
                updateOnContentResize: true
            }
        });
    }
        
    // custom checkbox stars
    $e('.ratings input').iCheck({
        checkboxClass: 'icheckbox_futurico'
    });
    // custom checkbox sidebar right
    $e('.sidebar-right li input[type=checkbox]').iCheck({
        checkboxClass: 'icheckbox_minimal-green'
    });
    $e('.sidebar-right li input[type=checkbox]').on('ifChecked', function(){
        var text = $e(this).parent().parent().find('label').html();
        $e(this).parent().parent().find('label').empty().append('<del>' + text + '</del>');        
    });
    $e('.sidebar-right li input[type=checkbox]').on('ifUnchecked', function(){
        var text = $e(this).parent().parent().find('label').text();
        $e(this).parent().parent().find('label').empty().append(text);
    });
    
    // custom checkbox item track status
    $e('.body_items li input[type=checkbox], .nut_items li input[type=checkbox]').iCheck({
        checkboxClass: 'icheckbox_minimal-green'
    });      
    $e('.body_items li input[type=checkbox], .nut_items li input[type=checkbox]').on('ifChecked', function(){
        var text = $e(this).attr('id');
        $e(this).parent().parent().addClass('icon-'+ text);
        $e(this).parent().parent().find('label').addClass('selected');        
    });
    $e('.body_items li input[type=checkbox], .nut_items li input[type=checkbox]').on('ifUnchecked', function(){        
        var text = $e(this).attr('id');
        $e(this).parent().parent().removeClass('icon-'+ text);
        $e(this).parent().parent().find('label').removeClass('selected');        
    });
    
    // checklist dragable sidebar
    $e( "#today ul, #week ul, #month ul" ).sortable().disableSelection();
    
    
    // status page
    // show items track
    $e('.items_selected #items_tracked').click(function(){                            
        $e('.items_selected').slideUp('1000', function(){
            $e(".items_to_track").slideDown('slow'); 
        });
        return false;
    });
    
    // hide items track
    $e('.items_to_track #close, .items_to_track .btn-default').click(function(){                            
        $e('.items_to_track').slideUp('1000', function(){
            $e(".items_selected").slideDown('slow'); 
            $e("#body").slideUp('slow'); 
            $e("#facts").slideUp('slow'); 
            $e("#oculto").slideUp('slow'); 
            $e(".itemss").slideDown('slow'); 
        });
        return false;
    });
    
    // show body measurements items 
    $e('.group_items button.pull-left').click(function(){                            
        $e('.itemss').slideUp('1000', function(){
            $e("#body").slideDown('slow'); 
            $e("#oculto").slideDown('slow');
        });
        return false;
    });
    
    // show body measurements items 
    $e('.group_items button.pull-right').click(function(){                            
        $e('.itemss').slideUp('1000', function(){
            $e("#facts").slideDown('slow'); 
            $e("#oculto").slideDown('slow');
        });
        return false;
    });
    
    // custom scrollbar item track
    if($e("#body, #facts").length > 0){
        $e("#body, #facts").mCustomScrollbar({
            autoHideScrollbar:true,
            advanced:{
                updateOnContentResize: true
            }
        });
    }
    
    // datepicker status
    $e( "#from" ).datepicker({
        showOn: "button",
        buttonImage: "../../img/calendar.png",        
        firstDay: 1,
        changeMonth: false,
        numberOfMonths: 1,
        dayNamesMin: ['S', 'M', 'T', 'W', 'T', 'F', 'S','S'],
        onClose: function( selectedDate ) {
            $e( "#to" ).datepicker( "option", "minDate", selectedDate );
        }
    });
    $e( "#to" ).datepicker({
        showOn: "button",
        buttonImage: "../../img/calendar.png",
        firstDay: 1,
        changeMonth: false,
        numberOfMonths: 1,
        dayNamesMin: ['S', 'M', 'T', 'W', 'T', 'F', 'S'],
        onClose: function( selectedDate ) {
            $e( "#from" ).datepicker( "option", "maxDate", selectedDate );
        }
    });
    
    // progress vertical bottom bar
    $e('.progress-bar').progressbar();
   
   
    // progess pages    
    // edit progess info button
    $e(".observations, .tab-body .observations").hover(function() { 
        $e(this).find("#edit_user").fadeIn('slow');
        }, function(){
        $e(this).find("#edit_user").fadeOut('slow'); 
    });
    
    // edit
    $e('.tab-body .observations #edit_user, #newprogress').click(function(){                            
        $e('#first-view').slideUp('1000', function(){
            $e("#neworedit").slideDown('slow'); 
        });
        return false;
    });
    
    // show how to
    $e('#body-show .icon-help').click(function(){                            
        $e('#body-show').slideUp('1000', function(){
            $e("#howto").slideDown('slow'); 
        });
        return false;
    });
    // hide how to
    $e('#howto a').click(function(){                            
        $e('#howto').slideUp('1000', function(){
            $e("#body-show").slideDown('slow'); 
        });
        return false;
    });
    
    // comparison slider
    $e("#slider").slider();
    
    // custom details new
     if($e(".details_bodynew").length > 0){
        $e(".details_bodynew").mCustomScrollbar({
            autoHideScrollbar:true,
            advanced:{
                updateOnContentResize: true
            }
        });
    }
    
    // food pages
    // acordion food
    $e( "#accordion" ).accordion({
        collapsible: true
    });
    
    // progress vertical bottom bar
    $e('.track_water .progress-bar').progressbar();
    $e('.nutritions .progress-bar').progressbar();
    
    // show add breakfast
    $e('.openbreakfast').click(function(){                            
        $e('#all').slideUp('slow', function(){
            $e("#breakfast").slideDown('slow'); 
        });
        return false;
    });
    // show add earlysnack
    $e('.openearlysnack').click(function(){                            
        $e('#all').slideUp('slow', function(){
            
            $e("#earlysnack").slideDown('slow');                         
            
            $e("div[class$='-list']").slideUp('slow', function(){
                $e(".searchadd-list").slideDown('slow');                
            });
        });
        return false;
    });
    // show add lunch
    $e('.openlunch').click(function(){                            
        $e('#all').slideUp('slow', function(){
            $e("#lunch").slideDown('slow'); 
            
            $e("div[class$='-list']").slideUp('slow', function(){
                $e(".foodinfo-list").slideDown('slow');                
            });
        });
        return false;
    });
    
    // back to food
    $e('.title_sidebar .back a').click(function(){                            
        $e(this).parent().parent().parent().parent().parent().parent().slideUp('slow', function(){
            $e("#all").slideDown('slow'); 
        });
        return false;
    });
    
    // custom scrollbar search
    if($e(".box_search").length > 0){
        $e(".result").mCustomScrollbar({
            autoHideScrollbar:true,
            advanced:{
                updateOnContentResize: true
            }
        });
    }
    
    // custom scrollbar list
    if($e(".result_list").length > 0){
        $e(".result_list").mCustomScrollbar({
            autoHideScrollbar:true,
            advanced:{
                updateOnContentResize: true
            }
        });
    }
    
    //  food search tab    
    $e('.foodsearch a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
        e.target; // activated tab
        e.relatedTarget; // previous tab        
 
        var div = $e(this).attr('href');
        var newStr = div.substring(4, div.length);        
        switch (newStr) {
            case ('searchs'):                
                $e("div[class$='-list']").slideUp('slow', function(){
                    $e(".autocomplete").slideUp('slow');
                    $e(".empty-list").slideDown('slow'); 
                    $e(".empty").slideDown('slow'); 
                });
            break;
            case ('recently'):                
                $e("div[class$='-list']").slideUp('slow', function(){
                    $e(".added-list").slideDown('slow'); 
                });
            break;
            case ('favorites'):                
                $e("div[class$='-list']").slideUp('slow', function(){
                    $e(".favorite-list").slideDown('slow'); 
                });
            break;
            case ('list'):                
                $e("div[class$='-list']").slideUp('slow', function(){
                    $e(".saved-list").slideDown('slow'); 
                });
            break;
            case ('recipes'):                
                $e("div[class$='-list']").slideUp('slow', function(){
                    $e(".food-list").slideDown('slow'); 
                });
            break;
        }
        
    });
    
    // save list
    $e('.favorite-list button').click(function(){                            
        $e(".favorite-list").slideUp('slow', function(){
            $e(".save-list").slideDown('slow'); 
        });
        return false;
    });
    
    // autocomplete
    $e('#page-exercise #bf-searchs button').click(function(){
        $e(".empty").slideUp('slow', function(){
            $e(".empty-list").slideUp('slow');             
            $e(".exer-list").slideDown('slow'); 
            $e(".autocomplete").slideDown('slow'); 
        });
        return false;
    });
    
    // custom scrollbar exercise steps
    if($e(".exer-list").length > 0){
        $e(".nutritions ul").mCustomScrollbar({
            autoHideScrollbar:true,
            advanced:{
                updateOnContentResize: true
            }
        });
    }
    
    // add manually
    $e('.tab-content .addmore p a').click(function(){
        $e("div[class$='-list']").slideUp('slow', function(){
            $e(".newexer-list").slideDown('slow');
            $e(".first-cont").slideUp('slow');
            $e(".sec-cont").slideDown('slow');
            
        });
        return false;
    });
    
    // nutritions page
    // show test
    $e('.test').click(function(){
        $e("#welcome").slideUp('slow', function(){
            $e("#test-form").slideDown('slow');                        
        });
        return false;
    });
    
    // custom scrollbar exercise steps
    if($e(".box_form").length > 0){
        $e(".box_form").mCustomScrollbar({
            autoHideScrollbar:true,
            advanced:{
                updateOnContentResize: true
            }
        });
    }
    
    // custom scrollbar  
    if($e(".today").length > 0){
        $e(".today ul").mCustomScrollbar({
            autoHideScrollbar:true,
            advanced:{
                updateOnContentResize: true
            }
        });
    }
    if($e(".weeks").length > 0){
        $e(".weeks ul").mCustomScrollbar({
            autoHideScrollbar:true,
            advanced:{
                updateOnContentResize: true
            }
        });
    }
    if($e(".month").length > 0){
        $e(".month ul").mCustomScrollbar({
            autoHideScrollbar:true,
            advanced:{
                updateOnContentResize: true
            }
        });
    }
    
    // custom radio and checkbox nutritions
    $e('.custom_radio input').iCheck({
        checkboxClass: 'icheckbox_polaris',
        radioClass: 'iradio_polaris'
    });
    
    // show first post
    $e('#page-nutritionist .box_down .addmore button').click(function(){
        $e("#test-form").slideUp('slow', function(){
            $e("#first-post").slideDown('slow');                        
        });
        return false;
    });
    
    // nueva consulta
    $e('#page-nutritionist .info_bottom .button-first button').click(function(){
        $e(".info_user").slideUp('slow', function(){
            
            $e(".button-first").slideUp('slow'); 
            $e(".info_user_edit").slideDown('slow'); 
            $e(".button-save").slideDown('slow'); 
            
        });
        return false;
    });
    
    // back nueva consulta
    $e('#page-nutritionist .info_bottom .button-save .cancel').click(function(){
        $e(".info_user_edit").slideUp('slow', function(){
            
            $e(".button-save").slideUp('slow'); 
            $e(".info_user").slideDown('slow'); 
            $e(".button-first").slideDown('slow'); 
            
        });
        return false;
    });
    
    // custom scrollbar nueva consulta nutritions
    if($e("#page-nutritionist .info_user_edit").length > 0){
        $e("#page-nutritionist .info_user_edit form").mCustomScrollbar({
            autoHideScrollbar:true,
            advanced:{
                updateOnContentResize: true
            }
        });
    }
    
    if($e("#page-nutritionist .filter-list").length > 0){
        $e('.filter-list').mixitup({
            targetSelector: '.item',
            transitionSpeed: 650
        });
    }		
    
    $e('#page-nutritionist #first-post .filter-list button').click(function(){
        $e("#first-post").slideUp('slow', function(){            
            $e("#active-account").slideDown('slow');
            if($e(".info_user").css('display') === 'none')
            {
                $e(".button-save").slideUp('slow'); 
                $e(".button-first").slideDown('slow');
                $e(".info_user_edit").slideUp('slow');
                $e(".info_user").slideDown('slow');                                                   
            }                       
                        
        });
        return false;
    });
    
    // read message
    $e('#active-account .consult p a').click(function(){
        $e("#active-account").slideUp('slow', function(){
            $e("#message").slideDown('slow');                        
        });
        return false;
    });
    
    // back account
    $e('#page-nutritionist a.backr').click(function(){
        $e("#message").slideUp('slow', function(){
            $e("#active-account").slideDown('slow');   
            
        });
        $e("#page-nutritionist").slideDown('slow');
        return false;
    });
    
    // settings page
    // custom file
    if($e(".personal_info .customs_file").length > 0){
        $e(":file").jfilestyle({input: false, buttonText: "", icon: false});
    }  
    
    //  food search tab    
    $e('#mysettingtab a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
        e.target; // activated tab
        e.relatedTarget; // previous tab        
 
        var div = $e(this).attr('href');
        var newStr = div.substring(1, div.length);  
        
        switch (newStr) {
            case ('preferences'):                
                $e(".rest_boxes").slideUp('slow', function(){
                    
                    $e(".notifications").slideDown('slow');      
                    
                });
            break;
            case ('profile'):                
                $e(".rest_boxes").slideUp('slow', function(){                                         
                    
                    $e(".account_info").slideDown('slow'); 
                    $e(".change_password").slideDown('slow'); 
                    $e(".delete_account").slideDown('slow'); 
                    
                });
            break;
            case ('widget'):                
                $e(".rest_boxes").slideUp('slow', function(){                                         
                    
                    $e(".nutritionales").slideDown('slow');
                    
                });
            break;
            case ('subscription'):                
                $e(".rest_boxes").slideUp('slow', function(){  
                    
                    $e(".creditcard").slideDown('slow');
                    $e(".discount").slideDown('slow');
                    
                });
            break;
            case ('help'):                
                $e(".rest_boxes").slideUp('slow', function(){                                         
                    
                });
            break;
        }
    });
    
    // custom checkbox preferences
    $e('#preferences li input[type=checkbox], .notifications li input').iCheck({
        checkboxClass: 'icheckbox_minimal-green'
    });
    
    // custom scrollbar nutritional informations
    if($e("#page-settings .ntinfo ul").length > 0){
        $e("#page-settings .ntinfo ul").mCustomScrollbar({
            autoHideScrollbar:true,
            advanced:{
                updateOnContentResize: true
            }
        });
    }        
    
    // intro page
    // show first step
    $e('.test').click(function(){
        $e("#welcomes").slideUp('slow', function(){
            $e("#first-step").slideDown('slow');                        
        });
        return false;
    });
    
    // gender
    $e('#gender').on('change.bfhselectbox',function(){
        
        if ($e(this).find('input').val() === 'female')
        {
            $e("#first-step .pregnant").fadeIn(500);
        }
        else
        {
            $e("#first-step .pregnant").fadeOut(500);
        }
        
    });
    
    
    // custom file
    if($e("#first-step .customs_file").length > 0){
        $e(":file").jfilestyle({input: false, buttonText: "", icon: false});
    }
    
    // show second step
    $e('#first-step .tab-foot .btn-primary').click(function(){
        $e("#first-step").slideUp('slow', function(){
            $e("#second-step").slideDown('slow');                        
        });
        return false;
    });
    // back
    $e('#second-step .tab-foot .btn-default').click(function(){
        $e("#second-step").slideUp('slow', function(){
            $e("#first-step").slideDown('slow');                        
        });
        return false;
    });
    
    // show third step
    $e('#second-step .tab-foot .btn-primary').click(function(){
        $e("#second-step").slideUp('slow', function(){
            $e("#third-step").slideDown('slow');                        
        });
        return false;
    });
    // back
    $e('#third-step .tab-foot .btn-default').click(function(){
        $e("#third-step").slideUp('slow', function(){
            $e("#second-step").slideDown('slow');                        
        });
        return false;
    });    
    
    // custom scrollbar nutritional informations
    if($e("#third-step .ntinfo ul").length > 0){
        $e("#third-step .ntinfo ul").mCustomScrollbar({
            autoHideScrollbar:true,
            advanced:{
                updateOnContentResize: true
            }
        });
    }
    
    // show fourth step
    $e('#third-step .tab-foot .btn-primary').click(function(){
        $e("#third-step").slideUp('slow', function(){
            $e("#fourth-step").slideDown('slow');                        
        });
        return false;
    });
    // back
    $e('#fourth-step .tab-foot .btn-default').click(function(){
        $e("#fourth-step").slideUp('slow', function(){
            $e("#third-step").slideDown('slow');                        
        });
        return false;
    });
    
    // custom scrollbar nutritional informations
    if($e("#fourth-step .ntinfos ul").length > 0){
        $e("#fourth-step .ntinfos ul").mCustomScrollbar({
            autoHideScrollbar:true,
            advanced:{
                updateOnContentResize: true
            }
        });
    }
    
    // show finally step
    $e('#fourth-step .tab-foot .btn-primary').click(function(){
        $e("#fourth-step").slideUp('slow', function(){
            $e("#finally-step").slideDown('slow');                        
        });
        return false;
    });
    // back
    $e('#finally-step .tab-foot .btn-default').click(function(){
        $e("#finally-step").slideUp('slow', function(){
            $e("#fourth-step").slideDown('slow');                        
        });
        return false;
    });
    

    
});