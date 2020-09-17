/**
* DUCO - GUI
* here are all supporting functions for Processing from parsing a SVG design file, 
* communication with Arduino... to interface design
* "canvas/nativeCanvas" are in charge of how drawing canvas acts
* "controls" includes all control event handler
* "controlsSetup" generates groups of controllers
* "drawing" takes care of all drawing/platform moving related function
* "pageSetup" sets up all panels with respective controllers
* "util" gives access to config saving/loading function, scaling class ... and pop-out window class
*/
import diewald_CV_kit.libraryinfo.*;
import diewald_CV_kit.utility.*;
import diewald_CV_kit.blobdetection.*;

import geomerative.*;
import java.util.zip.CRC32;


// for OSX
import java.text.*;
import java.util.*;
import java.io.*;

import java.util.logging.*;
import javax.swing.*;
import processing.serial.*;
import controlP5.*;

ControlP5 cp5;
color background_color = #F0F0F0;
color menu_color = #C6CACC;
color capation = #9F9F9F;

//draw&test
Button drawTab;
Button testTab;
Button drawClickTab;
Button testClickTab;
Button advancedSettings;
Button save;
Button savePanel;
Button savePanel_save;
Button savePanel_saveAs;
Button savePanel_load;



//Welcome Page
Textlabel welcomeProjectTitle;
Textlabel welcomeSubType;
Textlabel welcomeMachineArea;
Textlabel welcomeCanvasSize;
Textlabel welcomeSerialPort;
Textlabel welcomeMachineW;
Textlabel welcomeMachineH;
Textlabel welcomeCanvasW;
Textlabel welcomeCanvasH;
Textlabel welcomePenPosition;
Textlabel welcomeP1;
Textlabel welcomeP2;
Textlabel welcomeP3;



Textfield welcomeMachineW_t;
Textfield welcomeMachineH_t;
Textfield welcomeCanvasW_t;
Textfield welcomeCanvasH_t;
DropdownList welcomeSubSelect;
DropdownList welcomeSerialSelect;
DropdownList welcomeP1Select;
DropdownList welcomeP2Select;
DropdownList welcomeP3Select;
Button welcomeCreate;
Button welcomeOpenFile;
Button welcomePosInfo;
Button welcomePosInfoPic;
List<Controller> welcomeControls = new ArrayList<Controller>();

//Draw Page
Textlabel drawMachineArea;
Textlabel drawMachineAreaW;
Textlabel drawMachineAreaH;
Textfield drawMachineAreaW_t;
Textfield drawMachineAreaH_t;
Textlabel drawCanvas;
Textlabel drawCanvasW;
Textlabel drawCanvasH;
Textfield drawCanvasW_t;
Textfield drawCanvasH_t;
Textlabel drawHomePoint;
Textlabel drawHomePointH;
Textfield drawHomePointH_t;
Textlabel drawVector;
Textlabel drawVectorW;
Textlabel drawVectorH;
Textlabel drawVectorX;
Textlabel drawVectorY;
Textfield drawVectorW_t;
Textfield drawVectorH_t;
Textfield drawVectorX_t;
Textfield drawVectorY_t;
Textlabel drawVectorRatio;
Textfield drawVectorRatio_t;
Textlabel drawDraw;
Button drawUpload;
Button drawClear;
Button drawStart;
Button drawGood;

//new draw added
Button drawBasicUpload;
//Button drawTest;
Button drawChangeFile;
Button drawSwitch;
Textlabel drawBasic;
Textlabel drawCurPos;
DropdownList drawCurPosSelect;

List<Controller> drawControls = new ArrayList<Controller>();


Textlabel drawPenPos;
Textlabel drawPenPosD;
Textfield drawPenPosD_t;
Button drawPenPosTest;
List<Controller> vectorControls = new ArrayList<Controller>();
List<Controller> drawTestControls = new ArrayList<Controller>();

//Test Page
List<Controller> testControls = new ArrayList<Controller>();



Textlabel testPos;
Textlabel testPosCap;
Textlabel testPosX;
Textlabel testPosY;
Textfield testPenPosX_t;
Textfield testPenPosY_t;
Button testPosTest;
Textlabel testVal;
Textlabel testValCap;
Textfield testVal_t;
Button testValTest;
Button testGood;


// DropdownList testPosSelect;
int page = 0;
PFont projectTitle;
PFont title;
PFont subTitle;
PFont listTitle;
PFont f14;
PFont f12;
PFont wh;
Boolean commandQueueRunning = false;
boolean tested = false;
boolean infoVis = false;
boolean savePanelVis = false;


List<Controller> allControls = null;
//old 
String newMachineName = "PGXXABCD";
float machineScaling = 1.0;
DisplayMachine displayMachine = null;

// preset sizes - these can be referred to in the properties file
final String PRESET_A3_SHORT = "A3SHORT";
final String PRESET_A3_LONG = "A3LONG";
final String PRESET_A2_SHORT = "A2SHORT";
final String PRESET_A2_LONG = "A2LONG";
final String PRESET_A2_IMP_SHORT = "A2+SHORT";
final String PRESET_A2_IMP_LONG = "A2+LONG";
final String PRESET_A1_SHORT = "A1SHORT";
final String PRESET_A1_LONG = "A1LONG";

final int A3_SHORT = 297;
final int A3_LONG = 420;
final int A2_SHORT = 418;
final int A2_LONG = 594;
final int A2_IMP_SHORT = 450;
final int A2_IMP_LONG = 640;
final int A1_SHORT = 594;
final int A1_LONG = 841;

public color pageColour = color(220);
public color frameColour = color(200, 0, 0);
public color machineColour = color(150);
public color guideColour = color(255);
public color backgroundColour = color(100);
public color densityPreviewColour = color(0);
public color chromaKeyColour = color(0, 255, 0);
public static Integer serialPortNumber = -1;
int baudRate = 57600;
Serial myPort;                       // The serial port
public String portSelected;
int[] serialInArray = new int[1];    // Where we'll put what we receive
int serialCount = 0;                 // A count of how many bytes we receive
String storeFilename = "comm.txt";
boolean overwriteExistingStoreFile = true;


List<String> commandQueue = new ArrayList<String>();
List<String> realtimeCommandQueue = new ArrayList<String>();
List<String> commandHistory = new ArrayList<String>();
List<String> machineMessageLog = new ArrayList<String>();

List<PreviewVector> previewCommandList = new ArrayList<PreviewVector>();
long lastCommandQueueHash = 0L;

String lastCommand = "";
String lastDrawingCommand = "";
int machineAvailMem = 0;
int machineUsedMem = 0;
int machineMinAvailMem = 2048;
int maxSegmentLength = 2;

boolean drawbotReady = false;
boolean drawbotConnected = false;
//public Map<String, Controller> allControls = null;

/* =============================== more useful configurations  ========================= */
int curPenMode = 0; // default as linear actuator
//int pen1Mode = 0;
//int pen2Mode = 0;
//int pen3Mode = 0;

// default as linear actuator
int controlValue;
final int defaultPenUp = 1750; // depends on specific design

final int defaultResUp = 100;
final int defaultResDown = 0;

NumberFormat nf = NumberFormat.getNumberInstance(Locale.UK);
DecimalFormat df = (DecimalFormat)nf;  
boolean usingAcceleration = false;
boolean usingSpeedMatch = false;
boolean usingMicrostep = false;
float currentMachineMaxSpeed = 600.0;
float currentMachineAccel = -1; // default as not used
float inAirMaxSpeed = 400.0;
float inAirAccel = 100.0;
int speedModeSelector;

boolean displayingVector = true;
boolean useSerialPortConnection = false;
boolean displayingGuides = true;

Properties props = null;
public static String propertiesFilename = "default.properties.txt";
public static String newPropertiesFilename = null;

//float mmPerPixel = 0.264583333;
float mmPerPixel = 0.3527777; // in Adobe Illustrator
// all PVector in different coordinates
PVector homePointCartesian = null;  //as MM in Cartesian
PVector mousePos = new PVector(); // as MM in Cartesian, used in test page
PVector currentMachinePos = new PVector();  // pink point position stored as MM in Cartesian
PVector vectorPosition = new PVector(0.0, 0.0);  // as MM in Cartesian
// pictureFrame is also as MM in Cartesian
PVector machinePosition = new PVector(288.0, 60.0); // displaying position in pixels
PVector statusTextPosition = new PVector(300.0, 12.0); // in pixel displaying on screen
public final float MIN_SCALING = 0.02;
public final float MAX_SCALING = 15.0;

// displaying vector and its guidePoint
RShape vectorShape = null;
String vectorFilename = null;
float vectorScaling = 100;
int minimumVectorLineLength = 0;  
public static final int VECTOR_FILTER_LOW_PASS = 0;
static int pathLengthHighPassCutoff = 0;

// displaying queue related constants
int leftEdgeOfQueue = 800;
int rightEdgeOfQueue = 1100;
int topEdgeOfQueue = 0;
int bottomEdgeOfQueue = 0;
int queueRowHeight = 15;
/* =============================== more useful configurations ========================= */

void settings(){
    size(1440,900);
    
}

void setup(){
    cp5 = new ControlP5(this);
    projectTitle = createFont("Helvetica",36);
    title = createFont("Roboto",18);
    subTitle = createFont("Roboto",15);
    listTitle = createFont("Roboto",16);
    wh = createFont("Roboto",14);
    f14 = createFont("Roboto",14);
    f12 = createFont("Roboto",12);
    //cp5.setControlFont(new ControlFont(createFont("Arial", 20), 20));
    surface.setResizable(true);
    background(background_color);
    setupWelcomePage();
    welcomeControlsSetup();
    welcomePosInfoPic.hide();
    setupDrawPage();
    setupTestPage();
    drawControlsSetup();
    drawTestControlsSetup();
    vectorControlsSetup();
    testControlsSetup();
    hideAllDraw();
    hideAllTest();
    textFont(wh);

    RG.init(this);
    RG.setPolygonizer(RG.ADAPTATIVE);

    try 
    { 
      UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
    } 
    catch (Exception e) 
    { 
      e.printStackTrace();
    }
    loadFromPropertiesFile();   
    
}



void drawDrawPage(){
  strokeWeight(0);
  stroke(#ffffff,255);
  fill(#ffffff,255);
  rect(0, 0, 281, 900);
  rect(0,0,1440,56);
  stroke(#367BF5,44);
  fill(#367BF5,44);
  rect(0,55,281,35);
  rect(0,391,281,35);
  //draw basic canvas
  getDisplayMachine().draw();
  //draw command queue
  //showCommandQueue((int) getDisplayMachine().getOutline().getRight()+6, 60);
  //show current machine position
  showCurrentMachinePosition();
}

void drawTestPage(){
  stroke(#ffffff);
  fill(#ffffff);
  rect(0, 0, 281, 900);
  rect(0,0,1440,56);
  stroke(#367BF5,44);
  fill(#367BF5,44);
  rect(0,55,281,45);
  rect(0,300,281,45);

  //draw basic canvas
  getDisplayMachine().draw();
  //draw command queue
  //showCommandQueue((int) getDisplayMachine().getOutline().getRight()+6, 60);
  //show current machine position
  showCurrentMachinePosition();
}

void hideAllWelcome(){
    for (Controller controller : welcomeControls){
    controller.hide();
  }
}
void showAllWelcome(){
      for (Controller controller : welcomeControls){
    controller.show();
  }
}

void hideAllDraw_Vector(){
    for (Controller controller : vectorControls){
    controller.hide();
  }
}
void showAllDraw_Vector(){
      for (Controller controller : vectorControls){
    controller.show();
  }
}

void hideAllDraw_Test(){
    for (Controller controller : drawTestControls){
    controller.hide();
  }
}
void showAllDraw_Test(){
      for (Controller controller : drawTestControls){
    controller.show();
  }
}

void hideAllDraw(){
    for (Controller controller : drawControls){
      controller.hide();
  }
}
void showAllDraw(){
    for (Controller controller : drawControls){
      controller.show();
  }
}

void hideAllTest(){
    for (Controller controller : testControls){
      controller.hide();
  }
}
void showAllTest(){
    for (Controller controller : testControls){
      controller.show();
  }
}

void showInfo(){
  welcomePosInfoPic.show();
  infoVis = true;
}

void hideInfo(){
  welcomePosInfoPic.hide();
  infoVis = false;

}


void showSavePanel(){
    savePanel.show();
    savePanel_save.show();
    savePanel_saveAs.show();
    savePanel_load.show();
    // avoid false trigger!
    drawMachineAreaW_t.setLock(true);
    drawCanvasW_t.setLock(true);
    savePanelVis = true;
}

void hideSavePanel(){
    savePanel.hide();
    savePanel_save.hide();
    savePanel_saveAs.hide();
    savePanel_load.hide();
    // reopen these two textfields
    drawMachineAreaW_t.setLock(false);
    drawCanvasW_t.setLock(false);
    savePanelVis = false;
}

void welcome2Draw(){
  hideAllWelcome();
  showAllDraw();
  hideAllDraw_Vector();
  testClickTab.hide();
  hideSavePanel();
}

void draw2Test(){
  hideAllDraw();
  showAllTest();
  drawClickTab.hide();
  testTab.hide();
  testClickTab.show();
}
void test2Draw(){
  hideAllTest();
  showAllDraw();
  testClickTab.hide();
  if(!tested)
    hideAllDraw_Vector();
  else{
    hideAllDraw_Test();
  }
  hideSavePanel();
}


void draw() {
  background(background_color);
  if(page==1){
    drawDrawPage();
  }
  else if(page==2){
    drawTestPage();
  }
  if (drawbotReady)
  {
    dispatchCommandQueue();
  }
}

public DisplayMachine getDisplayMachine()
{
  if (displayMachine == null)
    displayMachine = new DisplayMachine(new Machine(5000, 5000, 800.0, 95.0), machinePosition, machineScaling);

  displayMachine.setOffset(machinePosition);
  displayMachine.setScale(machineScaling);
  return displayMachine;
}

color getPageColour()
{
  return this.pageColour;
}
color getMachineColour()
{
  return this.machineColour;
}
color getBackgroundColour()
{
  return this.backgroundColour;
}
color getGuideColour()
{
  return this.guideColour;
}
color getFrameColour()
{
  return this.frameColour;
}

public PVector getHomePoint()
{
  return this.homePointCartesian;
}

Integer getSerialPortNumber()
{
  return this.serialPortNumber;
}
String getStoreFilename()
{
  return this.storeFilename;
}
void setStoreFilename(String filename)
{
  this.storeFilename = filename;
}

boolean getOverwriteExistingStoreFile()
{
  return this.overwriteExistingStoreFile;
}
void setOverwriteExistingStoreFile(boolean over)
{
  this.overwriteExistingStoreFile = over;
}

PVector getVectorPosition()
{
  return vectorPosition;
}

Integer getBaudRate()
{
  return baudRate;
}

RShape getVectorShape()
{
  return this.vectorShape;
}
void setVectorShape(RShape shape)
{
  this.vectorShape = shape;
}

String getVectorFilename()
{
  return this.vectorFilename;
}
void setVectorFilename(String filename)
{
  this.vectorFilename = filename;
}
void addToCommandQueue(String command)
{
  synchronized (commandQueue)
  {
    commandQueue.add(command);
  }
}
synchronized void addToRealtimeCommandQueue(String command)
{
  synchronized (realtimeCommandQueue)
  {
    realtimeCommandQueue.add(command);
  }
}

boolean isDrawbotReady()
{
  return drawbotReady;
}
boolean isDrawbotConnected()
{
  return drawbotConnected;
}
Set<Controller> mouseOverControls()
{
  Set<Controller> set = new HashSet<Controller>(1);
  for (Controller c : getAllControls())
  {
    if (c.isInside())
    {
      set.add(c);
    }
  }
  return set;
}

// check whether click on canvas
boolean mouseOverMachine()
{
  boolean result = false;
  if (getDisplayMachine().getOutline().surrounds(getMouseVector())
    && mouseOverControls().isEmpty())
  {
     result = true;
  }
  else
    result = false;
  return result;
}

// set vector position through dragging in draw page
void mouseDragged()
{
   if (mouseOverMachine() && page==1)
    { 
      // offset mouse vector so it grabs the leftTop of the shape
      PVector leftTop = new PVector(0, 0);
      PVector offsetMouseVector = PVector.sub(getDisplayMachine().scaleToDisplayMachine(getMouseVector()), leftTop);
      vectorPosition = offsetMouseVector;
      displayMachine.refreshGuide = true;
    }
}
void mouseReleased(){
   if (mouseOverMachine() && page==1)
    { 
      //refresh drawVectorX_t and drawVectorY_t
       df.applyPattern("###.##");
       drawVectorX_t.setText(df.format(vectorPosition.x));
       drawVectorY_t.setText(df.format(vectorPosition.y));
    }
}

// display guide point through clicking in draw page
// pick up mouse vector from test page
void mouseClicked(){
  if(page==0&&mouseOverControls().isEmpty())
    {
      println("hide");
      welcomePosInfoPic.hide();
      infoVis = false;
    }
  if (mouseOverMachine() && page==1)
  { 
      // once click on machine
      // toggle guidepoint state
      displayMachine.setGuidePoint(!displayMachine.getGuidePoint());
  }
  if (mouseOverMachine() && page==2){

    df.applyPattern("###.##");
    mousePos = getDisplayMachine().scaleToDisplayMachine(getMouseVector());
    // refresh two textfields in test page
    testPenPosX_t.setText(df.format(mousePos.x));
    testPenPosY_t.setText(df.format(mousePos.y));
  }
}


// zoom in and out
void mouseWheel(MouseEvent event) 
{
  int delta = (int)event.getCount();
  changeMachineScaling(delta);
} 
void changeMachineScaling(int delta)
{
  boolean scalingChanged = true;
  machineScaling += (delta * 0.02);
  if (machineScaling <  MIN_SCALING)
  {
    machineScaling = MIN_SCALING;
    scalingChanged = false;
  }
  else if (machineScaling > MAX_SCALING)
  {
    machineScaling = MAX_SCALING;
    scalingChanged = false;
  }
}

// printout command waiting for or being dispatching 
void setCommandQueueFont()
{
  textSize(12);
  fill(0);
}  
void showCommandQueue(int xPos, int yPos)
{
  setCommandQueueFont();
  int tRow = 15;
  int textPositionX = xPos;
  int textPositionY = yPos;
  int tRowNo = 1;

  int commandQueuePos = textPositionY+(tRow*tRowNo++);

  topEdgeOfQueue = commandQueuePos-queueRowHeight;
  leftEdgeOfQueue = textPositionX;
  rightEdgeOfQueue = textPositionX+300;
  bottomEdgeOfQueue = height;

  drawCommandQueueStatus(textPositionX, commandQueuePos, 14);
  commandQueuePos+=queueRowHeight;
  text("Last command: " + ((commandHistory.isEmpty()) ? "-" : commandHistory.get(commandHistory.size()-1)), textPositionX, commandQueuePos);
  commandQueuePos+=queueRowHeight;
  text("Current command: " + lastCommand, textPositionX, commandQueuePos);
  commandQueuePos+=queueRowHeight;

  fill(128, 255, 255);
  int queueNumber = commandQueue.size()+realtimeCommandQueue.size();
  for (String s : realtimeCommandQueue)
  {
    text((queueNumber--)+". "+ s, textPositionX, commandQueuePos);
    commandQueuePos+=queueRowHeight;
  }

  fill(0); // in black
  try
  {
    // Write out the commands into the window, stop when you fall off the bottom of the window
    // Or run out of commands
    int commandNo = 0;
    while (commandQueuePos <= height && commandNo < commandQueue.size ())
    {
      String s = commandQueue.get(commandNo);
      text((queueNumber--)+". "+ s, textPositionX, commandQueuePos);
      commandQueuePos+=queueRowHeight;
      commandNo++;
    }
  }
  catch (ConcurrentModificationException cme)
  {
    println("Caught the pesky ConcurrentModificationException: " + cme.getMessage());
  }
}

void drawCommandQueueStatus(int x, int y, int tSize)
{
  String queueStatus = null;
  textSize(tSize);
  if (commandQueueRunning)
  {
    queueStatus = "QUEUE RUNNING";
    fill(0, 200, 0);
  }
  else
  {
    queueStatus = "QUEUE PAUSED";
    fill(255, 0, 0);
  }

  text("CommandQueue: " + queueStatus, x, y);
  setCommandQueueFont();
}


// Serial Event control, dealing with communication between Uno and Processing
void serialEvent(Serial myPort) 
{ 
  // read the serial buffer:
  String incoming = myPort.readStringUntil('\n'); //string teminates when confronting terminator char '\n'
  myPort.clear(); // clear all buffer stored
  // if you got any bytes other than the linefeed:
  incoming = trim(incoming);
  println("incoming: " + incoming);  // at least printout all incoming msg

  if (incoming.startsWith("READY"))
  {
    drawbotReady = true;
  }
  else if ("RESEND".equals(incoming))
    resendLastCommand();
  else if ("DRAWING".equals(incoming))
    drawbotReady = false;
  else if (incoming.startsWith("SYNC"))
    readMachinePosition(incoming);

  if (drawbotReady)
    drawbotConnected = true;
}

// Redispatching or dispatching command queue
void resendLastCommand()
{
  println("Re-sending command: " + lastCommand);
  myPort.write(lastCommand);
  myPort.write(10); // terminate the command
  drawbotReady = false;
}
void dispatchCommandQueue()
{
  // only when arduino send back ACK "ready", will dispatch continue!
  // new command will be sent to port but old command may still be in traffic for sometime
  if (isDrawbotReady() 
    && (!commandQueue.isEmpty() || !realtimeCommandQueue.isEmpty())
    && commandQueueRunning)
  {

    if (!realtimeCommandQueue.isEmpty())
    {
      String command = realtimeCommandQueue.get(0);
      lastCommand = command;
      realtimeCommandQueue.remove(0);
      println("Dispatching PRIORITY command: " + command);
    }
    else
    {
      String command = commandQueue.get(0);
      lastCommand = command;
      commandQueue.remove(0);
      println("Dispatching command: " + command);
    }
    println("Last command:" + lastCommand);
    myPort.write(lastCommand);
    myPort.write(10); // OH *$%! of COURSE you should terminate it. 10 is linefeed
    drawbotReady = false;
  }
}

// read command with "SYNC" from arduino!!!
// refresh machine position then show it 
void readMachinePosition(String sync)
{
  String[] splitted = split(sync, ",");
  if (splitted.length == 4)
  {
    String currentAPos = splitted[1];
    String currentBPos = splitted[2];
    Float a = Float.valueOf(currentAPos).floatValue();
    Float b = Float.valueOf(currentBPos).floatValue();
    currentMachinePos.x = a;
    currentMachinePos.y = b;  
    currentMachinePos = getDisplayMachine().asCartesianCoords(getDisplayMachine().inMM(currentMachinePos));  // as MM in Cartesian
  }
}
void showCurrentMachinePosition()
{
  noStroke();
  fill(255, 0, 255, 150);
  PVector pgCoord = getDisplayMachine().scaleToScreen(currentMachinePos);
  ellipse(pgCoord.x, pgCoord.y, 20, 20);
  noFill();
}
