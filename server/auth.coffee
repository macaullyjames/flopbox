{sessions} = require("./db") "flopbox"

checkToken = (req) ->
    token = req.get "authorization"
    sessions.get(token).then (row) -> req.session = row

module.exports = (req, res, next) ->
    switch req.path
        when "/login" then do next
        when "/2fa"
            checkToken(req)
                .then -> do next
                .catch -> res.status(401).send()
        else
            checkToken(req)
                .then (session) ->
                    throw "Invalid session" if session.valid isnt 1
                    do next
                .catch -> res.status(401).send()

