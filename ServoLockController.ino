/*
 * Bhuridech Sudsee
 * SUT Hackathon (23/4/2017)
 */
#include <Servo.h>
#define EOL_TERMINATOR '@'
Servo servo1;
Servo servo2;
int pos1 = 0;
int pos2 = 0;
String receive = "";
char inByte = 0;
void setup() {
  Serial.begin(9600); //Setup serialport at 9600 baud
  servo1.attach(9);  // attaches  the servo on pin 9 to the servo object
  servo2.attach(10);  // attaches the servo on pin 10 to the servo object
}

void loop() {
  if (Serial.available() > 0) {
    // get incoming byte:
    inByte = Serial.read();
    if (inByte != EOL_TERMINATOR)
      receive.concat(inByte);
    else {
      if(receive.equals("lock1")){
        pos1 = lock(servo1,pos1);
      }
      if(receive.equals("unlock1")){
        pos1 = unlock(servo1,pos1);
      }
      if(receive.equals("lock2")){
        pos2 = lock(servo2,pos2);
      }
      if(receive.equals("unlock2")){
        pos2 = unlock(servo2,pos2);
      }
      receive = "";
    }
  }
}
int lock(Servo opn,int pos){
  for (pos = pos; pos <= 90; pos += 1) {
    opn.write(pos);
    delay(5);
  }
  return pos-1;
}

int unlock(Servo opn,int pos){
  for (pos = pos; pos >= 0; pos -= 1) {
    opn.write(pos);
    delay(5);
  }
  return pos-1;
}

