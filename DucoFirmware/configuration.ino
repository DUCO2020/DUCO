/**
*  DUCO - CORE
*  use Motorshield v2 since it occupies only two pins to do communication,
*  giving more resources for developing other function
*/
    #ifdef ADAFRUIT_MOTORSHIELD_V2
    Adafruit_MotorShield AFMS = Adafruit_MotorShield(); 
    Adafruit_StepperMotor *afMotorA = AFMS.getStepper(motorStepsPerRev, 1);
    Adafruit_StepperMotor *afMotorB = AFMS.getStepper(motorStepsPerRev, 2);

    void forwardaM() { afMotorA->onestep(FORWARD, stepTypeM); } 
    void backwardaM() { afMotorA->onestep(BACKWARD, stepTypeM); }
    void forwardbM() { afMotorB->onestep(FORWARD, stepTypeM); }
    void backwardbM() { afMotorB->onestep(BACKWARD, stepTypeM); }
    
    void forwardaI() { afMotorA->onestep(FORWARD, stepTypeI); } 
    void backwardaI() { afMotorA->onestep(BACKWARD, stepTypeI); }
    void forwardbI() { afMotorB->onestep(FORWARD, stepTypeI); }
    void backwardbI() { afMotorB->onestep(BACKWARD, stepTypeI); }

    AccelStepper motorA(forwardaI, backwardaI);
    AccelStepper motorB(forwardbI, backwardbI);
    #endif

void configuration_setup()
{
#ifdef ADAFRUIT_MOTORSHIELD_V2
  AFMS.begin();  // create with the default frequency 1.6KHz
#endif
  delay(500);
}
