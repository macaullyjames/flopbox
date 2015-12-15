$(function() {
    $.ajax({
        type: "get",
        contentType:'application/json',
        beforeSend: function (xhr) {
            xhr.setRequestHeader('Authorization', sessionStorage.getItem('token'));
        },
        url: 'http://localhost:8081/files',
    }).then(
        function(files) {
            files.forEach(function (file) {
                $('<li>')
                    .html(file)
                    .appendTo('#filelist')
            });
        }
    );
});
