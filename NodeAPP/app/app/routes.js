//	app/routes.js
module.exports = function(app) {

	//	page d'index
	app.get('/', function(req, res) {
		res.render('index/index.ejs');
	});

	//	crédits (tests redir)
	app.get('/credits', function(req,res){
		res.render('other/credits.ejs');
	});

	//	logs des commits
	app.get('/logs', function(req,res){
		res.render('other/logs.ejs');
	});

	//	Strasbourg n'est jamais lourd
	app.get('/ascmi', function(req,res){
		res.render('ascmi.ejs');
	});

	//	Indexation google
	app.get('/googlec0b1a061dd34c66c.html', function(req,res){
		res.render('google/index.ejs');
	});
};
