/**
*  DUCO - CORE
*  enable Linear Actuator, Laser cutter and PenForce control
*  all tool actuating related function is under this script
*  for Linear Actuator: user can change to what extent it presses the pen(penDown)
*  for Laser cutter: user can change working power percentage
*  for PenForce: user can observe auto-adjusting process when drawing on surface with geometries.
*/

void penlift_penDraw(){
  switch(penMode){
    case 1:
      penlift_laserCutterOn();
      break;
    case 2:
      // set pen down
      // then any draw action before next time pen up will implement penforce()
      isPenUp = false;
      penforce();
      break;
    case 0:
    default:
      penlift_penDown();
      break;
  }
}

void penlift_penRelease(){
  switch(penMode){
    case 1:
      penlift_laserCutterOff();
      break;
    case 0:
    case 2:
    default:
      penlift_penUp();
      break;
  }
}

void penlift_laserCutterOn(){
  // WGM2:011 fast PWM with default ticking number 256!
  // here we have WGM2: 111 fast PWM
  // but cycle ticks is not defaulted as 256
  // prescale is 8
  // timer2 B:pin3 only B is enabled, A sacrificed to control top limit
  if(isPenUp){
    pinMode(LASER_PIN, OUTPUT);
    TCCR2A = _BV(COM2A1) | _BV(COM2B1) | _BV(WGM21) | _BV(WGM20);  // _ BV(b) 1<<b;
    TCCR2B = _BV(CS21) | _BV(WGM22);
    // OCR2A will set timer full-ticked number
    // OCR2B set the duty cycle
    OCR2A = 63;  // to make 30Khz PWM
    float percent = (float)downPosition / 100;
    OCR2B =(int)(percent * OCR2A);
  }
  isPenUp=false;
}

void penlift_laserCutterOff(){
  if(!isPenUp){
    OCR2B = 0;
    pinMode(LASER_PIN, INPUT);
  }
  isPenUp=true;
}


// this block enables pen gesture fine-tuning from 1020 to 1990
// and offers change pen function
void penlift_movePen(int start,int end, int delay_ms)
{
  penHeight.attach(PEN_HEIGHT_SERVO_PIN,900,2100);
  if(start < end)
  {
    for (int i=start; i<=end; i+=5) 
    {
      penHeight.writeMicroseconds(i);
      delay(delay_ms);
    }
  }
  else
  {
    for (int i=start; i>=end; i-=5) 
    {
      penHeight.writeMicroseconds(i);
      delay(delay_ms);
    }
  }
  penHeight.detach();
}

void penlift_initial(int up){
  penHeight.attach(PEN_HEIGHT_SERVO_PIN,900,2100);
  penHeight.writeMicroseconds(up);
  delay(5000); // wait linear actuator reach fully up postion
  penHeight.detach();
  isPenUp = true;
}

/*
 * shared function
 */
void penlift_penDown()
{
    if (isPenUp == true)
    {
      penlift_movePen(upPosition, downPosition, penLiftSpeed);
    }
  isPenUp = false;
}
void penlift_penUp()
{
    if (isPenUp == false)
    {
      if(penMode==2){
        penlift_movePen(dynamicDownPos, upPosition, penLiftSpeed);
        // every time pen up, reset DownPos ready for next time penforce()
        dynamicDownPos = upPosition;
      }
      else{
        penlift_movePen(downPosition, upPosition, penLiftSpeed);
      }
    }
  isPenUp = true;
}

// penforce control
void penforce(){
  // pen up, do nothing
  boolean toTarget = false;
  int linear = dynamicDownPos; // dynamically change downPosition!!!
  int increment = 5;
  if(!isPenUp){
    Serial.print("control start with:");
    Serial.println(dynamicDownPos);
    penHeight.attach(PEN_HEIGHT_SERVO_PIN,900,2100); // ready to control
    while(!toTarget){   // do penforce control here
      float forceRes = compute_res();
      if(forceRes < 0 || linear<safetyCheck){ // safety check
        // debug info
        Serial.println("out of range!");
        Serial.println("fail to achieve pressure!");
        Serial.println(forceRes);
        penHeight.detach();
        // linear and safetyCheck will have one increment off 
        dynamicDownPos = safetyCheck; // set new pen down position
        break;
      }
      // do penforce control
      else if(forceRes > ResHig){
        if(linear > 1000){
          linear-=increment;
        }
        penHeight.writeMicroseconds(linear);
        Serial.println(forceRes);
        delay(penLiftSpeed);
      }
      else if(forceRes < ResLow){
        if(linear<2000){
          linear+=increment;
        }
        penHeight.writeMicroseconds(linear);
        Serial.println(forceRes);
        delay(penLiftSpeed);
      }
      // reach control target
      else{
        penHeight.detach();
        toTarget = true;
        dynamicDownPos = linear; // set new pen down position
        Serial.print("control done with:");
        Serial.println(dynamicDownPos);
        Serial.print("new resistance:");
        Serial.println(forceRes);
      }
    }
  }
}
