'use strict';

var faker = require('faker');

var user = {

    generate: function () {
      var roles = ["Admin", "Owner", "User"];
      var count = 10;
      var output = '';
      var json = JSON.stringify({
        avatar: faker.image.avatar(),
        username: faker.internet.userName(),
        role: roles[Math.floor(Math.random() * 3)]
      });
      output = output.concat(json)
      console.log(output);
      return output;
    }

}

module.exports = user;
