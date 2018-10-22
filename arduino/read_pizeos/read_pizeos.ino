// well-tempered chaos sequencer board version 2.0
// Pizeo to MIDI
// 5/8/2018   By: 3mrrrx
// GNU GPLv3
// all values are in [mm]





// array for holding sesnor values
int myInts[8];




void setup() {

      Serial.begin(9600);

}

void loop() {

  unsigned long currentMillis = millis();

   for (int i=0; i < 8; i++){
    myInts[i] = analogRead(i);

    Serial.print(myInts[i]);      //the first variable for plotting
    if(i != 7){
    Serial.print(","); 
    }
    else
    {
    Serial.println(" "); 
    }

  }
}
