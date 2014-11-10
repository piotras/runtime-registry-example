Knex = require 'knex'
config = require './config'
url = require 'url'

# Parse DB URL
dbConfig = url.parse config.database.url
connection = charset: 'utf8'
provider = 'sqlite3'
connection.filename = dbConfig.path

module.exports = Knex.initialize
  client: provider
  connection: connection
  # debug: true
