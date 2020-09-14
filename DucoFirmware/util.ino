/**
*  DUCO - CORE
*  all utility functions needed
*/

boolean checkFeedback(int low, int high){
  // debug
  lastPer = weight * lastPer + (1-weight) * analogRead(IR);
  return (lastPer< high && lastPer > low);
}

// receive pen # ranged in [1,3]
// rotate platform clockwise until find that slot
// detection logic is done by IR feedback comparing with well-set threshold
// actuation is done by basic servo
void platformRotate(int s){
  int thresH;
  int thresL;
  switch(s){
    case 2:
      thresH = threshold2High;
      thresL = threshold2Low;
      break;
    case 3:
      thresH = threshold3High;
      thresL = threshold3Low;
      break;
    case 1:
    default:
      thresH = threshold1High;
      thresL = threshold1Low;
      break;
  }
  platRot.attach(PLAT_ROTATE);
  // rotate until get to the correct position
  long switchStart = millis();
  platRot.write(Clockwise);
  // ensure moving out of last slot
  // one time trigger, should not in loop
  if(lastFound) delay(300);
  while(true){
    if(checkFeedback(thresL,thresH)){
        delay(interval);
        if(checkFeedback(thresL,thresH)){
          Serial.println("slot found!");
          lastFound=true;
          break;
        }
    }
    if(millis() - switchStart > switchTimeout){
      Serial.println("timeout and not found!");
      lastFound=false;
      break;
    }
  }
  platRot.write(stop); // reach the slot, stop
  platRot.detach();
}
/* ----------------------------- stepper control logic mod -----------------------------*/
void changeLength(float tA, float tB, float speedA, float speedB)
{
  changeLength((long)tA, (long)tB,speedA,speedB);
}

// run two motors to absolute positions
// param[in] tAl, tBl long-type absolute target position
void changeLength(long tAl, long tBl, float speedA, float speedB)
{
  float tA = float(tAl);
  float tB = float(tBl);
  lastOperationTime = millis();

  // interleave with penforce function
  // warning: deadlock may occur if the range is not reachable
  // warning: slow implementation may occur if the range is too narrow
  if(penMode==2){
    penforce();
  }
  
  motorA.moveTo(tA);  
  motorB.moveTo(tB);
  
  // also moveTo will set a speed with
  if(motorA.distanceToGo() < 0){   
    motorA.setSpeed(-speedA);
  }
  else{
    motorA.setSpeed(speedA);
  }
  
  if(motorB.distanceToGo() < 0){
    motorB.setSpeed(-speedB);
  }
  else{
    motorB.setSpeed(speedB);
  }
  
  // return "signed" steps needed to get to target position
  while (motorA.distanceToGo() != 0 || motorB.distanceToGo() != 0)
  {
    if (currentlyRunning)
    {
      motorA.runSpeedToPosition(); // runSpeed() iterations 
      motorB.runSpeedToPosition(); // i.e. use same speed to reach the target
    }
  }
  reportPosition();
}

void changeLengthRelative(float tA, float tB)
{
  changeLengthRelative((long) tA, (long)tB);
}

// run two motors for steps relative to curr position
// param[in] tA, tB steps needed to run
void changeLengthRelative(long tA, long tB)
{
  lastOperationTime = millis();
  motorA.move(tA); // relative moving
  motorB.move(tB);
  // also moveTo will set a speed with
  if(motorA.distanceToGo() < 0){   
    motorA.setSpeed(-currentMaxSpeed);
  }
  else{
    motorA.setSpeed(currentMaxSpeed);
  }
    
  if(motorB.distanceToGo() < 0){
    motorB.setSpeed(-currentMaxSpeed);
  }
  else{
    motorB.setSpeed(currentMaxSpeed);
  }

  
  while (motorA.distanceToGo() != 0 || motorB.distanceToGo() != 0)
  {
    if (currentlyRunning)
    {
      motorA.runSpeedToPosition();
      motorB.runSpeedToPosition();
    }
  }
  reportPosition();
}

// This is called:
//  after each step
//  after user changes:
//   maxSpeed
//   acceleration
//   target position
float desiredSpeed(long distanceTo, float currentSpeed, float acceleration)
{
    float requiredSpeed;
    if (distanceTo == 0)
  return 0.0f; // We're there

    // sqrSpeed is the signed square of currentSpeed.
    float sqrSpeed = sq(currentSpeed);
    if (currentSpeed < 0.0)
      sqrSpeed = -sqrSpeed;
      
    float twoa = 2.0f * acceleration; // 2ag
    
    // if v^^2/2as is the the left of target, we will arrive at 0 speed too far -ve, need to accelerate clockwise
    if ((sqrSpeed / twoa) < distanceTo)
    {
      // Accelerate clockwise
      if (currentSpeed == 0.0f)
          requiredSpeed = sqrt(twoa);
      else
          requiredSpeed = currentSpeed + fabs(acceleration / currentSpeed);
    
      if (requiredSpeed > currentMaxSpeed)
          requiredSpeed = currentMaxSpeed;
    }
    else
    {
      // Decelerate clockwise, accelerate anticlockwise
      if (currentSpeed == 0.0f)
          requiredSpeed = -sqrt(twoa);
      else
          requiredSpeed = currentSpeed - fabs(acceleration / currentSpeed);
      if (requiredSpeed < -currentMaxSpeed)
          requiredSpeed = -currentMaxSpeed;
    }
    return requiredSpeed;
}

// match two steppers speed
// make the platform move as straight as possible
// under development
float speedRatioMatch(float c1x, float c1y, float c2x, float c2y){
  float ra = getMachineA(c1x, c1y);
  float rb = getMachineB(c1x, c1y);
  float var = (c1y-c2y)*(float)pageWidth/(c1x*c2y-c2x*c1y);
  float ratio = abs((ra/rb)*(1+var));
  // place thresholds to deal with extreme cases
  if(ratio > 2){
    return 2;
  }
  else if(ratio < 0.5){
    return 0.5;
  }
  else{
    return ratio;
  }
}
/* ----------------------------- stepper control logic mod for Vector -----------------------------*/
// compute and output FSR's resistance
float compute_res(void){
  float supply = 5;  // Volts
  float devRes = 47; 
  float u;
  float res;
  pinMode(power,OUTPUT);
  // open testing circuit
  digitalWrite(power,HIGH);
  delay(10);
  //now get the voltage signal
  u=(float)analogRead(FSR) / 1024 * supply;
  //compute the resistance
  if(supply>u ){
    res=devRes * u / (supply-u);
    return res;
  }
  else{
    return -1;
  }
}


// diagonal max length of the page(machine)
long getMaxLength()
{
  if (maxLength == 0)
  {
//    float length = getMachineA(pageWidth, pageHeight);
    maxLength = long(getMachineA(pageWidth, pageHeight)+0.5);
    Serial.print(F("maxLength: "));
    Serial.println(maxLength);
  }
  return maxLength;
}

// distance between pendulum and stepper A
float getMachineA(float cX, float cY)
{
  float a = sqrt(sq(cX)+sq(cY));
  return a;
}

// distance between pendulum and stepper B
float getMachineB(float cX, float cY)
{
  float b = sqrt(sq((pageWidth)-cX)+sq(cY));
  return b;
}

// Serial print position report
void reportPosition()
{
  if (reportingPosition)
  {
    Serial.print(OUT_CMD_SYNC_STR);
    Serial.print(motorA.currentPosition());
    Serial.print(COMMA);
    Serial.print(motorB.currentPosition());
    Serial.println(CMD_END);
  }
}


/*--- 2 anchor "polar" coordinates to Cartesian coordinates transformation ---*/
// unit is step!!
float getCartesianXFP(float aPos, float bPos)
{
  float calcX = (sq((float)pageWidth) - sq((float)bPos) + sq((float)aPos)) / ((float)pageWidth*2.0);
  return calcX;  
}
float getCartesianYFP(float cX, float aPos) 
{
  float calcY = sqrt(sq(aPos)-sq(cX));
  return calcY;
}

long getCartesianX(float aPos, float bPos)
{
  long calcX = long((pow(pageWidth, 2) - pow(bPos, 2) + pow(aPos, 2)) / (pageWidth*2));
  return calcX;  
}

long getCartesianX() {
  long calcX = getCartesianX(motorA.currentPosition(), motorB.currentPosition());
  return calcX;  
}

long getCartesianY() {
  return getCartesianY(getCartesianX(), motorA.currentPosition());
}
long getCartesianY(long cX, float aPos) {
  long calcY = long(sqrt(pow(aPos,2)-pow(cX,2)));
  return calcY;
}
/*--- 2 anchor "polar" coordinates to Cartesian coordinates transformation ---*/
