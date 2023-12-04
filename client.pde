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
       if (s.equals("success")){
         serverResponseY = s;
       }
       else{
         serverResponseN = "failure";
     }
   }
}



