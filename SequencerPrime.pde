import themidibus.*;

MidiBus midiBus; //MidiBus
PrintWriter output; //output file writer
BufferedReader reader; //input file reader
String input; //for reading lines from input file

boolean read = false; //true for read mode, false for write mode
boolean passthru = true; //true means midi messages are also sent in write mode
float SMALLEST_NOTE = 32.0; //smallest possible note... 32nd for now
String[] NOTES = {"C","C#","D","D#","E","F","F#","G","G#","A","A#","B"};
char[] VALID_KEYS = {'q','w','e','r','t','y','u','i','o','p','[',']'};
int octave;

void setup() {

  size(300, 100);
  float bpm = 120.0;
  frameRate(calculateFPS(bpm)); 

  if (read) {
    //initialize the BufferedReader
    reader = createReader("testfile.txt");
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
    * read lines from file at rate of draw loop
    * lines are sized for the smallest possible note... 32nd maybe?
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
      String[] messages = split(input, ',');
      if (messages.length > 1) {
        for (int i = 0; i < messages.length -1 ; i++) {
          if (messages[i].charAt(0) == '!') {
            //leading ! means noteoff
            int pitch = int(messages[i].substring(1));
            midiBus.sendNoteOff(1, pitch, 70);
            println("sent midi noteoff - pitch" + pitch);
          } else {
            //no leading ! means noteon
            int pitch = int(messages[i]);
            midiBus.sendNoteOn(1, pitch, 70);
            println("sent midi noteon - pitch" + pitch);
          }
        }
      }
      
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
    
    output.print("\n");
    
  }
}

void keyPressed() {
  if (key == 'x') {
    stop();
  }
  if (read) {
    println("you are in read mode.");
  } else {
    writeMidiNoteOn();
  }
}

void keyReleased() {
  if (!read) {
    writeMidiNoteOff();
  }
}

void writeMidiNoteOn() {
  //write MIDI noteon messages to output using output.print()
  int pitch = (octave+1)*12;
  switch (key) {
    case 'q':
      //note C
      //default pitch is C
      break;
    case 'w':
      //note C#
      pitch = pitch + 1;
      break;
    case 'e':
      //note D
      pitch = pitch + 2;
      break;
    case 'r':
      //note D#
      pitch = pitch + 3;
      break;
    case 't':
      //note E
      pitch = pitch + 4;
      break;
    case 'y':
      //note F
      pitch = pitch + 5;
      break;
    case 'u':
      //note F#
      pitch = pitch + 6;
      break;
    case 'i':
      //note G
      pitch = pitch + 7;
      break;
    case 'o':
      //note G#
      pitch = pitch + 8;
      break;
    case 'p':
      //note A
      pitch = pitch + 9;
      break;
    case '[':
      //note A#
      pitch = pitch + 10;
      break;
    case ']':
      //note B
      pitch = pitch + 11;
      break;
    case '-':
      octave--;
      break;
    case '=':
      octave++;
      break;
  }
  if (key == '-' || key == '=') {
      println("octave changed to " + octave);
  } else {
    for (int i = 0; i < VALID_KEYS.length; i++) {
      //test if key is a valid note key 
      if (key == VALID_KEYS[i]) {
        //if valid, write pitch to output
        output.print(pitch + ",");
        println("wrote note on - pitch " + pitch);
        if (passthru) {
          midiBus.sendNoteOn(1, pitch, 70);
        }
        break;
      }
    }
  }
}

void writeMidiNoteOff() {
  //write MIDI noteoff messages to output using output.print()
  int pitch = (octave+1)*12;
  switch (key) {
    case 'q':
      //note C
      //default pitch is C
      break;
    case 'w':
      //note C#
      pitch = pitch + 1;
      break;
    case 'e':
      //note D
      pitch = pitch + 2;
      break;
    case 'r':
      //note D#
      pitch = pitch + 3;
      break;
    case 't':
      //note E
      pitch = pitch + 4;
      break;
    case 'y':
      //note F
      pitch = pitch + 5;
      break;
    case 'u':
      //note F#
      pitch = pitch + 6;
      break;
    case 'i':
      //note G
      pitch = pitch + 7;
      break;
    case 'o':
      //note G#
      pitch = pitch + 8;
      break;
    case 'p':
      //note A
      pitch = pitch + 9;
      break;
    case '[':
      //note A#
      pitch = pitch + 10;
      break;
    case ']':
      //note B
      pitch = pitch + 11;
      break;
  }
  for (int i = 0; i < VALID_KEYS.length; i++) {
    //test if key is a valid note key 
    if (key == VALID_KEYS[i]) {
      //if valid, write pitch to output
      output.print("!" + pitch + ",");
      println("wrote note off - pitch " + pitch);
      if (passthru) {
        midiBus.sendNoteOff(1, pitch, 70);
      }
      break;
    }
  }
}

int calculateFPS(float bpm) {
  /*
  * duration of one frame =
  * (desired BPM / 60 secs per min) 
  * all over duration of smallest possible note
  */
  float fps =  1.0 / ((bpm / 60.0) / SMALLEST_NOTE);
  println("framerate is " + fps);
  return (int) fps;
}

void stop () {
  output.flush(); // Writes the remaining data to the file
  output.close(); // Finishes the file
  midiBus.close(); //closes midi connections
  exit();
}
