var express = require('express');
var fs = require('fs');
var path = require('path');
var util = require('util');
var multiparty = require('multiparty');
var cookieParser = require('cookie-parser');

var app = express();

var statue_code = 0;



 app.use(express.static('public'));

app.route('/test').get(function(req,res){
  res.redirect('http://google.com');
});

app.route('/statue').post(function(req,res){
  var u = {"statue_code":statue_code}
  res.json(u);
});

app.route('/statue').get(function(req,res){
  var u = {"statue_code":statue_code}
  res.json(u);
});

app.route('/upload').post(function(req,res){
  var form = new multiparty.Form();
  form.uploadDir = "Static/Images/";

  form.parse(req, function(err, fields, files) {
    if (err) {
      res.writeHead(400, {'content-type': 'text/plain'});
      res.end("invalid request: " + err.message);
      return;
    }
    var inputFile = util.inspect(files);
    var uploadedPath = inputFile.path;
    var dstPath = './Static/Images/' + inputFile.originalFilename;
    fs.renameSync(uploadedPath,dstPath,function(err){
      if (err){
        console.log('rename error'+err);
      }else {
        console.log('rename down');
      }
    });

    res.writeHead(200, {'content-type': 'text/plain'});
    res.write('received fields:\n\n '+util.inspect(fields));
    res.write('\n\n');
    res.end('received files:\n\n '+util.inspect(files));
  });
});



var server = app.listen(8887, function () {
  var host = server.address().address;
  var port = server.address().port;

  console.log('Example app listening at http://%s:%s', host, port);
});
