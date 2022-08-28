#include <Arduino.h>
#include <Ultrasonic.h>

#define TRIGGER_PIN 4 // opto-sensors pins
#define ECHO_PIN    5               
Ultrasonic ultrasonic(TRIGGER_PIN, ECHO_PIN); 

#define OUT1 6 // input 1 - MOTOR A
#define OUT2 7 // input 2 - MOTOR A
#define OUT3 8 // input 1 - MOTOR B
#define OUT4 9 // input 2 - MOTOR B
#define ENA 10 // MOTOR A velocity
#define ENB 11 // MOTOR B velocity

void set_left(){
  digitalWrite(OUT1,HIGH);
  digitalWrite(OUT2,LOW);
  digitalWrite(OUT3,HIGH);
  digitalWrite(OUT4,LOW);
}

void set_forward(){
  digitalWrite(OUT1,HIGH);
  digitalWrite(OUT2,LOW);
  digitalWrite(OUT3,LOW);
  digitalWrite(OUT4,HIGH); 
}

void standby(){
  digitalWrite(OUT1,LOW);
  digitalWrite(OUT2,LOW);
  digitalWrite(OUT3,LOW);
  digitalWrite(OUT4,LOW);   
}

void turn_left(){
  standby();
  delay(500);
  set_left();
  delay(400);                       
  standby();
  delay(500);
}

// float distancia()                   
// {
//   float cmMsec;
//   long microsec = ultrasonic.timing();
//   cmMsec = ultrasonic.convert(microsec, Ultrasonic::CM);
//   return(cmMsec);                   
// delay(10);
// }

// begin code!

void setup() {
    pinMode(OUT1,OUTPUT);
    pinMode(OUT2,OUTPUT);
    pinMode(OUT3,OUTPUT);
    pinMode(OUT4,OUTPUT);
    pinMode(ENA,OUTPUT);
    pinMode(ENB,OUTPUT);

    analogWrite(ENA,120); // controls the motor velocity
    analogWrite(ENB,120);
    
    delay(1000);
}

void loop() {
    set_forward();
    turn_left();
    delay(10);
    float dist_cm = ultrasonic.read();
    Serial.println("In main loop");

    if (dist_cm < 20){
    Serial.println("Lower than 20!");
    set_forward();
    // turn_left();
    }
}