/*global window*/
(function(){
    if(!('WebSocket' in window)){
        alert("No tiene soporte para WebSocket, use un browser serio");
    }
    var conn = new WebSocket("ws://127.0.0.1:8080");

    conn.onopen = function(){
        console.log("Connection established!");
    };

    conn.onmessage = function(e){
        var note = JSON.parse(e.data); 
        console.log(note);
    }
}());
