'use strict';

var faker = require('faker');

var user = {

    generate: function () {
      var roles = ["Admin", "Owner", "User"];
      var output = '';
      var json = {
        avatar: faker.image.avatar(),
        username: faker.internet.userName(),
        role: roles[Math.floor(Math.random() * 3)]
      };
      output = output.concat(JSON.stringify(json));
      return output;
    }

}

module.exports = user;
