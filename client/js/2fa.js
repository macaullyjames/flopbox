$(function() {
    $('input').on('input', function() {
        if (!(/^\d$/.test($(this).val()))) $(this).val('');
    })
    $('input:last').on('input', function() {
        if ($(this).val() !== '') $(this).parent().submit();
    })
    $('input:not(:last)').on('input', function() {
        if ($(this).val() !== '') $(this).next().focus();
    })
    $('input:not(:first)').on('keydown', function(e) {
        if ($(this).val() === "" && e.keyCode == 8) {
            $(this).prev().val('').focus();
        }
    });

    $('form').on('submit', function() {
        var challenge = "";
        $('input').each(function() {
            challenge += $(this).val();
        });

        $.ajax({
            type: "PUT",
            contentType:'application/json',
            url: 'http://localhost:8081/2fa',
            data: JSON.stringify({
                challenge: challenge,
                token: sessionStorage.getItem('token')
            })
        }).then(
            function(res) {
                window.location = 'files.html'
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
