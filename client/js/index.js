$(function() {
    $('form').on('submit', function() {
        $.ajax({
            type: "PUT",
            contentType:'application/json',
            url: "http://localhost:8081/login",
            data: JSON.stringify({key: $(this).children('input').val()})
        }).then(
            function(res) {
                sessionStorage.setItem('token', res.token)
                window.location = "2fa.html"
            },
            function(res) {
                $('.error')
                    .stop(true, true)
                    .show()
                    .delay(1000)
                    .fadeOut(1000);
            }
        );
        // Prevent the default behaviour
        return false;
    });
});
