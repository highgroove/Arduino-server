#include <Servo.h>

int i = 0;
char curString[255];
int curInIndex = 0;
int sign = 1;
char stringEnded = false;

int pin;
int level;
Servo myservo;

void readInput() {
  byte b;
  
  if (stringEnded) {
    for (i=0; i<255; i++) curString[i] = 0;
    curInIndex = 0;
    stringEnded = false;
  }
  
  if (Serial.available()) {
    b = Serial.read();
    
    if (b == '\n') {
      stringEnded = true;
      return;
    }
    else {
      curString[curInIndex++] = b;
    }
    
  }
}

void setup() {
  myservo.attach(9);
  Serial.begin(9600);
  pinMode(13, OUTPUT);
  pinMode(12, OUTPUT);
  
  for(i=0; i < 255; i++) curString[i] = 0;
}

void loop() {
  readInput();
  if (stringEnded) {
    switch(curString[0]) {
    case 'P':
      pin = curString[1]-64;
      level = curString[2] == '1' ? HIGH : LOW;
      Serial.println("Got pin change signal");
      digitalWrite(pin, level);
      break;
    case 'S':
      sign = curString[2] == '-' ? -1 : 1;
      Serial.print("Got servo rotate signal ");
      Serial.println((int) (sign * curString[1]));
      myservo.write((int) (sign * curString[1]));  // sets the servo position according to the scaled value
      delay(15);                                   // waits for the servo to get there
      break;
    }
  }
}
