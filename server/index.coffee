require "coffee-script"
express    = require "express"
cors       = require "cors"
bodyParser = require "body-parser"
randToken  = require "rand-token"
fs         = require "fs"

{users, sessions} = require("./db") "flopbox"

api = express()
api.use cors()
api.use bodyParser.json()

api.use (req, res, next) ->
    if req.path is "/login" then return next()

    token = req.get "authorization"
    if not token? then return res.status(401).send()
    sessions.get token
        .then (row) ->
            req.session = row
            do next
        .catch -> res.status(401).send()

api.use (req, res, next) ->
    if req.path in ["/login", "/2fa"] then return next()
    switch req.session.valid
        when 0 then res.status(401).send()
        when 1 then do next

api.put "/login", (req, res) ->
    key       = req.body.key
    token     = randToken.generate 24
    challenge = Math.floor 10000*Math.random()
    users.get key
        .then (row) -> sessions.add row.id, token, challenge
        .then -> res.json token: token
        .catch -> res.status(401).send()

api.put "/2fa", (req, res) ->
    challenge = req.body.challenge
    session   = req.session
    token     = req.session.token

    if challenge is session.challenge
        sessions.validate(token)
        res.status(200).send()
    else
        res.status(400).send()

api.get "/files", (req, res) ->
    fs.readdir './shared/', (_, files) -> res.json files

api.listen 8081
