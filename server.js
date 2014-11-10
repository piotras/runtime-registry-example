var CoffeeScript = require('coffee-script');
CoffeeScript.register();

var app = require('./app');
var port = process.env.PORT || 5000;
app.listen(port);
