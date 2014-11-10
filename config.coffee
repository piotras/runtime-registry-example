module.exports =
  database:
    url: process.env.HEROKU_POSTGRESQL_PINK_URL or "sqlite://user:pass@localhost#{__dirname}/flowhub.db"
  redis:
    url: process.env.REDISTOGO_URL or 'redis://localhost:6379'
  accounts:
    hostname: 'localhost'
    port: 3000
    path: '/account'
    admins: (process.env.GRID_ADMINS or 'ea8296db-2524-44f9-88db-e1f72a163127').split ','
    test_mode: false
    test_data:
      user:
        id: '91756572-8333-4bb1-8b26-2b64dd0bf159'
        token: 'QxitO7ulFW'
        name: 'Test User'
        email: 'henri.bergius+testuser@gmail.com'
    github_test_data:
      github:
        token: 'QxitO7ulFW'
        api_token: process.env.GITHUB_API_TOKEN or '3c5c6280-d470-11e3-9c1a-0800200c9a66'
        username: 'grid-bot'
