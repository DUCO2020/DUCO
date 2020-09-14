/**
*  DUCO - CORE
*  some useful functions during implementation
 */
boolean impl_processCommand(String com)
{
#if MICROCONTROLLER == MC_UNO
  return impl_executeCommand(com);
#endif
}

boolean impl_executeCommand(String &com)
{
  if (exec_executeBasicCommand(com)) //
  {
    return true;
  }
  else
  {
    comms_unrecognisedCommand(com); // return this is a non-recognized command!
    return false;
  }
}

// for energe saving
void impl_runBackgroundProcesses()
{
  long motorCutoffTime = millis() - lastOperationTime;
  if ((automaticPowerDown) && (powerIsOn) && (motorCutoffTime > motorIdleTimeBeforePowerDown))
  {
    Serial.print(MSG_I_STR);
    Serial.println(F("Powering down."));
    impl_releaseMotors();
  }
}

// this function use AccelStepper library offered operating API
// .setSpeed() should be called beforehand
void impl_engageMotors()
{
  powerIsOn = true;
   // brief test after SET HOME
   motorA.setSpeed(currentMaxSpeed);
   motorB.setSpeed(currentMaxSpeed);
   motorA.moveTo(motorA.currentPosition()+4);
   motorB.moveTo(motorB.currentPosition()+4);
   while(motorA.distanceToGo()!=0 || motorB.distanceToGo()!=0){
     motorA.runSpeedToPosition();
     motorB.runSpeedToPosition();
   }
   motorA.setSpeed(-currentMaxSpeed);
   motorB.setSpeed(-currentMaxSpeed);
   motorA.moveTo(motorA.currentPosition()-4);
   motorB.moveTo(motorB.currentPosition()-4);
   while(motorA.distanceToGo()!=0 || motorB.distanceToGo()!=0){
     motorA.runSpeedToPosition();
     motorB.runSpeedToPosition();
   }
}

// when necessary, release two motors and save power
void impl_releaseMotors()
{
#ifdef ADAFRUIT_MOTORSHIELD_V2
  afMotorA->release();
  afMotorB->release();
#endif
}
