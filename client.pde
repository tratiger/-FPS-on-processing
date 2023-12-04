//クライアント
import processing.net.*;
Client client;
int clientId;
String passwordInput = "";
String serverResponseY = "";
String serverResponseN ="";

void setup(){
  size(400,200);
  client = new Client(this,"127.0.0.1",20000);
  //127.0.0.1は自分のｐｃのＩＰアドレスを指す
}

void draw(){ 
background(255);

fill(0);
textSize(16);
text("enter password: ",50,50);

fill(200);
rect(200,35,150,20);

fill(0);
text(passwordInput,205,50);

// サーバーからのレスポンスを表示
  textSize(10);
  text("clientId: " + clientId ,10,10);
  textSize(23);
  text(serverResponseN, 60, 100);
  fill(255, 0, 0);
  text(serverResponseY, 60, 100);

}

void keyPressed(){
  if (key != '\n'){
    passwordInput += key;
  }else{
    String s = "入力されたパスワード: " ;
    String t = passwordInput ;
    println(s+t);
    serverResponseY = "";
    serverResponseN ="";
    client.write(t);
    passwordInput = "";
  }}
  
  
void clientEvent(Client c) {
     String s = c.readString();
     if (s != null){
       println("client received: " + s);
        // サーバーからのメッセージがクライアントIDを含んでいる場合、分割して利用
       if (s.indexOf(':') != -1) {
         String[] parts = split(s, ':');
         int senderId = int(parts[0]);
         String senderMessage = parts[1];
        // println("Received from client " + senderId + ": " + senderMessage);
    
       if (senderMessage.equals("success")){
         serverResponseY = senderMessage;
       }
       else{
         serverResponseN = "failure";
     }
       }
   }
}


void handleMessage(String message) {
  if (message.startsWith("YourID:")) {
    clientId = int(message.substring(7));
    println("Assigned ID from server: " + clientId);
  } else {
    println("Unknown message from server: " + message);
  }
}