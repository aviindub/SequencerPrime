import themidibus.*;

MidiBus midiBus; //MidiBus
PrintWriter output; //output file

boolean read = true; //true for read mode, false for write mode

void setup() {

  size(300, 100);
  bpm = 120;
  frameRate(calculateFPS(bpm)); 

  //initialize the PrintWriter
  String outputFileName = "output_" + month() +"_"+ day() +"_"+ year() +"_"+ hour()+minute() +".txt";
  output = createWriter(outputFileName);
  
  //initialize MidiBus with no input, and LoopBe as output
  midiBus = new MidiBus(this, -1, "LoopBe Internal MIDI");
  
}

void draw() {
  if (read) {
    /*
    * get a file
    * read packets from file at rate of draw loop
    * packets are sized for the smallest possible note... 32nd maybe?
    * parse packets in to midi notes and duration (+ other data?)
    * send noteon and noteoff messages
    * (or set a future event for a noteoff?)
    */
  } else {
    /*
    * write mode
    */
  }
}

int calculateFPS(bpm) {
  int fps;
  return fps;
}
