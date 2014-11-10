module.exports = ->
  # Project configuration
  @initConfig
    pkg: @file.readJSON 'package.json'

    # BDD tests on Node.js

    # Coding standards
    coffeelint:
      routes:
        files:
          src: ['routes/*.coffee']
        options:
          max_line_length:
            value: 80
            level: 'warn'
      root:
        files:
          src: ['*.coffee']
        options:
          max_line_length:
            value: 80
            level: 'warn'

  # Grunt plugins used for testing
  @loadNpmTasks 'grunt-coffeelint'

  # Our local tasks
  @registerTask 'test', ['coffeelint',]
  @registerTask 'default', ['test']

