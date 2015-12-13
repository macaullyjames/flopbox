module.exports = (dbName) ->
    sqlite3 = require "sqlite3"

    db = new (sqlite3.Database)("#{dbName}.db")
    db.serialize ->
        db.run """
            CREATE TABLE IF NOT EXISTS users (
                id INTEGER PRIMARY_KEY,
                key TEXT
            )
            """
        db.run """
            CREATE TABLE IF NOT EXISTS sessions (
                id integer primary_key,
                user integer,
                token TEXT,
                challenge INTEGER,
                valid BOOLEAN
            )
            """
        db.run "INSERT INTO users (key) VALUES ('A92XS5SMiMvQETQAJuwv2jSP')"

    users:
        get: (key) ->
            new Promise (resolve, reject) ->
                db.get "SELECT * FROM users WHERE key = '#{key}'", (err, row) ->
                    if row? then resolve(row) else reject(err)
    sessions:
        add: (userID, token, challenge) ->
            new Promise (resolve, reject) ->
                db.run "INSERT INTO sessions (user, token, challenge, valid) VALUES (?, ?, ?, ?)", [userID, token, challenge, "FALSE"], -> do resolve
        get: (token) ->
            new Promise (resolve, reject) ->
                db.run "SELECT * FROM sessions WHERE token = ?", token, (err, row) ->
                    if row? then resolve(row) else reject(err)
        validate: (token) ->
            new Promise (resolve, reject) ->
                db.run "UPDATE sessions SET valid = TRUE WHERE token = ?", token, (err) ->
                    if err? then reject(err) else do resolve
