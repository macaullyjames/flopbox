module.exports = (dbName) ->
    sqlite3 = require "sqlite3"

    db = new (sqlite3.Database)("#{dbName}.db")
    db.serialize ->
        db.run "DROP TABLE IF EXISTS users"
        db.run "DROP TABLE IF EXISTS sessions"
        db.run """
            CREATE TABLE IF NOT EXISTS users (
                id INTEGER PRIMARY KEY,
                key TEXT
            )
            """
        db.run """
            CREATE TABLE IF NOT EXISTS sessions (
                id INTEGER PRIMARY KEY,
                user INTEGER,
                token TEXT,
                challenge TEXT,
                valid BOOLEAN
            )
            """
        db.run "INSERT INTO users (id, key) VALUES (null, 'A92XS5SMiMvQETQAJuwv2jSP')"

    users:
        get: (key) ->
            new Promise (resolve, reject) ->
                db.get "SELECT * FROM users WHERE key = '#{key}'", (err, row) ->
                    if row? then resolve(row) else reject(err)
    sessions:
        add: (userID, token, challenge) ->
            new Promise (resolve, reject) ->
                db.run "INSERT INTO sessions (id, user, token, challenge, valid) VALUES (null, ?, ?, ?, ?)", [userID, token, challenge, 0], (err) -> do resolve
        get: (token) ->
            new Promise (resolve, reject) ->
                db.get "SELECT * FROM sessions", (err, row) ->
                    if row? then resolve(row) else reject(err)
        validate: (token) ->
            new Promise (resolve, reject) ->
                db.run "UPDATE sessions SET valid = 1 WHERE token = ?", token, (err) ->
                    if err? then reject(err) else do resolve
