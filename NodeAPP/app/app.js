let express 			= require('express');
let bodyParser 		= require('body-parser');
let expressLess   = require('express-less');
let minifyHTML    = require('express-minify-html');
let favicon       = require('serve-favicon');
let sqlite3 			= require('sqlite3').verbose();
let app 					= express();


let db = new sqlite3.Database('./bdd/base.sqlite3', (err) => {
  if (err) {
    console.error(err.message);
  }
});

db.serialize(function() {
  db.run("CREATE TABLE lorem (info TEXT)");

  var stmt = db.prepare("INSERT INTO lorem VALUES (?)");
  for (var i = 0; i < 10; i++) {
      stmt.run("Ipsum " + i);
  }
  stmt.finalize();

  db.each("SELECT rowid AS id, info FROM lorem", function(err, row) {
      console.log(row.id + ": " + row.info);
  });
});

db.close();

app.use(bodyParser.urlencoded({
    extended: true
}));

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


app.get('/test', function(req,res){
	res.render('test/test.ejs');
});

app.get("/api/", function(req, res)  {
	console.log("long= " + req.param('long') + " , lat=" + req.param('long'));
	res.setHeader('Content-Type', 'application/json');
	res.send(JSON.stringify({ a: 1 }, null, 3));
});

//Dossier statique
app.use('/static', express.static('public'));

app.use('/pictures', express.static('pictures'));

app.use('/fonts', express.static('fonts'));

app.use('/videos', express.static('videos'));

//favicon
app.use(favicon(__dirname + '/pictures/favicon.png'));

// routes
require('./app/routes.js')(app);

// Traitement Erreur 404
require('./app/404.js')(app);

//Ecoute le port 8080
app.listen(8080);
