$(document).ready(function(){
//fonction de base pour recuperer les messages en json

var a = $.get("http://ipinfo.io", function(response) {
    return(response.ip);
}, "jsonp");

function cookies(){
	if(document.cookie == ""){
		document.cookie = "ab";
	}
}

var socket = io.connect('http://Bachaner.fr:8081');


//fonction d'appel a ajax
	$('#yes').on('click',function(e){
		socket.emit("oui","m=y");
	});
	$('#no').on('click',function(e){
		socket.emit("oui","m=n");
	});
});