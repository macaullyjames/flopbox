require "coffee-script"
express    = require "express"
cors       = require "cors"
bodyParser = require "body-parser"
randToken  = require "rand-token"

{users, sessions} = require("./db") "flopbox"

api = express()
api.use cors()
api.use bodyParser.json()

api.put "/login", (req, res) ->
    key       = req.body.key
    token     = randToken.generate 24
    challenge = Math.floor 10000*Math.random()
    users.get key
        .then (row) -> sessions.add row.id, token, challenge
        .then -> res.json token: token
        .catch -> res.status(401).send()

api.listen 8081
