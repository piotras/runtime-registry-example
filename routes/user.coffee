passport = require 'passport'
auth = require '../auth'

exports.get = [
  passport.authenticate 'bearer',
    session: false
  (req, res) ->
    return res.send 403 unless req.user.token
    auth.getUser req.user.token, (err, data) ->
      return res.send 403 if err
      return res.send 403 unless data
      user = JSON.parse JSON.stringify req.user
      delete user.token
      user.github = data
      lib.getUserPlan user.id, (err, plan) ->
        return res.send 500 if err
        user.plan =
          type: 'free'
        if plan
          user.plan.type = plan.type
          user.plan.expires = new Date plan.ends
        res.json user
]
