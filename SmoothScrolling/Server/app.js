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

    let parsedId = parseInt(request.query.id) || 0
    console.log('parsedId=' + parsedId)
    let start = (parsedId > 0 ? parsedId : 1) - 1
    let parsedCount = parseInt(request.query.count) || parsed.length
    let count = parsedCount > 0 ? parsedCount : 25
    let end = start + count
    let slice = parsed.slice(start, end)
    var users = _.map(slice, function(user) { return JSON.parse(user) })
    response.json(users)
  })
})

module.exports = app;
