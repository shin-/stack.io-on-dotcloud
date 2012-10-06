var REGISTRAR_ENDPOINT = process.env['REGISTRAR_ENDPOINT'];

var http = require('http'),
    stack = require('stack.io');

var ioserv = new stack.ioServer(),
    httpServ = http.createServer(function(req, res) {
        res.writeHead(200, {'Content-Type': 'text/html'});
        res.end('stack.io server is running!');
    }).listen(process.env['PORT_WWW']);

ioserv.connector(new stack.SocketIOConnector(httpServ));
ioserv.middleware(/.+/, /_stackio/, /.+/, stack.builtinsMiddleware);
ioserv.middleware(/.+/, /.+/, /.+/, stack.zerorpcMiddleware(REGISTRAR_ENDPOINT));

ioserv.listen();