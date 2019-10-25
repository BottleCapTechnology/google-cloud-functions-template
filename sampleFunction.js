const express = require("express");
const app = express();
const compression = require("compression");

// compress all responses
app.use(compression());

var bodyParser = require("body-parser");
app.use(bodyParser.json());

exports.sampleFunction = async (request, response) => {
  return response.status(200).send("You found me!");
};
