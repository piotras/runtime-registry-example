passport = require 'passport'
db = require '../db'

exports.list = [
  passport.authenticate 'bearer',
    session: false
  (req, res) ->
    db('runtimes')
    .select()
    .where('user', req.user.id)
    .then (rows) ->
      res.json rows
    .otherwise (e) ->
      res.send 500
]

exports.get = [
  passport.authenticate 'bearer',
    session: false
  (req, res) ->
    db 'runtimes'
    .select()
    .where(
      id: req.params.id
      user: req.user.id
    )
    .then (rows) ->
      unless rows.length
        return res.send 404
      res.json rows[0]
    .otherwise (e) ->
      res.send 500
]

exports.ping = (req, res) ->
  db('runtimes')
  .select()
  .where(
    id: req.params.id
  )
  .then (rows) ->
    unless rows.length
      return res.send 404

    # Update runtime
    db('runtimes')
    .where(
      id: req.params.id
    )
    .update(
      seen: new Date
    )
    .then (rows) ->
      res.send 200
    .otherwise (e) ->
      res.send 500

exports.register = (req, res) ->
  unless req.params.id
    return res.send 422, 'Missing Runtime ID'
  unless req.body.user
    return res.send 422, 'Missing Runtime owner ID'
    # TODO: Validate User ID with The Grid Passport
  unless req.body.address
    return res.send 422, 'Missing Runtime URL'
  unless req.body.protocol
    return res.send 422, 'Missing Runtime protocol'
  unless req.body.type
    return res.send 422, 'Missing Runtime type'
  # See if we already have such a runtime
  db('runtimes')
  .select()
  .where(
    id: req.params.id
  )
  .then (rows) ->
    # Validate secret when modifying runtime information
    if rows.length and rows[0].secret and rows[0].secret isnt req.body.secret
      return res.send 403
    # Validate runtime type. MicroFlo can't suddenly just become a browser
    if rows.length and rows[0].type isnt req.body.type
      return res.send 409

    if rows.length is 0
      # New runtime, insert
      db('runtimes')
      .insert(
        id: req.params.id
        user: req.body.user
        secret: req.body.secret
        address: req.body.address
        protocol: req.body.protocol
        type: req.body.type
        label: req.body.label or "#{req.body.type} runtime"
        description: req.body.description or ''
        registered: new Date
        seen: new Date
      )
      .then (rows) ->
        return res.send 201
      .otherwise (e) ->
        return res.send 500
      return

    # Update existing runtime
    db('runtimes')
    .where(
      id: req.params.id
    )
    .update(
      user: req.body.user
      address: req.body.address
      protocol: req.body.protocol
      label: req.body.label or rows[0].label
      description: req.body.description or rows[0].description
      seen: new Date
    )
    .then (rows) ->
      return res.send 200
    .otherwise (e) ->
      return res.send 500

  .otherwise (e) ->
    return res.send 500

exports.del = [
  passport.authenticate 'bearer',
    session: false
  (req, res) ->
    db('runtimes')
    .select()
    .where(
      user: req.user.id
      id: req.params.id
    )
    .then (rows) ->
      unless rows.length
        return res.send 500

      db('runtimes')
      .del()
      .where(
        id: req.params.id
      )
      .then (rows) ->
        res.send 204
      .otherwise (e) ->
        res.send 500
    .otherwise (e) ->
      res.send 500
]
