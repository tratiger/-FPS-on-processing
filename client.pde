//クライアント
import processing.net.*;
Client client;
String passwordInput = "";
String serverResponse = "";

void setup(){
  size(500,500);
  client = new Client(this,"127.0.0.1",20000);
  //127.0.0.1は自分のｐｃのＩＰアドレスを指す
}

void draw(){ 
background(255);

fill(0);
textSize(16);
text("enter message: ",50,400);

fill(200);
rect(180,385,300,20);

fill(0);
text(passwordInput,185,400);

// サーバーからのレスポンスを表示
  textSize(23);
  text(serverResponse, 60, 100);

}

void keyPressed(){
  if (key != '\n'){
    passwordInput += key;
  }else{
    String s = "入力されたメッセージ: " ;
    String t = passwordInput ;
    println(s+t);
    serverResponse = "";
    client.write(t);
    passwordInput = "";
  }}
  
  
void clientEvent(Client c) {
     String message = c.readString();
     if (message != null){
       println("client received: " + message);
       serverResponse = message;
     }
}


   