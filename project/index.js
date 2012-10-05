var http = require('http');

http.createServer(function(req, res) {
    res.writeHead(200, {'Content-Type': 'text/html'});
    res.end('<em>Keep it quiet here...<br/>I will not tolerate your noise<br/>This is where I listen for<br/>The forgiving voice.</em>');
}).listen(process.env['PORT_WWW']);