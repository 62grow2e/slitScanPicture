import processing.video.*;
Capture cap;

int input_w, input_h, output_w, output_h, fps;
int update_x;
PGraphics input, output, filter;

void setup() {
	String[] cameras = Capture.list();
	for(int i = 0; i < cameras.length; i++){
		println(i, cameras[i]);
	}
	cap = new Capture(this, cameras[0]);
	cap.start();

	while(!cap.available())delay(1);

	input_w = 640;
	input_h = 480;
	output_w = input_w*3;
	output_h = input_h;

	filter = createGraphics(input_w, input_h);
	input = createGraphics(input_w, input_h);
	output = createGraphics(output_w*3, output_h);

	size(output_w, input_h+output_h);
}

void draw() {
	if(cap.available())cap.read();

	updateInput(cap, input);
	updateOutput(getScanPixels(input, filter), output);

	image(input, 0, 0);
	image(output, 0, input_h);
	image(filter, 0, 0);

	if(update_x == 0)saveOutput();
}

void updateInput(PImage capture, PGraphics _input){
	_input.beginDraw();
	_input.image(capture, 0, 0, _input.width, _input.height);
	_input.endDraw();
}

void updateOutput(color[] scanedColors, PGraphics _output){
	_output.loadPixels();
	for(int i = 0; i < _output.height; i++){
		_output.pixels[i*_output.width+update_x] = scanedColors[i];
	}
	_output.updatePixels();
	update_x++;
	update_x %= input_w*3;
}

color[] getScanPixels(PImage _input, PGraphics _filter, int[] x){
	color[] clrs = new color[_input.height];
	_filter.beginDraw();
	_filter.loadPixels();
	_filter.background(0, 0);

	_input.loadPixels();
	for(int i = 0; i < _input.height; i++){
		clrs[i] = _input.pixels[i*_input.width+x[i]];
		_filter.pixels[i*_input.width+x[i]] = color(#ff0000);
	}
	_filter.updatePixels();
	_filter.endDraw();
	return clrs;
}

color[] getScanPixels(PImage _input, PGraphics _filter){
	int[] x = new int[_input.height];
	for(int i = 0; i< _input.height; i++){
		x[i] = _input.width/2;
	}
	return getScanPixels(_input, _filter, x);
}

void saveOutput(){

	String month = (month()<10)?"0"+str(month()): str(month());
	String day = (day()<10)?"0"+str(day()): str(day());
	String hour = (hour()<10)?"0"+str(hour()): str(hour());
	String minute = (minute()<10)?"0"+str(minute()): str(minute());
	String second = (second()<10)?"0"+str(second()): str(second());

	String filename = "images/breath-"+year()+month+day+hour+minute+second+".jpg";

	output.save(filename);
	println("frame saved as "+filename+".");
}