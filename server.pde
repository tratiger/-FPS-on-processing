//鯖
import processing.net.*;
Server server;

void setup(){
    server = new Server(this,20000);
}

void draw(){
    Client c = server.available();
    if(c != null){
        String s = c.readStringUntil('\n');
        if (s != null){
           println("server received: " + s);
           server.write(s);
    }}
}

