/* jshint node:true */
'use strict';

var
    request = require('request'),
    path = require('path'),
    express = require('express'),
    bodyParser = require('body-parser');//,
    // PayU = require('./../');


var app = express();
app.use(bodyParser.json());

app.get('/', function(req, res, next){
    res.sendFile(path.join(__dirname, 'index.html'));
});

app.get('/createPayment/:amount', function(req, res){
    // Get IP (required parameter to create PayU transaction)
    request.get('http://ip-api.com/json', function(err, response, body){
        var ip = JSON.parse(body).query;

        console.log(ip);
        // Populate rest of info needed
        // respond
        res.json({hello: "world", world: 'hello'});
    });
});

app.listen(process.env.PORT || 3333);
