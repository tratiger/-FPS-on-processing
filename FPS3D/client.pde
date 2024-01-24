//オンラインマルチ　FPS　3D
//クライアント側

//ジャンプ機能を実装しました

import processing.net.*;
Client client;

PShape ak47;          // 3Dモデルを格納する変数
PImage ak47Texture;   // テクスチャを格納する変数
float gunX, gunY, gunZ; //AK47の位置
float gunAngleX, gunAngleY; //AK47のローテ角度

float playerX, playerY, playerZ;
float playerAngleX, playerAngleY;
int[][][] mapData = new int[100][15][100];
float reach = 200;

int dx,dy,dz,cx,cy,cz;
int index;
int k;

float vy=-100;
float g=0.2;
}


void setup() {
  frameRate (60);
  size(1000, 600, P3D);
  client = new Client(this,"10.240.97.140",20000);
  //127.0.0.1で自分のPCのIP

  generateMapData();
  generateTree();
 
   // プレイヤーの初期位置と視点角度を設定  //ここ大切！！
  playerX = 160;
  playerY = 150;
  playerZ = -125;
  playerAngleX = 0.08539816; // 仰角の初期値
  playerAngleY = 0;      // 方向角の初期値
  
  ak47 = loadShape("AK47.obj");  // AK47の3Dモデルをロード
  ak47Texture = loadImage("AK47 UV Map.png");  // テクスチャをロード
  
  index = 1; k=1;

void draw() {
  background(200);
  lights();

    // プレイヤーの視点周辺のブロックなどを描画する  最適化処理入れる！！
 drawMap();

  // マウスの移動量を取得
  float mouseXDelta = -radians(mouseX - pmouseX)*0.3;
  float mouseYDelta = -radians(mouseY - pmouseY)*0.3;

  // プレイヤーの向きを更新
  playerAngleY -= mouseXDelta;
  playerAngleX = constrain(playerAngleX - mouseYDelta, -PI / 2.0, PI / 2.0);

 //重力の実装
   if(playerY <225){
    vy = vy + 30*g;
    playerY = playerY + vy * g;
  }
  if(playerY>225){
    playerY =225;
    vy=-100;
  }

  // カメラの位置と方向を設定
  camera(playerX, playerY, playerZ,
         playerX + cos(playerAngleY) * cos(playerAngleX),
         playerY + sin(playerAngleX),
         playerZ + sin(playerAngleY) * cos(playerAngleX),
         0, 1, 0);

noCursor();

// クロスヘアの描画
  showText3d1("+");
  
//キャラクター操作
if (keyPressed) {
  if (key == 'w') {
    playerX += cos(playerAngleY) * 5;
    playerZ += sin(playerAngleY) * 5;
  } else if (key == 's' ){
    playerX -= cos(playerAngleY) * 5;
    playerZ -= sin(playerAngleY) * 5;
  } else if (key == 'a') {
    playerX += cos(playerAngleY - HALF_PI) * 5;
    playerZ += sin(playerAngleY - HALF_PI) * 5;
  } else if (key == 'd' ) {
    playerX += cos(playerAngleY + HALF_PI) * 5;
    playerZ += sin(playerAngleY + HALF_PI) * 5;
  } else if (key == ' ') {
    playerY = 224;
  } else if (key == 'q'){
    k=1-k;
  } else if (key == '1'){
  index = 1;
  showText3d2("soil");
  } else if (key == '2'){
    index = 2;
    showText3d2("wood");
  } else if (key == '3'){
    index = 3;
    showText3d2("reaf");
  }else if (key == '4'){
    index = 4;
    showText3d2("rock");
  }

  //ブロック破壊と設置
  contlorBlock();
  
}

if(k==1){
    //銃の表示
 push();
  translate(playerX,playerY,playerZ);
  rotateZ(playerAngleX);rotateY(-playerAngleY);
  translate(width/2 - 160,height/2-150,125);
  rotateX(PI/2); 
  shape(ak47);  // 3Dモデルを描画
  ak47.setTexture(ak47Texture);  // テクスチャを適用
 pop();
  }

 gunX=playerX-160; gunY=playerY-150; gunZ=playerZ+125;
 gunAngleX=playerAngleX-0.08539816; gunAngleY=playerAngleY;
 

//サーバーに位置情報の送信
String preplayerX = Float.toString(playerX);
String preplayerY = Float.toString(playerY);
String preplayerZ = Float.toString(playerZ);
client.write(preplayerX+" "+preplayerY+" "+preplayerZ + " "+ dx + " "+ dy +" "+dz+" "+cx+" "+cy+" "+cz+" "+index+'\n');

 //現在地の表示
println("現在地 X= "+ playerX + ", Y= " + playerY , "Z=" + playerZ);
println("角度　playerAngleX=" + playerAngleX, "playerAngleY=" + playerAngleY); 

}




void showText3d1(String str1) {
  pushMatrix();
  camera();
  hint(DISABLE_DEPTH_TEST);
  noLights();
  textMode(MODEL);
  fill(0);
  textSize(40);
  text(str1, width / 2, height / 2);
  hint(ENABLE_DEPTH_TEST);
  popMatrix();
}

void showText3d2(String str2){
  pushMatrix();
  camera();
  hint(DISABLE_DEPTH_TEST);
  noLights();
  textMode(MODEL);
  fill(255);
  textSize(40);
  text(str2,500 ,500 );
  hint(ENABLE_DEPTH_TEST);
  popMatrix();
}


void generateMapData() {
 for (int i = 0; i < 100; i++) {
    for (int j = 0; j < 15; j++) {
      for (int k = 0; k < 100; k++) {
        if (j>=12 && j <=15){
          mapData[i][j][k] = 1;
        }else if (j >= 10 && j <= 11) {
          // 地形の起伏を設定
          mapData[i][j][k] =1 ; //int(random(2));
        } else if (j== 9 && i % 4 == 0 && k % 4 == 0 && random(1) < 0.2) {
          // 木の生成
            mapData[i][j][k] = 2; 
        }
          else {
          // 空気ブロック
          mapData[i][j][k] = 0;
        }
      }
    } }}

void generateTree(){
  for (int i = 0; i < 100; i++) {
    for (int j = 0; j < 15; j++) {
      for (int k = 0; k < 100; k++) {
        if(mapData[i][9][k]==2 && i%4==0 && k%4==0 && j<=9 && j>=4){
             mapData[i][j][k]=2;      // 木の幹
        }//if (j<=6 & mapData[i][9][k]==2){
          //  mapData[i][j][k] = 3; // 木の葉
        //  }
     }}}}

void drawMap() {
  int blockSize = 30;
  int renderDistance = 20; // 描画するブロックの距離
  
  int startX = max(0, int(playerX / blockSize) - renderDistance);
  int endX = min(100, int(playerX / blockSize) + renderDistance);
  int startY = max(0, int(playerY / blockSize) - renderDistance);
  int endY = min(15, int(playerY / blockSize) + renderDistance);
  int startZ = max(0, int(playerZ / blockSize) - renderDistance);
  int endZ = min(100, int(playerZ / blockSize) + renderDistance);
  
  for (int i = startZ; i < endZ; i++) {
    for (int j = startY; j < endY; j++) {
      for (int k = startX; k < endX; k++) {
        pushMatrix();
        translate(30 * k, 30 * j, 30 * i);
        if (mapData[i][j][k] == 0) {
          // 空気ブロックは描画しない
        } else if (mapData[i][j][k] == 1) {
         fill(139, 69, 19);   
         box(30, 30, 30);         // 土ブロック
        } else if (mapData[i][j][k] == 2) {
          fill(139, 115, 85);
          box(30, 30, 30); // 木ブロック
        } else if (mapData[i][j][k] == 3) {
          fill(50, 205, 50);
          box(30, 30, 30); // 木の葉ブロック
        } else if (mapData[i][j][k] == 4){
          fill(150);
          box(30,30,30); //石ブロック
        }
        popMatrix();
      }
    }
  }
}



//サーバーからのレスポンスを受信
void clientEvent(Client c){
  String s = c.readStringUntil('\n');
  //int s_length = s.length();
  //mapdataの受信
  //if (s_length > 100){
  //  println("ワールドを生成中");
   // mapData = receivedArray(s);
  
  //他プレーヤーの位置情報の受信
  if (s != null){
    println("client received: " + s);
    String[] ss = splitTokens(s);
    float x = float(ss[0]);
    float y = float(ss[1]);
    float z = float(ss[2]);
    int ddx = int(ss[3]);
    int ddy = int(ss[4]);
    int ddz = int(ss[5]);
    int ccx = int(ss[6]);
    int ccy = int(ss[7]);
    int ccz = int(ss[8]);
    int id = int(ss[9]);

   // mapData = receivedArray(ss[3]);
 //他プレーヤーの表示
  push();
  translate(x,y,z);
  fill(0);
  sphere(40);
  x=0; y=0;z=0;
  pop();

  //ブロック生成の変更
   // if(ddx != null){
      mapData[ddz][ddy][ddx]=0;
    //}
   // if(ccx != null){
      mapData[ccz][ccy][ccx]=id;
   // }
  }
}





//最適化処理入れる！！！
float blockSize = 30;
void contlorBlock() {
  PVector playerPos = new PVector(playerX, playerY, playerZ);
  PVector direction = new PVector(cos(playerAngleY) * cos(playerAngleX), sin(playerAngleX), sin(playerAngleY) * cos(playerAngleX));
  PVector step = new PVector(direction.x, direction.y, direction.z);

  for (float i = 0; i < reach; i += 1) {
    int x = int((playerPos.x + step.x * i) / blockSize);
    int y = int((playerPos.y + step.y * i) / blockSize);
    int z = int((playerPos.z + step.z * i) / blockSize);

    if (x >= 0 && x < 100 && y >= 0 && y < 15 && z >= 0 && z < 100) {
      if(keyPressed){
        if (key == 'f'){
        if (mapData[z][y][x] >0) {
          mapData[z][y][x] = 0; // ブロックを破壊
          dz=z; dy=y; dx=x;
          break;
        }}
        if(key=='e'){
        if(mapData[z][y][x] == 0 ) {
          if(mapData[z+1][y][x]!=0 || mapData[z-1][y][x]!=0 || mapData[z][y+1][x]!=0 ||mapData[z][y-1][x]!=0 || mapData[z][y][x+1]!=0 || mapData[z][y][x-1]!=0){
          mapData[z][y][x] = index; // ブロックを生成 ここにスロットから選択する機能入れる!!
          cz=z; cy=y; cx=x;
          break;
        }}}
    }
  }
}}