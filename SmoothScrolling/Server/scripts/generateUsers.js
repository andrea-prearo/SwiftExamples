'use strict';

var faker = require('faker');
var fs = require('fs');
var contact = require('./user');

var count = 1000;
var output = '[';
for (var i = 0; i < count; i++) {
  var json = JSON.stringify(contact.generate());
  output = output.concat(json);
  if (i < count - 1) {
    output = output.concat(',');
  }
}
output = output.concat(']');
fs.writeFileSync('users.json', output);
