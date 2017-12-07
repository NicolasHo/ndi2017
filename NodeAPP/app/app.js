let express 			= require('express');
let bodyParser 		= require('body-parser');
let expressLess   = require('express-less');
let minifyHTML    = require('express-minify-html');
let favicon       = require('serve-favicon');
let db						= require('./bdd/bdd.js')
let app 					= express();
var server = require('http').createServer(app);
var io = require('socket.io')(server);

db.generate();

app.set('views', __dirname + '/views');

//Activation de EJS
app.set('view engine', 'ejs');

//Activation de less
app.use('/less-css', expressLess(__dirname + '/less', { compress: true, cache: true }));

//Compression HTML
app.use(minifyHTML({
  override:      true,
  exception_url: false,
  htmlMinifier: {
    removeComments:            true,
    collapseWhitespace:        true,
    collapseBooleanAttributes: true,
    removeAttributeQuotes:     true,
    removeEmptyAttributes:     true,
    minifyJS:                  true
  }
}));

app.use(bodyParser.json());

//Dossier statique
app.use('/static', express.static('public'));

app.use('/pictures', express.static('pictures'));

app.use('/fonts', express.static('fonts'));

app.use('/videos', express.static('videos'));


//favicon
app.use(favicon(__dirname + '/pictures/favicon.png'));

// routes
require('./app/routes.js')(app, db);

// Traitement Erreur 404
require('./app/404.js')(app);

io.sockets.on('connection', function (socket, pseudo) {
    // Dès qu'on nous donne un pseudo, on le stocke en variable de session et on informe les autres personnes
    socket.on('nouveau_client', function(pseudo) {
        pseudo = ent.encode(pseudo);
        socket.pseudo = pseudo;
        socket.broadcast.emit('nouveau_client', pseudo);
    });

    // Dès qu'on reçoit un message, on récupère le pseudo de son auteur et on le transmet aux autres personnes
    socket.on('message', function (message) {
        message = ent.encode(message);
        socket.broadcast.emit('message', {pseudo: socket.pseudo, message: message});
    });
});

//Ecoute le port 8080
server.listen(8080);
