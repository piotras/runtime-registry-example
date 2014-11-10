#!/usr/bin/env node
var CoffeeScript = require('coffee-script');
CoffeeScript.register();
var uuid = require('uuid');
var db = require('../db');
var schema = require('../schema');
schema(db, function () {
  console.log('Database schema updated');

  db('runtimes')
    .insert({
        id: uuid.v4(),
        user: 'alex@example.com',
        secret: '12345',
        address: 'ws://localhost:3569',
        protocol: 'websocket',
        type: 'noflo-nodejs',
        label: "Local websocket runtime",
        description: '',
        registered: new Date,
        seen: new Date
    })
    .then(function() {
      console.log('Created example runtimes');
      process.exit(0);
    });

  return;

});
