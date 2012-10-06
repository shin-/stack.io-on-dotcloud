var stack = require('stack.io');

stack.io({}, function(error, client) {
    if (error) {
        console.trace(error);
        process.exit(1);
    }

    client.expose('echo', process.env['ECHO_ENDPOINT'], {
        echo: function(sentence, callback) {
            callback(null, sentence);
        }
    })
})