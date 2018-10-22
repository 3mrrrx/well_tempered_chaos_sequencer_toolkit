// well-tempered chaos sequencer board version 2.0
// Pizeo to MIDI
// 5/8/2018   By: 3mrrrx
// GNU GPLv3
// all values are in [mm]

#include <MIDI.h>


// will store last time LED was updated
unsigned long previousMillis = 0;   

// interval at which to blink (milliseconds)     
const long interval = 5000;     // in (milliseconds)        

// threshold value for each of the sensor
const int threshold[] = {
  30, 30, 30, 30, 30, 30, 30, 30 
};

// array for holding sesnor values
int myInts[8];

// check if note is played
int note_on[]= {
  0, 0, 0, 0, 0, 0, 0, 0 
};

// intger for holding velocity for midi send 
int vel = 0 ;

 // Created and binds the MIDI interface to the default hardware Serial port
MIDI_CREATE_DEFAULT_INSTANCE();

// debug = 1;

void setup() {

     MIDI.begin();

}

void loop() {

  //unsigned long currentMillis = millis();

  //if (currentMillis - previousMillis >= interval) {
    // save the last time since last sesnor reading
  //  previousMillis = currentMillis;

   for (int i=0; i < 8; i++){
    myInts[i] = analogRead(i);

    
//    Serial.print(myInts[i]);      //the first variable for plotting
//    if(i != 7){
//    Serial.print(","); 
//    }
//    else
//    {
//    Serial.println(" "); 
//    }


      if (myInts[i] >= threshold[i]) {
        //if (note_on[i] == 0) { 
          
          // mal Pizeo value to MIDI velocity
          // vel = map(piezoReading, 0, 1023, 40, 127);
          
          MIDI.sendNoteOn(42+i, 110, 1);
          note_on[i] = 1 ;
          
          //} else {

          delay(20);
          
          MIDI.sendNoteOff(42+i, 110, 1);
          note_on[i] = 0 ;
          
        }
      }
    }
//}
//}
