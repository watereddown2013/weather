var sqlite3 = require('sqlite3').verbose();
var db = sqlite3.Database('test.db');

db.serialize(function()) {
	db.run("create table lorem (info TEXT)");

var stmt = db.prepare("insert into lorem values (?)");
	
