var ajax = false,
    con_log="Nothing has been logged yet";

$.ajaxSetup({
    headers: {
        'X-Transaction': 'POST Example',
        'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
    },
    dataType: 'json',
    beforeSend: function(e) {
        this.url = this.url.replace('.jsonr', "") ;
    }
});



$(document).on("ajaxSend", function(a, b, c) {
    if (ajax) b.abort();
    else {
        ajax = true;
        if(c.url.indexOf("filter_helpers") === -1)
        $('#alert_bar').attr('style', '').addClass('loadin').removeClass('sucess error');
    }
})
    .on("ajaxComplete", function(e, xhr, settings) {
    ajax = false;
})
    .on("ajaxSuccess", function(e, xhr, settings) {
        $('#alert_bar').attr('style', '').removeClass('loadin');
    try {
        var data = $.parseJSON(xhr.responseText);
    } catch (e) {}

    if (data) {
        if (data.data && data.data.log) {
            con_log = data.data.log;
            log(con_log);
        }

        if (data.location) {
            loading_done(data.message, t('redirecting'), 'sucess');
            $('#alert_bar').addClass('redirecting');
            setTimeout(

            function() {
                if (data.location == ".") location.href = location.href;
                else location.href = data.location;
                // Turbolinks.visit(data.location)
            }

            , 2000)
        }
        // else if(data.message && data.warn) loading_done(data.message, data.message2, 'sucess');
        else if (data.message) loading_done(data.message, data.message2, 'sucess');
        else $('#alert_bar').removeClass('loadin sucess error');
    }

    ajax = false;
})
    .on("ajaxError", function(e, request, textStatus, errorThrown) {
        $('#alert_bar').removeClass('loadin');
    if (request.status==0) return ;

    if (request.status!=200)
    {
        var msg;
        try {
            $.parseJSON(request.responseText);
            ele = $.parseJSON(request.responseText);
            if (ele.log) {
                con_log = ele.log;
                log(con_log);
            }

            loading_done(ele.error, ele.stack, 'error');
        } catch (e) {

            if ($("body").data('error') != "") window.open("/__better_errors", "error");
            else loading_done(t('sorry'), '', 'error');
        }
    }

});



function loading_done(head, msg, class_name) {
    $('#msg h5').empty().html(head);
    $('#msg h6').empty().html(msg);
    $('#alert_bar').removeClass('sucess error loadin').attr('style', '').stop().addClass(class_name);
    setTimeout(function() {
        $('#alert_bar').fadeOut(

        function() {
            $('#alert_bar').attr('style', '').removeClass('sucess error loadin');
        })
    }, 10000);
}


/*register(

function() {
    Mousetrap.bind('p o w e r t', function() {
        alert(con_log);
    });
})*/
