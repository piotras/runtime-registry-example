module.exports = (db, cb) ->
  # Runtime registry
  db.schema.hasTable('runtimes').then (exists) ->
    return if exists
    db.schema.createTable 'runtimes', (t) ->
      # Runtime UUID
      t.uuid('id').primary()
      # Runtime owner's email
      t.string('user').index().notNullable()
      # Secret string used for communicating with the runtime
      t.string('secret').index()
      # URL to runtime
      t.string('address').notNullable()
      # Protocol used, eg. WebRTC, WebSocket
      t.string('protocol').notNullable().index()
      # Runtime type, eg. NoFlo, MicroFlo
      t.string('type').notNullable().index()
      # Runtime label
      t.string('label')
      # Description for the Runtime
      t.text('description')
      # Registered
      t.dateTime('registered').notNullable().index()
      # Last seen
      t.dateTime('seen').notNullable().index()
  .then ->
    cb()
