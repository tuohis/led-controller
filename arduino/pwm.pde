// Select output pin
const int pwmPin = 9;
int pwmValue = 0; // between 0 and 255

const int blinkPin = 13;

// Select input pins
const int manualAutoPin = 8;
const int manualValuePin = 3;

int runningMode = HIGH; // default auto

int blinkCounter = 0;
int blinkThreshold = 64;

void setup() {
  // Init the PWM pin
  pinMode(pwmPin, OUTPUT);
  pinMode(blinkPin, OUTPUT);
  // Init input pins
  pinMode(manualAutoPin, INPUT);
  // Set "auto" mode as default (enable pullup resistor)
  digitalWrite(manualAutoPin, HIGH);
  pinMode(manualValuePin, INPUT);
  // determine if we're in auto or manual (potentiometer) mode
  runningMode = digitalRead(manualAutoPin);
	// Show the mode to the world by blinking in a different way
  if (runningMode == HIGH) {
    blinkThreshold = 64;
  } else {
    blinkThreshold = 224;
  }
  // Init the USB connection if running in auto mode
  Serial.begin(9600);
  // wait for the connection to be established
  while (Serial.available() == 0) {
    Serial.println("Waiting..");
    
    // Blink the led while waiting
    pwmValue ^= B11111111;
    analogWrite(pwmPin, pwmValue);
    delay(500);
  }
  Serial.println("Connected!");

}
/**
 * The main loop which is repeated during normal operation
 */
void loop() {
  int modePinValue = digitalRead(manualAutoPin); // Check operating mode
  // Redo setup if mode changes
  if (modePinValue != runningMode) {
    setup();
  }
  
  handleBlink();
  
  if (runningMode == HIGH) {
    doAuto();
  } else {
    doManual();
  }
  // Tell the host what's going on
  if (blinkCounter == 0) {
    Serial.print("Using ");
		if (runningMode == HIGH)
			Serial.print("AUTO");
		else
			Serial.print("MANUAL");
    Serial.print(" mode. Value: ");
    Serial.println(pwmValue);
  }
  delay(10);
}
/**
 * The function to run each loop iteration if in auto mode.
 * Reads a new PWM value from serial buffer if exists, tells
 * the host what the value read is and sets it as the new
 * pwmValue.
 */
void doAuto() {
  if (Serial.available() > 0) {
    int newValue = readValue();
    if (newValue < 0) return;
    
    pwmValue = newValue;
    analogWrite(pwmPin, pwmValue);
    Serial.print("Read value ");
    Serial.println(newValue);
  }
}

/**
 * Handle the manual mode. Read the potentiometer input and
 * set the PWM accordingly.
 * Note: conversion from the ADC range [0,1023] to PWM out range [0,255]
 */
void doManual() {
  // analog values between 0 and 1023
  pwmValue = analogRead(manualValuePin) / 4;
  analogWrite(pwmPin, pwmValue);
}

/**
 * Blink the on-board LED to show the world what is going on.
 * An integrated HW timer could be used, I guess, but this is just for debug.
 */
void handleBlink() {
  if (blinkCounter == blinkThreshold) {
    digitalWrite(blinkPin, LOW);
  }
  blinkCounter++;
  if (blinkCounter > 255) {
    blinkCounter = 0;
    digitalWrite(blinkPin, HIGH);
  }
}

/**
 * Read a PWM value from the serial buffer.
 */
int readValue() {
	int newValue = -1;
	int newByte = 0;
	while ((newByte = Serial.read()) > -1) {
		newValue = newByte;
	}
	if (newValue < 0) {
		Serial.println("Nothing to read.");
        }
  return newValue;
}
