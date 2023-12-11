//鯖
import processing.net.*;
Server server;
ArrayList<Client> clients = new ArrayList<Client>(); 

void setup() {
 server = new Server(this,20000);
}

void draw(){
   Client c = server. available();
  if(c !=null){
    String message = c.readString();
    println("server received: " + message );
    server.write(message);
  }
}

void serverEvent(Server s, Client c) {
    println("New client connected: " + c.ip());
    clients.add(c);
    // 一意のIDを生成してクライアントに送信
    int clientId = clients.size();
    c.write("YourID:" + clientId);
}
