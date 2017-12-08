module.exports = function(app){
	app.use(function(req, res, next){
		// renvoie une erreur 404 et redirige vers /
		res.status(404).render('errors/404.ejs');
  });
}
