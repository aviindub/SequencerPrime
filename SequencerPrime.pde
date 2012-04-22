import themidibus.*;

MidiBus midiBus; //MidiBus
PrintWriter output; //output file writer
BufferedReader reader; //input file reader
String input; //for reading lines from input file

boolean read = true; //true for read mode, false for write mode

void setup() {

  size(300, 100);
  bpm = 120;
  frameRate(calculateFPS(bpm)); 

  if (read) {
    //initialize the BufferedReader
    reader = createReader("positions.txt");
  } else {
    //initialize the PrintWriter
    String outputFileName = "output_" + month() +"_"+ day() +"_"+ year() +"_"+ hour()+minute() +".txt";
    output = createWriter(outputFileName);
  }
  
  //initialize MidiBus with no input, and LoopBe as output
  midiBus = new MidiBus(this, -1, "LoopBe Internal MIDI");
  
}

void draw() {
  if (read) {
    /*
    *  READ MODE
    *
    * get a file
    * read packets from file at rate of draw loop
    * packets are sized for the smallest possible note... 32nd maybe?
    * parse packets in to midi notes and duration (+ other data?)
    * send noteon and noteoff messages
    * (or set a future event for a noteoff?)
    */
    
    try { //get a line from input and catch I/O errors
      input = reader.readLine();
    } catch (IOException e) {
      e.printStackTrace();
      input = null;
    }
    if (input == null) {
      //there was an error. stop trying to read.
      noLoop();
    } else {
      //parse MIDI messages from input line
      //send MIDI messages via MidiBus
      
      //or maybe the other way around??
      //send midi messages queued up from last pass
      //then pre-read and store midi messages for next pass
    }
    
  } else {
    /*
    * WRITE MODE
    *
    * most of the work for write mode 
    * is handled via keyPressed() and keyReleased()
    * so all this really needs to do is keep time
    * at the end of each draw loop, start a new line in the output
    * and maybe display the sequence being written
    */
  }
}

void keyPressed() {

  if (read) {
    println("you are in read mode.");
  } else {
    //write MIDI noteon messages to output using output.print()
    switch (key) {
      case 'a': case 'A':
        //handle A
        break;
      case 'b': case 'B':
        //handle B
        break;
    }
  }
}

void keyReleased() {

  if (read) {
    println("you are in read mode.");
  } else {
    //write MIDI noteoff messages to output
    switch (key) {
      case 'a': case 'A':
        //handle A
        break;
      case 'b': case 'B':
        //handle B
        break;
    }
  }
}


int calculateFPS(bpm) {
  /*
  * smallest note possible is 32nd, therefore
  * smallest time interval needed is duration of a 32nd note
  */
  return 1 / ((bpm / 60) / 32);
}

void stop () {
  output.flush(); // Writes the remaining data to the file
  output.close(); // Finishes the file
  midiBus.close(); //closes midi connections
  exit();
}
