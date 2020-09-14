/**
*  DUCO - CORE
*  the main file to run this firmware
*  Make sure you have correct hardware setup and wiring
*  then this firmware works reliably
*/
#ifndef MICROCONTROLLER
#define MICROCONTROLLER MC_UNO
#endif
#define ADAFRUIT_MOTORSHIELD_V2
#include <Wire.h>
#include <Adafruit_MotorShield.h>
#define VECTOR_LINES
#define MC_UNO 1

#include <AccelStepper.h>
#include <Servo.h>
#include <EEPROM.h>
#include "EEPROMAnything.h"
const String FIRMWARE_VERSION_NO = "2";
//  EEPROM addresses
const byte EEPROM_MACHINE_WIDTH = 0;
const byte EEPROM_MACHINE_HEIGHT = 2;
const byte EEPROM_MACHINE_MM_PER_REV = 14; // 4 bytes (float)
const byte EEPROM_MACHINE_STEPS_PER_REV = 18;

const byte EEPROM_MACHINE_MOTOR_SPEED = 20; // 4 bytes float
const byte EEPROM_MACHINE_MOTOR_ACCEL = 24; // 4 bytes float

const byte EEPROM_MACHINE_HOME_A = 28; // 4 bytes
const byte EEPROM_MACHINE_HOME_B = 32; // 4 bytes

const byte EEPROM_PENLIFT_DOWN = 36; // 2 bytes
const byte EEPROM_PENLIFT_UP = 38; // 2 bytes

const byte EEPROM_PEN_MODE = 40; // 2 bytes int
const byte EEPROM_SPEED_MODE = 42; // 1 byte  only 2bits used
//const byte EEPROM_PLATFORM = 43;
/**
 *       SpeedMatch  Acceleration       utility
 * 00       false        false       microstepping
 * 01       false        true         Interleave
 * 10       true         false       under experiment
 * 11       true         true        under experiment
 */

int numberResend=0; // resend times counter
// motor setup
const int stepTypeM = MICROSTEP;  //resolution test
const int stepTypeI = INTERLEAVE;
int currentMotorMode = 0;

// Pen gesture control variables
Servo penHeight;
const int DEFAULT_PEN_MODE = 0;
const int DEFAULT_DOWN_POSITION = 1100; //pulse width in micro sec  
const int DEFAULT_UP_POSITION = 1750; // with new plugs
int upPosition = DEFAULT_UP_POSITION; // not used in PenMode 1
int downPosition = DEFAULT_DOWN_POSITION; // become percentage value in penMode 1
int penMode = DEFAULT_PEN_MODE; //0:linear actuator control; 1: laser cutter control; 2:pen force
static int penLiftSpeed = 110; // ms between steps of linear actuator
boolean isPenUp = true; // initial state should be up
byte const PEN_HEIGHT_SERVO_PIN = 10; //UNL2003 driver uses pin 9
byte const LASER_PIN = 3;

// pen force control
int safetyCheck = 1200;  // change along with different pen length/setup
int dynamicDownPos = DEFAULT_UP_POSITION; // used in penforce function
int ResHig = 1000; // high bound 150 Kohms with cheap FSR   600 with finer FSR
int ResLow = 100; // low bound 10 Kohms with cheap FSR   60 with finer FSR
const int power = 4;
const int FSR = 2;  // 0 is not reliable!!!!!

// platform rotate
Servo platRot;
boolean lastFound = false;
const int IR = 1;
byte const PLAT_ROTATE = 9;
const int Clockwise = 73;
const int stop = 90;
const int switchTimeout = 7000;
const int interval = 30;
const int weight = 0.3; // to guarantee fast response, not too large
int lastPer = 1000;
int threshold1High = 500; int threshold1Low = 0;  //tool1 with foil surface
int threshold2High = 500; int threshold2Low = 0;  //tool1 with foil surface
int threshold3High = 500; int threshold3Low = 0;  //tool1 with foil surface
//int threshold1High = 70; int threshold1Low = 0;  //tool1 with foil surface
//int threshold2High = 590; int threshold2Low = 560; //tool2 with white surface
//int threshold3High = 750; int threshold3Low = 720; //tool3 with black surface


// default values for wrong setup situation
static int defaultMachineWidth = 650;
static int defaultMachineHeight = 650;
static float defaultMmPerRev = 32;
static int defaultStepsPerRev = 200;
static int defaultSpeedMatch = false;
static int defaultusingAcceleration = true;
static float defaultMaxSpeed = 1000; // for Accel library one time setup
static float defaultMaxAcceleration = 800; // for Accel Library one time setup

// values used in RUNTIME
int machineWidth = defaultMachineWidth;
int machineHeight = defaultMachineHeight;
float mmPerRev = defaultMmPerRev; // 16*2=32 mm which is the default on Processing!
int motorStepsPerRev = defaultStepsPerRev; 
boolean speedMatch = defaultSpeedMatch;
boolean usingAcceleration = defaultusingAcceleration;
float currentMaxSpeed = defaultMaxSpeed;
float currentAcceleration = defaultMaxAcceleration;

int startLengthMM = 800;
float mmPerStep = mmPerRev / motorStepsPerRev; // perimeter divided by steps
float stepsPerMM = motorStepsPerRev / mmPerRev; // converter from mm to steps!!!!
long pageWidth = machineWidth * stepsPerMM;  //convert machine spec from mm to steps !!!
long pageHeight = machineHeight * stepsPerMM;
long maxLength = 0;
long StartPosA = 0;  // whenever run C09:SET HOME, HOME postion will be recorded here
long StartPosB = 0;

// command needed variable
const int INLENGTH = 50; // max length of a cmd
const char INTERMINATOR = 10; //cmd sequence inside terminator
const char SEMICOLON = ';';
static char inCmd[10]; // store cmd kind like "CXX" actually not used
static char inParam1[14]; // parse different parameters out of a string command
static char inParam2[14];
static char inParam3[14];
static char inParam4[14];
byte inNoOfParams; // number of parameters, at most 4
char lastCommand[INLENGTH+1]; // char[] storing cmd from Serial.read()
boolean commandConfirmed = false;

int rebroadcastReadyInterval = 5000;
long lastOperationTime = 0L;
long motorIdleTimeBeforePowerDown = 600000L;
boolean automaticPowerDown = false;  // no power down!!!
boolean powerIsOn = false;
boolean reportingPosition = true;
boolean currentlyRunning = true;
extern AccelStepper motorA; // refer to an extern variable defined in configuration
extern AccelStepper motorB;

long lastInteractionTime = 0L;
    

#define READY_STR "READY"
#define RESEND_STR "RESEND"
#define DRAWING_STR "DRAWING"
#define OUT_CMD_SYNC_STR "SYNC,"
char MSG_E_STR[] = "MSG,E,";
char MSG_I_STR[] = "MSG,I,";
char MSG_D_STR[] = "MSG,D,";

/*------- Processing communicates with arduino using these pre-set Commands --------*/
const static char COMMA[] = ",";
const static char CMD_END[] = ",END";
const static String CMD_CHANGELENGTH = "C01";
const static String CMD_CHANGESPEEDMODE = "C03"; // speed match or not use acceleration or not use Microstepping or not
const static String CMD_CHANGEMOTORMODE = "C04";
const static String CMD_SETPOSITION = "C09"; 

  /*--- Drawing task is mainly decomposed to C13/14/17 commands!! ----*/
  const static String CMD_PLAROTATE = "C11"; // platform rotate, fixing chosen pen at drawing slot
  const static String CMD_SWITCHPEN = "C12"; // switch to other pen control logic
  const static String CMD_PENDOWN = "C13";
  const static String CMD_PENUP = "C14";
  const static String CMD_SETPENLIFTRANGE = "C45"; // contains both Pen down&up position
  const static String CMD_CHANGELENGTHDIRECT = "C17";
  /*--- Drawing task is mainly decomposed to C13/14/17 commands!! ----*/

const static String CMD_SETMACHINESIZE = "C24"; 
const static String CMD_GETMACHINEDETAILS = "C26";
const static String CMD_RESETEEPROM = "C27";
const static String CMD_SETMACHINEMMPERREV = "C29";
const static String CMD_SETMACHINESTEPSPERREV = "C30";
const static String CMD_SETMOTORSPEED = "C31";
const static String CMD_SETMOTORACCEL = "C32";
/*------- Processing communicates with arduino using these pre-set Commands --------*/


void setup() 
{
  Serial.begin(57600);
  Serial.println("DUCO is ready");
  Serial.print("Hardware: ");
  Serial.println(MICROCONTROLLER);
  #if MICROCONTROLLER == MC_UNO
  Serial.println("MC_UNO");
  #else
  Serial.println("No MC");
  #endif
 
  eeprom_resetEeprom(); // reset EEPROM to be ready
  configuration_setup(); // default values setting not quite important
  // don't know why these settings are needed
  // but without them, stepper's speed is not controllable
  // i.e. setSpeed doesn't work
  motorA.setMaxSpeed(defaultMaxSpeed);
  motorB.setMaxSpeed(defaultMaxSpeed);
  motorA.setAcceleration(defaultMaxAcceleration);  
  motorB.setAcceleration(defaultMaxAcceleration);
  
  float startLength = ((float) startLengthMM / (float) mmPerRev) * (float) motorStepsPerRev; // mm to steps
  motorA.setCurrentPosition(startLength);
  motorB.setCurrentPosition(startLength);
  // INLENGTH max length of a command, set to null str
  for (int i = 0; i<INLENGTH; i++) {
    lastCommand[i] = 0;
  }

  comms_ready();

  
  // default pen up! && close laser cutter if used
  penlift_initial(1750); 
  penlift_laserCutterOff();
  delay(500);
}

void loop()
{
  if (comms_waitForNextCommand(lastCommand)) 
  {
    comms_parseAndExecuteCommand(lastCommand);
    // after this lastCommand has been reset
  }
}
