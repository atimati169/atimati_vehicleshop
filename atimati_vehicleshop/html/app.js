$(function () {
    function display(bool) {
        if (bool) {
            $(".buy-car").fadeIn(150);
        } else {
            $(".buy-car").hide();
        }
    }

    display(false)

    window.addEventListener('message', function(event) {
        var item = event.data;
        if (item.type === "ui") {
            if (item.status == true) {
                display(true)
            } else {
                display(false)
            }
        }
    })
    document.onkeyup = function (data) {
        if (data.which == 27) {
            $.post('http://atimati_vehicleshop/exit', JSON.stringify({}));
            return
        }
    };
})

$("#yea-buy").click(function () {
    $.post('http://atimati_vehicleshop/buycar', JSON.stringify({
    }));
    return
})