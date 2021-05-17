$(function() {
    window.addEventListener('message', function(event) {
        if (event.data.type == "open") {
            tq_gps.SlideUp()
        }

        if (event.data.type == "close") {
            tq_gps.SlideDown()
        }
    });

    document.onkeyup = function (data) {
        if (data.which == 27) { // Escape key
            $.post('http://tq-gps/escape', JSON.stringify({}));
            tq_gps.SlideDown()
        } else if (data.which == 13) { // Escape key
            $.post('http://tq-gps/gpskatil', JSON.stringify({
                channel: $("#channel").val()
            }));
        }
    };
});

tq_gps = {}

// Button
$(document).on('click', '#submit', function(e){
    e.preventDefault();

    $.post('http://tq-gps/gpskatil', JSON.stringify({
        channel: $("#channel").val()
    }));
});

$(document).on('click', '#disconnect', function(e){
    e.preventDefault();

    $.post('http://tq-gps/gpsayril', JSON.stringify({
        channel: $("#channel").val()
    }));
});

$(document).on('click', '#gpskapatbutton', function(e){
    e.preventDefault();

    $.post('http://tq-gps/escape', JSON.stringify({}));
    tq_gps.SlideDown()
});


// Animation
tq_gps.SlideUp = function() {
    $(".container").css("display", "block");
    $(".gps-container").animate({bottom: "6vh",}, 700);
}

tq_gps.SlideDown = function() {
    $(".gps-container").animate({bottom: "-110vh",}, 400, function(){
        $(".container").css("display", "none");
    });
}