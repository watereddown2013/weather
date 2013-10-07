//var async = require('async');
var express = require('express');
var app = express();
var fs = require('fs');
var jquery = require('jquery');
//var highcharts = require('node-highcharts');
//var http = require('http');
//var https = require('https');
//var db = require('db');



/*
app.set('views', __dirname + '/views');
//app.set('view engine', 'ejs');
app.set('port', process.env.PORT || 8080);



//render home page
app.get('/', function(request, response) {
    var data = fs.readfileSync('index.html').toString();
        response.send(data);
});

//display 1 day out
app.get('/oneday', function(request, response) {
*/

/*
options = {
    chart: {
        width: 200,
        height: 100,
            defaultSeriesType: 'bar'
    },
    legend: {
        enabled: false
    },
    title: {
        text: 'Highcharts rendered by node'
    },
    series: [{
        data:[1,2,3,4,5]
    }]
};

highcharts.render(options, function(err,data) {
    if (err) {
        console.log('error: ' + err);
    } else {
        fs.writeFile('chart.png', data, function() {
            console.log('written to chart.png');
        });
    }
});

 */  


//express.createServer(express.logger());


app.get('/', function(request, response) {
    response.send(hw);
});


var port = process.env.PORT || 8080;
app.listen(port, function() {
  console.log("Listening on " + port);
});

var rfc = fs.readFileSync("weather.html");
//var rfc = fs.readFileSync("index.html");
var buffer = new Buffer(rfc, "utf-8");
var hw = buffer.toString();
