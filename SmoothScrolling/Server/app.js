var express = require('express')
var fs = require('fs')
var _ = require('lodash')
var app = express()

app.get('/', function(request, response) {
  response.send('Hello World!')
})

app.get('/users', function(request, response) {
  fs.readFile('users.json', 'utf8', function (error, data) {
    if (error) {
      throw error
    }
    var parsed = JSON.parse(data)
    var users = _.map(parsed, function(user) { return JSON.parse(user) })
    response.json(users)
  })
})

app.listen(app.get('port'), function() {
  console.log("Node app is running at localhost:" + app.get('port'))
})

module.exports = app;
