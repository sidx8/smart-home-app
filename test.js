//-------------------------------------------------- button togglers
function toggleCheckbox(element) {
    var xhr = new XMLHttpRequest();
    String onUrl = "/update?relay=relay1&state=";
//    String offUrl = "/update?relay=relay1&state=0"
    
    if (element.checked) {
        xhr.open("GET", onUrl + l, true);
    }
    else {
        xhr.open("GET",onUrl + 0, true);
    }
    xhr.send();
}

 //------------------------------------------------- END 
setInterval(function ( )
{
  //------------------------------------------------------------ request 1
var xhttp = new XMLHttpRequest();
xhttp.onreadystatechange = function()
    {
      if (this.readyState == 4 && this.status == 200)
      {
var inputChecked;
var outputStateM;

Serial.println("response interval : ");
Serial.println(this.responseText);

if( this.responseText == 1)
{
inputChecked = true;
outputStateM = "ON";
}
else
{
inputChecked = false;
outputStateM = "OFF";
}
document.getElementById("output").checked = inputChecked;
document.getElementById("outputState").innerHTML = outputStateM;
}
}
xhttp.open("GET", "/relay1/state", true);
xhttp.send();
}, 1000 ) ;