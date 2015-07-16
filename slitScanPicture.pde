// slitScanPicture
// coded by 62grow2e(Yota Odaka)

import processing.video.*;
Capture cap;

int input_w, input_h, output_w, output_h, fps;
int update_x;
PGraphics input, output, filter;

boolean isMirror = true;

void setup() {
  // set frame per sec
  fps = 30;
  frameRate(fps);
  // setup of camera
  String[] cameras = Capture.list();
  for(int i = 0; i < cameras.length; i++){
    println(i, cameras[i]);
  }
  cap = new Capture(this, cameras[0]);
  cap.start();
  while(!cap.available())delay(1);

  // init canvases
  input_w = 640;
  input_h = 480;
  output_w = input_w*3;
  output_h = input_h;

  filter = createGraphics(input_w, input_h);
  input = createGraphics(input_w, input_h);
  output = createGraphics(output_w, output_h);

  size((output_w>input_w)?output_w:input_w, input_h+output_h);
}

void draw() {
  // update capture event
  if(cap.available())cap.read();

  // update
  updateInput(cap, input);
  updateOutput(getScanPixels(input, filter, getScanPos(input, output)), output);
  //updateOutput(getScanPixels(input, filter), output); // これでも一応動く

  // display
  if(isMirror){
    pushMatrix();
    translate(input_w, 0);
    scale(-1, 1);
    image(input, 0, 0);
    image(filter, 0, 0);
    popMatrix();
  }
  else {
    image(input, 0, 0);
    image(filter, 0, 0);
  }
  image(output, 0, input_h);

  // save
  if (update_x == 0)saveOutput();
}

// switch mirror
void keyPressed(){
  if(key == 's')saveOutput();
  else if(key == 'm')isMirror = !isMirror;
}

// decide coordinates to scan a input image
// スキャンする座標を決めます
PVector[] getScanPos(PImage _input, PImage _output){
  PVector[] _pos = new PVector[_output.height];
  // _input内の座標のみで_posのxとyを決めてください！！
  // 以下を書き換えてください！

  // ！！！！！ここから！！！！！
  for(int i = 0; i < _pos.length; i++){
    _pos[i] = new PVector(_input.width/2, i); // (引数1, 引数2) = (X, Y)
  }
  // ！！！！！ここまで！！！！！

  return _pos;
}

// update a target image
void updateInput(PImage capture, PGraphics _input){
  _input.beginDraw();
  _input.image(capture, 0, 0, _input.width, _input.height);
  _input.endDraw();
}

// integrate lines which are scaned into a output image
void updateOutput(color[] scanedColors, PGraphics _output){
  _output.loadPixels();
  for(int i = 0; i < _output.height; i++){
    _output.pixels[i*_output.width+update_x] = scanedColors[i];
  }
  _output.updatePixels();
  update_x++;
  update_x %= output_w;
}

// scan a input image and return it's colors according to the 3rd parameter
// 第3引数の座標をスキャンします
color[] getScanPixels(PImage _input, PGraphics _filter, PVector[] _pos){
  /* 
  // 一応エラー処理入れてみた 動作確認していません
  for(int i = 0; i < _pos.length; i++){
    if(_pos[i].x<0||_input.width<_pos[i].x||_pos[i].y<0||_input.height<_pos[i].x){
      color[] c = new color[_pos.length];
      for(color _c : c)_c = color(0);
      return c; 
    }
  }*/
  color[] clrs = new color[_input.height];
  _filter.beginDraw();
  _filter.loadPixels();
  _filter.background(0, 0);

  _input.loadPixels();
  for(int i = 0; i < _pos.length; i++){
    clrs[i] = _input.pixels[(int)_pos[i].y*_input.width+(int)_pos[i].x];
    _filter.pixels[(int)_pos[i].y*_input.width+(int)_pos[i].x] = color(255*(1-(float)i/_pos.length), 0, 255*(float)i/_pos.length);
  }
  _filter.updatePixels();
  _filter.endDraw();
  return clrs;
}

// with no 3rd parameter, scan a vertical center line of a input image
// 第3引数を指定しない場合はx座標の中心の色をスキャンします
color[] getScanPixels(PImage _input, PGraphics _filter){
  PVector[] _pos = new PVector[_input.height];
  for(int i = 0; i< _pos.length; i++){
    _pos[i] = new PVector(input.width/2, i);
  }
  return getScanPixels(_input, _filter, _pos);
}

// save output in sketch directory/images
void saveOutput(){
  String month = (month()<10)?"0"+str(month()): str(month());
  String day = (day()<10)?"0"+str(day()): str(day());
  String hour = (hour()<10)?"0"+str(hour()): str(hour());
  String minute = (minute()<10)?"0"+str(minute()): str(minute());
  String second = (second()<10)?"0"+str(second()): str(second());

  String filename = "images/slitscan-"+year()+month+day+hour+minute+second+".jpg";

  output.save(filename);
  println("saved a integrated image as "+filename+".");
}