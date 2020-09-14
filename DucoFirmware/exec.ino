/**
*  DUCO - CORE
*  The main script to parse any incoming cmds
*/

boolean exec_executeBasicCommand(String &com)
{
  boolean executed = true;
  if (com.startsWith(CMD_CHANGELENGTH)) //C01 Move Pen To Point
    exec_changeLength();
#ifdef VECTOR_LINES
  else if (com.startsWith(CMD_CHANGELENGTHDIRECT)) // C17 draw a straight line
    exec_changeLengthDirect();
#endif
  else if (com.startsWith(CMD_SETMOTORSPEED))  //C31
    exec_setMotorSpeed();
  else if (com.startsWith(CMD_SETMOTORACCEL))  //C32
    exec_setMotorAcceleration();
  else if (com.startsWith(CMD_SETPOSITION))  //C09 SET HOME
    exec_setPosition();
  else if (com.startsWith(CMD_PENDOWN))  // C13 penDown
    penlift_penDraw();
  else if (com.startsWith(CMD_PENUP))  //  C14 penUp
    penlift_penRelease();
  else if (com.startsWith(CMD_SETPENLIFTRANGE))  // C45
    exec_setPenLiftRange();
  else if (com.startsWith(CMD_SETMACHINESIZE))  // C24
    exec_setMachineSizeFromCommand();
  else if (com.startsWith(CMD_SETMACHINEMMPERREV))
    exec_setMachineMmPerRevFromCommand();
  else if (com.startsWith(CMD_SETMACHINESTEPSPERREV))
    exec_setMachineStepsPerRevFromCommand();
  else if (com.startsWith(CMD_GETMACHINEDETAILS))
    exec_reportMachineSpec();
  else if (com.startsWith(CMD_RESETEEPROM))
    eeprom_resetEeprom();
  // new added function
  else if (com.startsWith(CMD_CHANGESPEEDMODE)) //C03
    exec_setSpeedMode(); 
  else if (com.startsWith(CMD_SWITCHPEN)) //C12
    exec_setPenMode();
  // new added function
  else if (com.startsWith(CMD_PLAROTATE))
    exec_platRotate();
  else if (com.startsWith(CMD_CHANGEMOTORMODE))
    exec_setMotorMode();
  else
    executed = false; // no basic command is executed

  return executed;
}

void exec_reportMachineSpec()
{
  eeprom_dumpEeprom();
  Serial.print(F("PGSIZE,")); // align with String.startsWith() in processing
  Serial.print(machineWidth);
  Serial.print(COMMA);
  Serial.print(machineHeight);
  Serial.println(CMD_END);

  Serial.print(F("PGMMPERREV,"));
  Serial.print(mmPerRev);
  Serial.println(CMD_END);

  Serial.print(F("PGSTEPSPERREV,"));
  Serial.print(motorStepsPerRev);
  Serial.println(CMD_END);

  Serial.print(F("PGLIFT,"));
  Serial.print(downPosition);
  Serial.print(COMMA);
  Serial.print(upPosition);
  Serial.println(CMD_END);

  Serial.print(F("PGSPEED,"));
  Serial.print(currentMaxSpeed);
  if(usingAcceleration){
    Serial.print(COMMA);
    Serial.print(currentAcceleration);
  }
  Serial.println(CMD_END);

  Serial.print(F("SPEEDMATCH:"));
  Serial.print(speedMatch? 1:0);
  Serial.print(COMMA);
  Serial.print(F("ACCEL:"));
  Serial.print(usingAcceleration? 1:0);
  Serial.println(CMD_END);

  Serial.print(F("PENMODE:"));
  Serial.print(penMode);
  Serial.println(CMD_END);
}



/*--- accept new values from inParams, store them into EEPROM and also reload to global variables---*/
// C04 interleave/microstepping change
void exec_setMotorMode(){
  byte motorMode = (byte) atoi(inParam1);
  // motor._speed/_maxSpeed/_accel/_position will all be set to zero
  if(motorMode != currentMotorMode){
    if(motorMode==0){
      motorA = AccelStepper(forwardaI, backwardaI);
      motorB = AccelStepper(forwardbI, backwardbI);
      Serial.println("Interleave choosen!");
    }
    if(motorMode==1){
      motorA = AccelStepper(forwardaM, backwardaM);
      motorB = AccelStepper(forwardbM, backwardbM);
      Serial.println("Microstepping choosen!");
    }
    currentMotorMode = motorMode;
    // don't know why these settings are needed
    // but without them, stepper's speed is not controllable
    // i.e. setSpeed doesn't work
    motorA.setMaxSpeed(defaultMaxSpeed);
    motorB.setMaxSpeed(defaultMaxSpeed);
    motorA.setAcceleration(defaultMaxAcceleration);  
    motorB.setAcceleration(defaultMaxAcceleration);
  }
}

// C03 speedmode change
void exec_setSpeedMode(){
  byte speedSelector = (byte) atoi(inParam1);
  EEPROM_writeAnything(EEPROM_SPEED_MODE,speedSelector);
  eeprom_loadSpeedMode(); // reload
  if(!usingAcceleration){
    EEPROM_writeAnything(EEPROM_MACHINE_MOTOR_ACCEL, -1); // not used
    eeprom_loadSpeed();  // reload speed and accel
  }
}

// C11 for platform rotate
void exec_platRotate(){
  int Selection = atoi(inParam1);
  if(Selection<=3 && Selection>=1){
    platformRotate(Selection);
  }
  else{
    Serial.println("Selection not valid!");
  }
}

// C12 pen switch
void exec_setPenMode(){
  int mode = atoi(inParam1);
  EEPROM_writeAnything(EEPROM_PEN_MODE,mode);
  eeprom_loadPenMode(); //reload
  switch(penMode){
    case 0:
      // reset to default
      EEPROM_writeAnything(EEPROM_PENLIFT_DOWN,DEFAULT_DOWN_POSITION);
      EEPROM_writeAnything(EEPROM_PENLIFT_UP,DEFAULT_UP_POSITION);
      eeprom_loadPenUpPosition(); // reload
      eeprom_loadPenDownPosition();//
      break;
    case 1:
      EEPROM_writeAnything(EEPROM_PENLIFT_UP,-1); //not used
      EEPROM_writeAnything(EEPROM_PENLIFT_DOWN,0); //set to lowest value
      eeprom_loadPenUpPosition(); // reload
      eeprom_loadPenDownPosition(); // reload
      break;
    case 2:
      // need change along with different pen length/setup
      EEPROM_writeAnything(EEPROM_PENLIFT_UP,1750);
      eeprom_loadPenUpPosition(); // reload
      dynamicDownPos = upPosition;
      break;
    default:
      break;
  }
}

// C24
void exec_setMachineSizeFromCommand()
{
  int width = atoi(inParam1); // machine width
  int height = atoi(inParam2); // machine height

  // load to get current settings
  int currentValue;
  EEPROM_readAnything(EEPROM_MACHINE_WIDTH, currentValue);
  if (currentValue != width)
    if (width > 10)
    {
      EEPROM_writeAnything(EEPROM_MACHINE_WIDTH, width);
    }
  
  EEPROM_readAnything(EEPROM_MACHINE_HEIGHT, currentValue);
  if (currentValue != height)
    if (height > 10)
    {
      EEPROM_writeAnything(EEPROM_MACHINE_HEIGHT, height);
    }

  // reload 
  eeprom_loadMachineSize(); // load from EEPROM to global variables - machineWidth & machineHeight
}
void exec_setMachineMmPerRevFromCommand()
{
  EEPROM_writeAnything(EEPROM_MACHINE_MM_PER_REV, (float)atof(inParam1));
  eeprom_loadMachineSpecFromEeprom();
}
void exec_setMachineStepsPerRevFromCommand()
{
  EEPROM_writeAnything(EEPROM_MACHINE_STEPS_PER_REV, atoi(inParam1));
  eeprom_loadMachineSpecFromEeprom();
}

void exec_setPenLiftRange()
{
  // Laser Cutting mode
  if (penMode==1 && inNoOfParams ==1){
    exec_setLaserPower();
  }
  // Linear Actuation mode
  if (penMode==0){
    int down = atoi(inParam1);
    int up = atoi(inParam2);
    if (inNoOfParams == 3) 
    {
      // 3 params (C45,<downpos>,<uppos>,1,END) means save values to EEPROM
      EEPROM_writeAnything(EEPROM_PENLIFT_DOWN, down);
      EEPROM_writeAnything(EEPROM_PENLIFT_UP, up);
      eeprom_loadPenDownPosition();
      eeprom_loadPenUpPosition();
    }
    else if (inNoOfParams == 2)
    {
      // 2 params (C45,<downpos>,<uppos>,END) means just do a range test
      // first movePen to up postion
      penlift_initial(up);
      // then do the test
      penlift_movePen(up, down, penLiftSpeed);
      delay(200);
      penlift_movePen(down, up, penLiftSpeed);
      delay(200);
    }
  }
  // Pen Force mode
  if (penMode==2){
    int low= atoi(inParam1);
    int high = atoi(inParam2);
    ResHig = high;
    ResLow = low;
    if (inNoOfParams == 2)
    {
      // test on new pressure
      isPenUp = false;
      penforce();
      delay(1500); // delay some time
      penlift_penUp(); // return to normal
    }
  }
}
// used in penMode:1
void exec_setLaserPower(){
  int down = constrain(atoi(inParam1),0,100);
  EEPROM_writeAnything(EEPROM_PENLIFT_DOWN,down);
  eeprom_loadPenDownPosition();
  Serial.print("set power to:");
  Serial.println(downPosition);
}

//Single parameter to set max speed, add a second parameter of "1" to make it persist.
void exec_setMotorSpeed()
{
  exec_setMotorSpeed((float)atof(inParam1));
  if (inNoOfParams == 2 && atoi(inParam2) == 1) // second parameter appears as "1", store to EEPROM
    EEPROM_writeAnything(EEPROM_MACHINE_MOTOR_SPEED, currentMaxSpeed);
}
void exec_setMotorSpeed(float speed)
{
  currentMaxSpeed = speed;
  Serial.print(F("New max speed: "));
  Serial.println(currentMaxSpeed);
}

// Single parameter to set acceleration, add a second parameter of "1" to make it persist.
void exec_setMotorAcceleration()
{
  exec_setMotorAcceleration((float)atof(inParam1));
  if (inNoOfParams == 2 && atoi(inParam2) == 1)
    EEPROM_writeAnything(EEPROM_MACHINE_MOTOR_ACCEL, currentAcceleration);
}
void exec_setMotorAcceleration(float accel)
{
  currentAcceleration = accel;
  Serial.print(F("New accel: "));
  Serial.println(currentAcceleration);
}

// C09 SET HOME
// inParam1 and inParam2 are both absolute steps
void exec_setPosition()
{
  long targetA = atol(inParam1);
  long targetB = atol(inParam2);
  motorA.setCurrentPosition(targetA); // set absolute position value
  motorB.setCurrentPosition(targetB);
  impl_engageMotors(); // do a brief test after SET HOME
  reportPosition();
  //store Home position
  StartPosA = targetA;
  StartPosB = targetB;
}


/* ------ depends on changeLength() which already takes care of speed/accel stuffs --------*/
// CO1 Move Pen to point not necessarily straight line
// inParam1 & inParam2 give target absolute position in steps
// adding functionality to return HOME
void exec_changeLength()
{
  float lenA=(float)atof(inParam1);
  float lenB=(float)atof(inParam2);
  if(lenA<0 && lenB<0){
    //return home when obtained "C01,-1,-1,END"
    lenA = (float)StartPosA;
    lenB = (float)StartPosB;
  }
  Serial.println("begin non-straight line moving!");
  changeLength(lenA, lenB, currentMaxSpeed, currentMaxSpeed); // not straight line, run with max speed
}

#ifdef VECTOR_LINES
void exec_changeLengthDirect()
{
  float endA = (float)atof(inParam1); // in steps
  float endB = (float)atof(inParam2); // in steps
  int maxSegmentLength = atoi(inParam3);  // max length one time

  float startA = motorA.currentPosition(); // in steps
  float startB = motorB.currentPosition(); // in steps

  if (endA < 20 || endB < 20 || endA > getMaxLength() || endB > getMaxLength())
  {
    Serial.print(MSG_E_STR);
    Serial.println(F("This point falls outside the area of this machine. Skipping it."));
  }
  else
  {
    exec_drawBetweenPoints(startA, startB, endA, endB, maxSegmentLength);
  }
}  

// p1, p2 are represented as native coordinates
// moving between them should be direct!!!
void exec_drawBetweenPoints(float p1a, float p1b, float p2a, float p2b, int maxSegmentLength)
{
  float c1x = getCartesianXFP(p1a, p1b);
  float c1y = getCartesianYFP(c1x, p1a);
  
  float c2x = getCartesianXFP(p2a, p2b);
  float c2y = getCartesianYFP(c2x, p2a);
  
  if (c2x > 20 
    && c2x<pageWidth-20 
    && c2y > 20 
    && c2y <pageHeight-20
    && c1x > 20 
    && c1x<pageWidth-20 
    && c1y > 20 
    && c1y <pageHeight-20 
    )
    {
    reportingPosition = false;
    float deltaX = c2x-c1x;    // distance each must move (signed)
    float deltaY = c2y-c1y;

    int linesegs = 1;            // assume at least 1 line segment will get us there.
    if (abs(deltaX) > abs(deltaY))
    {
      // slope <=1 case    
      while ((abs(deltaX)/linesegs) > maxSegmentLength)
      {
        linesegs++;
      }
    }
    else
    {
      // slope >1 case
      while ((abs(deltaY)/linesegs) > maxSegmentLength)
      {
        linesegs++;
      }
    }
    
    // reduce delta to one line segments' worth.
    deltaX = deltaX/linesegs;
    deltaY = deltaY/linesegs;
  
    // render the line in N shorter segments
    long runSpeed = 0;

    while (linesegs > 0)
    {
      c1x = c1x + deltaX;
      c1y = c1y + deltaY;
  
      // convert back to native coordinates
      float pA = getMachineA(c1x, c1y);
      float pB = getMachineB(c1x, c1y);
    
      // do the move with speed control or not
      if(usingAcceleration){
        runSpeed = desiredSpeed(linesegs, runSpeed, currentAcceleration*2);
      }
      else{
        runSpeed = currentMaxSpeed;
      }

      // adding speed match for two steppers
      // this function is under development!
      // high speed stepper will compromise to lower one
      // and line quality is not improved?
      if(speedMatch){
        float absRatio = speedRatioMatch(c1x-deltaX,c1y-deltaY,c1x,c1y); 
        if(absRatio>1){
          changeLength(pA, pB, runSpeed, runSpeed/absRatio); 
        }
        else{
          changeLength(pA, pB, runSpeed*absRatio, runSpeed); 
        }
      }
      else{
        changeLength(pA, pB, runSpeed, runSpeed);
      }
  
      // one line less to do!
      linesegs--;
    }
    // reset back to "normal" operation
    reportingPosition = true;
    reportPosition();
  }
  else
  {
    Serial.print(MSG_E_STR);
    Serial.println(F("Line is not on the page. Skipping it."));
  }
}
#endif
