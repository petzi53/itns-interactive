// This recieves messages of type "myMessage" from the server.
Shiny.addCustomMessageHandler("myMessage",
  function(message) {
    alert(message);
  }
);
