//鯖
import processing.net.*;
Server server;
ArrayList<Client> client = new ArrayList<Client>();

void setup(){
    server = new Server(this,20000);
}

void draw(){
    for (int i = clients.size() - 1; i >= 0; i--) {
    Client currentClient = clients.get(i);
    if (currentClient.active()) {
      String message = readMessage(currentClient);
      if (message != null) {
        int clientId = getClientId(currentClient);
        println("Received from client " + clientId + ": " + message);
        broadcastMessage(clientId + ":" + message);
      }
      if(message.equals("otamesi1234")){
        server.write("success");
      }else{
        server.write("パスワードが間違っています");
      }
    }
    else {
      println("Client disconnected: " + currentClient.ip());
      clients.remove(i);
    }
  }
}  


//細かい定義
String readMessage(Client c) {
  if (c.available() > 0) {
    return c.readString();
  }
  return null;
}

int getClientId(Client c) {
  return clients.indexOf(c) + 1;
}

void broadcastMessage(String message) {
  for (Client c : clients) {
    c.write(message);
  }
}

void serverEvent(Server s, Client c) {
  println("New client connected: " + c.ip());
  clients.add(c);
  // 一意のIDを生成してクライアントに送信
  int clientId = clients.size();
  c.write("YourID:" + clientId);
}

