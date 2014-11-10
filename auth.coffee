passport = require 'passport'
BearerStrategy = require('passport-http-bearer').Strategy
http = require 'http'
config = require './config'

getUser = (token, callback) ->
  # Validate token
  requestOptions = JSON.parse JSON.stringify config.accounts
  requestOptions.headers = Authorization: "Bearer #{token}"
  req = http.get requestOptions, (res) ->
    data = ''
    return callback null, false unless res.statusCode is 200
    res.on 'data', (chunk) ->
      data += chunk
      res.on 'end', ->
        # Set req.user data from info received from OAuth2 provider
        userData = JSON.parse data
        userData.email = userData.email
        userData.id = userData.email
        callback null, userData
  req.setTimeout 2000
  req.end()

passport.use new BearerStrategy (accTok, done) ->
  return done null, false unless accTok
  getUser accTok, (err, user) ->
    return done err if err
    return done null, false unless user
    user.token = accTok if user
    done err, user
