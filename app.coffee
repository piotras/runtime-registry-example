express = require 'express'
passport = require 'passport'
config = require './config'

app = express()
app.use express.logger()
app.use express.urlencoded()
app.use express.json()
app.use passport.initialize()
app.use app.router

# Authentication strategies
require './auth'

# Allow CORS so Flowhub apps can talk to the API
# TODO: Restrict by API
app.all '/*', (req, res, next) ->
  res.header 'Access-Control-Allow-Origin', '*'
  res.header 'Access-Control-Allow-Methods', 'GET, PUT, POST, OPTIONS'
  res.header 'Access-Control-Allow-Headers', 'Content-Type, Authorization'
  next()

# Runtime registry routes
runtimes = require './routes/runtime'
app.get '/runtimes', runtimes.list
app.put '/runtimes/:id', runtimes.register
app.get '/runtimes/:id', runtimes.get
app.post '/runtimes/:id', runtimes.ping
app.del '/runtimes/:id', runtimes.del

# User data route
user = require './routes/user'
app.get '/user', user.get

# Safety catch-all
process.on 'uncaughtException', (e) ->
  console.log 'UNCAUGHT EXCEPTION', e

module.exports = app
