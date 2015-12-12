$(function() {
    $('#login-button').on('click', function() {
        $.ajax({
            type: "PUT",
            url: "localhost:8081/",
            data: {
                key: $('#key-input').val()
            }
        }).then(
            function(res) {
                console.log(res);
            },
            function(res) {
                console.log(res);
            }
        );
    });
});
