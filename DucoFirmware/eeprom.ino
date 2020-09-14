/**
*  DUCO - CORE
*  eeprom related functions
*/

// reset all stored params to 0
void eeprom_resetEeprom()
{
  // only reset 50 bytes. Actually use 43 bytes for config
  for (int i = 0; i <50; i++)
  {
    EEPROM.write(i, 0);
  }
}

// read Machine size config from EEPROM
void eeprom_loadMachineSize()
{
  EEPROM_readAnything(EEPROM_MACHINE_WIDTH, machineWidth);
  if (machineWidth < 1)
  {
    machineWidth = defaultMachineWidth;
  }
  Serial.print(F("Loaded width:"));
  Serial.println(machineWidth);
  
  EEPROM_readAnything(EEPROM_MACHINE_HEIGHT, machineHeight);
  if (machineHeight < 1)
  {
    machineHeight = defaultMachineHeight;
  }
  Serial.print(F("Loaded height:"));
  Serial.println(machineHeight);
}

// read stepper config from EEPROM
void eeprom_loadSpoolSpec()
{
  EEPROM_readAnything(EEPROM_MACHINE_MM_PER_REV, mmPerRev);
  if (mmPerRev < 1)
  {
    mmPerRev = defaultMmPerRev;
  }
  Serial.print(F("Loaded mmPerRev:"));
  Serial.println(mmPerRev);

  EEPROM_readAnything(EEPROM_MACHINE_STEPS_PER_REV, motorStepsPerRev);
  if (motorStepsPerRev < 1)
  {
    motorStepsPerRev = defaultStepsPerRev;
  }
  Serial.print(F("Loaded steps per rev:"));
  Serial.println(motorStepsPerRev);
}  

// read Pen config from EEPROM
void eeprom_loadPenDownPosition()
{
    EEPROM_readAnything(EEPROM_PENLIFT_DOWN, downPosition);
    if (downPosition < 0)
    {
      downPosition = DEFAULT_DOWN_POSITION;
    }
    Serial.print(F("Loaded down pos:"));
    Serial.println(downPosition);
}

void eeprom_loadPenUpPosition(){
  EEPROM_readAnything(EEPROM_PENLIFT_UP, upPosition);
  Serial.print(F("Loaded up pos:"));
  Serial.println(upPosition);
}

// read stepper max speed/Acceleration from EEPROM
void eeprom_loadSpeed()
{
  // load speed, acceleration
  EEPROM_readAnything(EEPROM_MACHINE_MOTOR_SPEED, currentMaxSpeed);
  if (int(currentMaxSpeed) < 1) {
    currentMaxSpeed = 800.0;
  }
  EEPROM_readAnything(EEPROM_MACHINE_MOTOR_ACCEL, currentAcceleration);
}

void eeprom_loadPenMode(){
  EEPROM_readAnything(EEPROM_PEN_MODE, penMode);
  // only mode 0, 1, 2 used now!!!
  if(penMode>2 && penMode<0){
    penMode=0;
  }
}

void eeprom_loadSpeedMode(){
  byte modeSelector;
  EEPROM_readAnything(EEPROM_SPEED_MODE, modeSelector);
  Serial.print("speed mode is:");
  Serial.println(modeSelector);
  switch(modeSelector){
    case 1:
      speedMatch = false;
      usingAcceleration = true;
      break;
    case 2:
      speedMatch = true;
      usingAcceleration = false;
      break;
    case 3:
      speedMatch = true;
      usingAcceleration = true;
      break;      
    case 0:
    default: 
      speedMatch = false;
      usingAcceleration = false;
      break;  
  }
}

// reload important physical parameters
void eeprom_loadMachineSpecFromEeprom()
{
  eeprom_loadMachineSize();
  eeprom_loadSpoolSpec();

  mmPerStep = mmPerRev / motorStepsPerRev;
  stepsPerMM = motorStepsPerRev / mmPerRev;

  Serial.print(F("Recalc mmPerStep ("));
  Serial.print(mmPerStep);
  Serial.print(F("), stepsPerMM ("));
  Serial.print(stepsPerMM);
  Serial.println(F(")"));

  pageWidth = machineWidth * stepsPerMM;
  Serial.print(F("Recalc pageWidth in steps ("));
  Serial.print(pageWidth);
  Serial.println(F(")"));
  pageHeight = machineHeight * stepsPerMM;

  Serial.print(F("Recalc "));
  Serial.print(F("pageHeight in steps ("));
  Serial.print(pageHeight);
  Serial.print(F(")"));
  Serial.println();

  maxLength = 0;
}
