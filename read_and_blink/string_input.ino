int i = 0;
char curString[255];
int curInIndex = 0;
char stringEnded = false;

int pin;
int level;

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
  Serial.begin(9600);
  pinMode(13, OUTPUT);
  
  for(i=0; i < 255; i++) curString[i] = 0;
}

void loop() {
  readInput();
  if (stringEnded) {
    pin = curString[0]-64;
    level = curString[1] == '1' ? HIGH : LOW;
    Serial.println("Got a signal!");
    digitalWrite(pin, level);
  }
}
