var socket = io.connect('http://Bachaner.fr:8081');
$(document).ready(function(){

	$.get("http://ipinfo.io", function(response) {
	    console.log(response.ip);
	}, "jsonp");

	$('#yes').on('click',function(e){
		console.log("fdp");
		socket.emit("oui","m=y");
	});
	$('#no').on('click',function(e){
		socket.emit("oui","m=n");
	});

	socket.on("coucou",function(m){
		console.log(m);
	});
});