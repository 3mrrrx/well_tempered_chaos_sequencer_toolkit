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
  piezoReading = analogRead(piezo);
  if (piezoReading >= threshold) {

     // mal Pizeo value to MIDI velocity
     vel = map(piezoReading, 0, 1023, 40, 127);
 
     // Send note on 42 with velocity on channel 1
     MIDI.sendNoteOn(42, vel, 1);

     // wait for 10 ms
      delay(10);

     // Send note off 42 with velocity on channel 1
     MIDI.sendNoteOff(42, vel, 1);
  }
}



 
 
