let sqlite3 			= require('sqlite3').verbose();

class bdd{
	constructor(){
		this.bdd = new sqlite3.Database('bdd/base.sqlite3', (err) => {
		  if (err) {
		    console.error(err.message);
		  }
		})
	}

	generate(){
		var db = this.bdd;
		this.bdd.serialize(function() {
		  db.run("CREATE TABLE alertes (id INTEGER PRIMARY KEY, longitude FLOAT, latitude FLOAT, date TIMESTAMP)");

		  var stmt = db.prepare("INSERT INTO alertes (longitude, latitude, date) VALUES (?,?,?)");
		  stmt.finalize();
		});
	}

	addAlert(long, lat){
		var db = this.bdd, res = 400;
		this.bdd.serialize(function() {
		  var stmt = db.prepare("INSERT INTO alertes (longitude, latitude, date) VALUES (?,?,?)");
			stmt.run(long, lat, Date.now());
		  stmt.finalize();
			res = 200;
		});
		return res;
	}

	getAlert(){
		var db = this.bdd, res = [];
		this.bdd.serialize(function() {
			db.all("SELECT * FROM alertes", [], function(err, rows) {
				res = rows;
			});
		});
		console.log(res);
		console.log(JSON.stringify(res));
		return JSON.stringify(res);
	}

	print_alertes(){
		var db = this.bdd;
		this.bdd.serialize(function() {
		  db.each("SELECT * FROM alertes", function(err, row) {
		      console.log(row.id + ": " + row.longitude + " " + row.latitude + " " + row.date);
		  });
		});
	}
}

module.exports = new bdd;
