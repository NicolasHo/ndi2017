//	app/routes.js
module.exports = function(app, bdd) {

	app.get('/', function(req, res)
	{
		res.render("../views/NDI/index.ejs");
	});

	// Create alert
	app.get('/alert_create', function(req, res) {
		bdd.print_alertes();
		res.setHeader('Content-Type', 'application/json');
		res.send(JSON.stringify({ code: bdd.addAlert(req.param('long'),req.param('lat')) }, null, 3));
		bdd.print_alertes();
	});

	// Get alert_list
	app.get('/alert_list', function(req, res) {
		res.setHeader('Content-Type', 'application/json');
		bdd.getAlert((rows) => {
			res.send(JSON.stringify({ alerts : rows }), null, 3);
		});
	});
};
