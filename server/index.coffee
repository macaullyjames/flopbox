require "coffee-script"
express    = require "express"
cors       = require "cors"
bodyParser = require "body-parser"
randToken  = require "rand-token"
fs         = require "fs"
pad        = require "pad-left"
auth       = require "./auth"

{users, sessions} = require("./db") "flopbox"

api = express()
api.use cors()
api.use bodyParser.json()
api.use auth

api.put "/login", (req, res) ->
    key       = req.body.key
    token     = randToken.generate 24
    challenge = pad("#{Math.floor 10000*Math.random()}", 4, 0)
    users.get key
        .then (row) -> sessions.add row.id, token, challenge
        .then -> res.json token: token
        .catch -> res.status(400).send()

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
