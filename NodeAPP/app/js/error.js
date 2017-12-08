var i = Math.ceil(Math.random()*7);
var img = document.getElementById('doggo')
img.alt = "doggo";
img.src = "/pictures/doggos/" + i + ".jpg";
console.log(img)