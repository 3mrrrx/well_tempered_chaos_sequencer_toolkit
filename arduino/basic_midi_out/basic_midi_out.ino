// well-tempered chaos sequencer board version 2.0
// Pizeo to MIDI
// 5/8/2018   By: 3mrrrx
// GNU GPLv3
// all values are in [mm]

#include <MIDI.h>


const int piezo = A0; // analog pin 0 is connected to the Pizeo 
const int threshold = 100;  // threshold value to filter 


int piezoReading = 0;      // variable to store the value read from the piezo 
int vel = 0 ;              // variable to store the velocity value

 // Created and binds the MIDI interface to the default hardware Serial port
 MIDI_CREATE_DEFAULT_INSTANCE();

 
 // this function is called on arduino start
 void setup()
 {
 
 }

 void loop()
 {

     // Send note on 42 with velocity 127 on channel 1
     MIDI.sendNoteOn(42, 127, 1);

     // wait for 500 ms
      delay(500);

     // Send note off 42 with velocity 127 on channel 1
     MIDI.sendNoteOff(42, 127, 1);

     
     // wait for 1000 ms
      delay(1000);

  
}



 
 
