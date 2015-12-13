nStatic = require "node-static"
http    = require "http"

# Initialize the server
require "./server"
console.log "API started on port 8081"

# Start a static server for the client
file = new nStatic.Server("./client")
http.createServer((req, res) ->
  req.addListener("end", -> file.serve req, res).resume()
).listen 8080
console.log "Client served up on port 8080"
