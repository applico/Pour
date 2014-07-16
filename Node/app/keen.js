var Keen = require('keen.io');

var client = Keen.configure({
    projectId: "YOUR PROJECT ID",
    writeKey: "YOUR WRITE KEY",
    readKey: "YOUR READ KEY",
    masterKey: "YOUR MASTER KEY"
	});

module.exports = {
  "client" : client,
  "Keen": Keen
};
