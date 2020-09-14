void controlEvent(ControlEvent theEvent) {
  if (theEvent.isGroup()) {
    // check if the Event was triggered from a ControlGroup
    println("event from group : "+theEvent.getGroup().getValue()+" from "+theEvent.getGroup());
  } 
  else if (theEvent.isController()) {
    println("event from controller : "+theEvent.getController().getValue()+" from "+theEvent.getController());
  }
  else if(theEvent.isAssignableFrom(Textfield.class)) {
    println("controlEvent: accessing a string from controller '"
            +theEvent.getName()+"': "
            +theEvent.getStringValue()
            );
  }
}
void centerCanvas(){
  float pageWidth = getDisplayMachine().getPage().getWidth();
  float machineWidth = getDisplayMachine().getSize().x;
  float diff = (machineWidth - pageWidth) / 2.0;
  getDisplayMachine().getPage().getTopLeft().x = (int) diff;
}
void centerHomepoint(){
  float halfWay = getDisplayMachine().getSize().x / 2.0;
  getHomePoint().x = (int) halfWay;
}
void setFrame(){
  PVector pos1 = getDisplayMachine().getPage().getTopLeft(); // steps
  PVector size = getDisplayMachine().getPage().getSize();
  Rectangle r = new Rectangle(pos1, size);
  getDisplayMachine().setPictureFrame(r);
}
// relocation on canvas & resize related functions trigger this
void refreshVectorSpecs(float w, float h, float ratio){
  df.applyPattern("###.##");
  drawVectorW_t.setText(df.format(w));
  drawVectorH_t.setText(df.format(h));
  drawVectorRatio_t.setText(df.format(ratio));
}


/*------------------------------------  in Welcome page ------------------------*/
// control event handlers for textfield
public void welcomeMachineW_t(String s){
  try{
    int value = parseInt(s);
    getDisplayMachine().getSize().x = value;
    // set pageX offset and homepointX offset
    centerCanvas();
    centerHomepoint();
    // set value for MachineW_t in draw page
    drawMachineAreaW_t.setText(s);
  }catch(NumberFormatException e){
    println("format wrong!");
  }
}

public void welcomeMachineH_t(String s){
  try{
    int value = parseInt(s);
    getDisplayMachine().getSize().y = value;
    // set value for MachineH_t in draw page
    drawMachineAreaH_t.setText(s);
  }catch(NumberFormatException e){
    println("format wrong!");
  }
}

public void welcomeCanvasW_t(String s){
  try{
    int value = parseInt(s);
    getDisplayMachine().getPage().setWidth(value); 
    // set pageX offset
    centerCanvas();
    // set picture frame
    setFrame();
    // set value for CanvasW_t in draw page
    drawCanvasW_t.setText(s);
  }catch(NumberFormatException e){
    println("format wrong!");
  }
}

public void welcomeCanvasH_t(String s){
  try{
    int value = parseInt(s);
    getDisplayMachine().getPage().setHeight(value);
    
    // default a hompointY/pageY offest as 20mm
    getHomePoint().y = 20;
    getDisplayMachine().getPage().getTopLeft().y = 20;
    // set picture frame
    setFrame();
    // set value for CanvasH_t in draw page
    // set value for homepointY in draw page
    drawCanvasH_t.setText(s);
    drawHomePointH_t.setText("20");
  }catch(NumberFormatException e){
    println("format wrong!");
  }
}

//control event handlers for buttons
public void welcomeCreate(){
  welcome2Draw();
  page = 1;
  // for parameters sending
  commandQueueRunning = true;
}

public void welcomeOpenFile(){
  loadNewPropertiesFilenameWithFileChooser();
}


//control event handlers for dropdown lists

// for Serial port
CallbackListener serialCB = new CallbackListener() {
    public void controlEvent(CallbackEvent theEvent) {
      if(theEvent.getAction() == ControlP5.ACTION_ENTER){
        welcomeSerialSelect.clear();
        // here refresh available serial list
        String[] s = Serial.list();
        String[] ports = new String[s.length+1];
        for(int i=s.length;i>0;i--){
          ports[i]=s[i-1];
        }
        ports[0]="no Serial selected";
        for(int i=0;i<ports.length;i++){
          welcomeSerialSelect.addItem(ports[i],i);
        }
      }
    }
};
public void welcomeSerialSelect(int n){
  if(n==0){
      println("Disconnecting serial port.");
      useSerialPortConnection = false;
      if (myPort != null)
      {
         myPort.stop();
         myPort = null;
      }
      drawbotReady = false;
      drawbotConnected = false;
   }
   else{
     portSelected = Serial.list()[n-1];
     try{
       if (myPort != null)
       {
          myPort.stop();
          myPort = null;
       }
       myPort = getNewSerial(portSelected);
       //read bytes into a buffer until you get a linefeed (ASCII 10):
       myPort.bufferUntil('\n');
       useSerialPortConnection = true;
       println("Successfully connected to port " + portSelected);
     }catch(Exception e){
        println("Attempting to connect to serial port in slot " + portSelected 
        + " caused an exception: " + e.getMessage());
     }
  }
}
Serial getNewSerial(String name){
  return new Serial(this,name,getBaudRate());
}
// for pen position
//public void welcomeP1Select(int n){
//  pen1Mode = n;
//}
//public void welcomeP2Select(int n){
//  pen2Mode = n;
//}
//public void welcomeP3Select(int n){
//  pen3Mode = n;
//}

// for subtrate type
public void welcomeSubSelect(int n){
}


public void welcomePosInfo(){
  println("here");
  if(!infoVis)
    showInfo();
  else
    hideInfo();
}
/*------------------------------------  in Welcome page ------------------------*/

/*------------------------------------  in draw page ---------------------------*/
// textfields
public void drawMachineAreaW_t(String s){
  try{
    int value = parseInt(s);
    getDisplayMachine().getSize().x = value;
    // set pageX offset and homepointX offset
    centerCanvas();
    centerHomepoint();
  }catch(NumberFormatException e){
    println("format wrong!");
  }
}
public void drawMachineAreaH_t(String s){
  try{
    int value = parseInt(s);
    getDisplayMachine().getSize().y = value;
  }catch(NumberFormatException e){
    println("format wrong!");
  }
}
public void drawCanvasW_t(String s){
  try{
    int value = parseInt(s);
    getDisplayMachine().getPage().setWidth(value);
    // set pageX offset
    centerCanvas();
    // set picture frame
    setFrame();
  }catch(NumberFormatException e){
    println("format wrong!");
  }
}
public void drawCanvasH_t(String s){
  try{
    int value = parseInt(s);
    getDisplayMachine().getPage().setHeight(value);
    // set picture frame
    setFrame();
  }catch(NumberFormatException e){
    println("format wrong!");
  }
}
public void drawHomePointH_t(String s){
  try{
    int value = parseInt(s);
    // set pageY and homepointY offset
    getHomePoint().y = value;
    getDisplayMachine().getPage().getTopLeft().y = value;
    // set picture frame
    setFrame();
  }catch(NumberFormatException e){
    println("format wrong!");
  }
}
public void drawVectorX_t(String s){
  try{
    float value = Float.parseFloat(s);
    vectorPosition.x = value;
  }catch(NumberFormatException e){
    println("format wrong!!");
  }
}
public void drawVectorY_t(String s){
  try{
    float value = Float.parseFloat(s);
    vectorPosition.y = value;
  }catch(NumberFormatException e){
    println("format wrong!!");
  }
}
public void drawVectorRatio_t(String s){
  try{
    float newRatio = Float.parseFloat(s);
    float newWidth = vectorShape.getWidth() * mmPerPixel * newRatio / 100;
    float newHeight = vectorShape.getHeight() * mmPerPixel * newRatio / 100;
    vectorScaling = newRatio;
    //refresh text
    refreshVectorSpecs(newWidth,newHeight,newRatio);
  }catch(NumberFormatException e){
    println("format wrong!!");
  }
}
public void drawVectorW_t(String s){
  float newWidth = Float.parseFloat(s); // in mm
  float Oriwidth = vectorShape.getWidth() * mmPerPixel; // in mm
  float newRatio = newWidth/Oriwidth; // 0.xx format
  float newHeight = newRatio * vectorShape.getHeight() * mmPerPixel;
  // refresh text
  refreshVectorSpecs(newWidth,newHeight,newRatio*100);
  // set new scaling
  vectorScaling = newRatio*100;
}
public void drawVectorH_t(String s){
  float newHeight = Float.parseFloat(s);
  float OriHeight = vectorShape.getHeight() * mmPerPixel;
  float newRatio = newHeight/OriHeight;
  float newWidth = newRatio * vectorShape.getWidth() * mmPerPixel;
  // refresh text
  refreshVectorSpecs(newWidth,newHeight,newRatio*100);
  // set new scaling
  vectorScaling = newRatio*100;
}

// buttons
public void drawChangeFile(){
  if (getVectorShape() == null)
  {
    loadVectorWithFileChooser(); // it's not a blocking command
  }
  else
  {
    vectorShape = null;
    vectorFilename = null;
    // refresh vector position
    // not recommended!!!! manually re-align is not reliable
    //vectorPosition.x =0;
    //vectorPosition.y =0;
    displayMachine.refreshGuide = false; // clicking clear vector Guide will remain same place
    loadVectorWithFileChooser();
  }
  // once uploading SVG, set to false
  commandQueueRunning = false;
  // reset start button
  drawStart.setImages(loadImage("draw_start.png"), loadImage("draw_start.png"), loadImage("draw_start.png"))
          .updateSize();
  
  // reset vector scaling ratio
  //vectorScaling = 100;
  //float Width = vectorShape.getWidth() * mmPerPixel;
  //float Height = vectorShape.getHeight() * mmPerPixel;
  ////refresh text
  //refreshVectorSpecs(Width,Height,100);
}
public void drawBasicUpload(){
  sendMachineSpec();
  // send motor specs too
  String command = CMD_CHANGEMACHINEMMPERREV+int(getDisplayMachine().getMMPerRev())+",END";
  addToCommandQueue(command);
  command = CMD_CHANGEMACHINESTEPSPERREV+int(getDisplayMachine().getStepsPerRev())+",END";
  addToCommandQueue(command);
  
  // then generate C04 motor mode code
  int motorSelector = usingMicrostep ? 1:0;
  addToCommandQueue(CMD_CHANGEMOTORMODE+ motorSelector +",END");
  df.applyPattern("###.##");
  if(!usingMicrostep){
     addToCommandQueue(CMD_CHANGESPEEDMODE+ speedModeSelector +",END");
     addToCommandQueue(CMD_SETMOTORSPEED+df.format(currentMachineMaxSpeed)+",1,END");
     if(usingAcceleration){
       addToCommandQueue(CMD_SETMOTORACCEL+df.format(currentMachineAccel)+",1,END");
     }
  }
  else{
     addToCommandQueue(CMD_CHANGESPEEDMODE+ 0 +",END");
     addToCommandQueue(CMD_SETMOTORSPEED+df.format(currentMachineMaxSpeed)+",1,END");
  }
  // also serve as a reset/set home function
  sendSetHomePosition();
}
public void drawUpload(){
  if(vectorShape != null){
    sendVectorShapes();
  }
}
public void drawClear(){
  commandQueue.clear();
  realtimeCommandQueue.clear();
  // speedUp
  if(!usingMicrostep)speedUp();
  // lift pen
  addToCommandQueue(CMD_PENUP + "END");
  // then return home
  sendMoveToNativePosition(false,null);
  if(!usingMicrostep)returnToSetSpeed();
}
public void drawStart(){
  if(!commandQueueRunning){
    drawStart.setImages(loadImage("pause.png"), loadImage("pause.png"), loadImage("pause.png"))
            .updateSize();
  }
  else{
    drawStart.setImages(loadImage("draw_start.png"), loadImage("draw_start.png"), loadImage("draw_start.png"))
            .updateSize();
  }
  commandQueueRunning = !commandQueueRunning;
}

// dialogue 
// motor setting part
// Details about the "setting" button triggered subwindows
// it contains all motor configurations
import java.awt.event.ItemEvent; 
import java.awt.event.ItemListener; 
public void advancedSettings(){
  basicSetting bs = new basicSetting();
}
class basicSetting extends JavaConsole{
  public int itv = 20;
  public int sizeX = 100;
  public int sizeY = 20;
  public String[] settingNames;
  public String[] modeNames;
  public final int NUM_MODES = 3;
  public final int NUM_SETTINGS = 6;
  public basicSetting(){
    super("basic setup!",400,500);
    initialize();
    addLogic();
    // layout!!
    int posX = 10;
    int posY = 10;
    // three toggles
    for(int i=0;i<NUM_MODES;i++){
      jtb[i].setBounds(posX,posY,sizeX, sizeY);
      posX+=(sizeX+itv);
      jframe.add(jtb[i]);
    }
    
    // six labeled textFields
    for(int i=0;i<NUM_SETTINGS;i++){
      posY+=(sizeY+itv);
      posX=10;
      Dimension size = jl[i].getPreferredSize();
      jl[i].setBounds(posX,posY,size.width,size.height);
      posX+=size.width;
      tf[i].setBounds(posX,posY,2*sizeX,sizeY);
      jframe.add(tf[i]);
      jframe.add(jl[i]);
    }
    
    // one dropdown list
    posX=10;
    posY+=(sizeY+itv);
    Dimension size = jcbl1.getPreferredSize();
    jcbl1.setBounds(posX,posY,size.width,size.height);
    posX+=size.width;
    jcb1.setBounds(posX,posY,3*sizeX,sizeY);
    jframe.add(jcbl1);
    jframe.add(jcb1);
    
    // two basic buttons
    posX=10;
    posY+=(sizeY+itv);
    for(int i=0;i<2;i++){
      jb[i].setBounds(posX,posY,sizeX, sizeY);
      posX+=(sizeX+itv);
      jframe.add(jb[i]);
    }
    jframe.setVisible(true);
  }
  public void initialize(){
    settingNames = new String[NUM_SETTINGS];  // 5 textfield
    modeNames = new String[NUM_MODES];  // 3 toggles
    settingNames[0]="Draw Max Speed";
    settingNames[1]="Draw Acceleration";
    settingNames[2]="Max Speed in Air";
    settingNames[3]="Acceleration in Air";
    settingNames[4]="Gear Perimeter";
    settingNames[5]="Steps per Rev";
    modeNames[0]="Use Acceleration";
    modeNames[1]="Use Speed Match";
    modeNames[2]="Use Microstep";
    // init toggles
    initToggles(modeNames);
    jtb[0].setSelected(usingAcceleration);
    jtb[1].setSelected(usingSpeedMatch);
    jtb[2].setSelected(usingMicrostep);
    // init textfield
    initTextFieldGroup(settingNames);
    df.applyPattern("###.##");
    tf[0].setText(df.format(currentMachineMaxSpeed));
    tf[4].setText(df.format(getDisplayMachine().getMMPerRev()));
    tf[5].setText(df.format(getDisplayMachine().getStepsPerRev()));
    if(usingMicrostep){
      tf[0].setText("900");
      tf[1].setText("-1");
      tf[2].setText("-1");
      tf[3].setText("-1");
      tf[5].setText("3200");
      for(int i = 0;i<4;i++){
       tf[i].setEditable(false);
      }
    }
    else{
      tf[0].setEditable(true);
      tf[0].setText(df.format(currentMachineMaxSpeed));
      tf[1].setEditable(usingAcceleration);
      if(usingAcceleration)
         tf[1].setText(df.format(currentMachineAccel));
      else
         tf[1].setText("-1");
      tf[2].setEditable(true);
      tf[2].setText(df.format(inAirMaxSpeed));
      tf[3].setEditable(true);
      tf[3].setText(df.format(inAirAccel));
      tf[5].setText(df.format(400));
    }
    // init two basic buttons
    initBasicButtons();
    
    // init dropDown list
    String[] s = Serial.list(); //<>//
    String[] ports = new String[s.length+1];
    for(int i=s.length;i>0;i--){
      ports[i]=s[i-1];
    }
    ports[0]="no Serial selected";
    initComboBox(ports);
    if(portSelected!=null && Arrays.asList(s).contains(portSelected)){
      jcb1.setSelectedItem(portSelected);
    }
  }
  public void addLogic(){
    // using Acceleration
    jtb[0].addItemListener(new ItemListener(){
      public void itemStateChanged(ItemEvent ie){
        int state = ie.getStateChange();
        if(!usingMicrostep){
          if (state == ItemEvent.SELECTED) { 
             usingAcceleration = true;
             // reset acceleration text
             df.applyPattern("###.##");
             tf[1].setText(df.format(currentMachineAccel)); 
           } 
           else { 
             usingAcceleration = false;
             tf[1].setText("-1");
           }   
           tf[1].setEditable(usingAcceleration);
         }
      }
    });
    // using SpeedMatch
    jtb[1].addItemListener(new ItemListener(){
      public void itemStateChanged(ItemEvent ie){
        int state = ie.getStateChange(); 
        // if selected print selected in console 
        if (state == ItemEvent.SELECTED) { 
           usingSpeedMatch = true;
         } 
         else { 
         // else print deselected in console 
           usingSpeedMatch = false;
        } 
      }
    });
    // using MicroStep
    jtb[2].addItemListener(new ItemListener(){
      public void itemStateChanged(ItemEvent ie){
        int state = ie.getStateChange();
        // reset moving setting
        df.applyPattern("###.##");
        if(state == ItemEvent.SELECTED){
          usingMicrostep = true;
          for(int i = 0;i<4;i++){
            tf[i].setEditable(false);
          }
          tf[0].setText("900");
          tf[1].setText("-1");
          tf[2].setText("-1");
          tf[3].setText("-1");
          tf[5].setText("3200");
        }
        else{
          usingMicrostep = false;
          tf[0].setEditable(true);
          tf[0].setText(df.format(currentMachineMaxSpeed));
          tf[1].setEditable(usingAcceleration);
          if(usingAcceleration)
            tf[1].setText(df.format(currentMachineAccel));
          else
            tf[1].setText("-1");
          tf[2].setEditable(true);
          tf[2].setText(df.format(inAirMaxSpeed));
          tf[3].setEditable(true);
          tf[3].setText(df.format(inAirAccel));
          tf[5].setText(df.format(400));
        }
      }
    });
    // dropDown list
    jcb1.addItemListener(new ItemListener(){
        public void itemStateChanged(ItemEvent ie){
          portSelected = (String) jcb1.getSelectedItem();
          if(portSelected.equals("no Serial selected")){
              println("Disconnecting serial port.");
              useSerialPortConnection = false;
              if (myPort != null)
              {
                myPort.stop();
                myPort = null;
              }
              drawbotReady = false;
              drawbotConnected = false;
            }
            else{
              try{
                if (myPort != null)
                {
                  myPort.stop();
                  myPort = null;
                }
                myPort = getNewSerial(portSelected);
                //read bytes into a buffer until you get a linefeed (ASCII 10):
                myPort.bufferUntil('\n');
                useSerialPortConnection = true;
                println("Successfully connected to port " + portSelected);
              }catch(Exception e){
                println("Attempting to connect to serial port in slot " + portSelected 
                + " caused an exception: " + e.getMessage());
              }
           }
        }
      });
    // confirm button
    jb[0].addActionListener(new ActionListener(){
      public void actionPerformed(ActionEvent ae){
        try{
           currentMachineMaxSpeed=Float.parseFloat(tf[0].getText());
           if(!usingMicrostep){
             if(usingAcceleration) currentMachineAccel = Float.parseFloat(tf[1].getText());
             inAirMaxSpeed = Float.parseFloat(tf[2].getText());
             inAirAccel = Float.parseFloat(tf[3].getText());
             // change speed mode here
             speedModeSelector = 0;
             if(usingAcceleration){
                speedModeSelector+=1;
             }
             if(usingSpeedMatch){
                speedModeSelector+=2;
             }
           }
           getDisplayMachine().setMMPerRev(Float.parseFloat(tf[4].getText()));
           getDisplayMachine().setStepsPerRev(Float.parseFloat(tf[5].getText()));
        }catch(NumberFormatException e){
          println("format wrong!!");
        }
      }
    });
  }
}
// pen Switch/logic related
public void drawSwitch(){
  // first switch to this pen
  int selector = 1; // now slot threshold has no difference
  addToCommandQueue(CMD_PLATROTATE+selector+",END");
}
void drawCurPosSelect(int n){
  curPenMode = n;
  // set pen logic after which can test pen logic
  addToCommandQueue(CMD_SWITCHPEN+curPenMode+",END");
  switch(curPenMode){
    case 1:// laser cutter
      controlValue = 0; // fully closed
      drawPenPosD_t.setLock(false); // lock parameter text field
      drawPenPosD_t.setText("0");
      testVal_t.setLock(false);
      testVal_t.setText("0");
      break;
    case 2:// pen force
      drawPenPosD_t.setLock(true); // lock parameter text field
      drawPenPosD_t.setText("default function!");
      testVal_t.setLock(true);
      testVal_t.setText("default function!");
      break;
    case 0:// linear actuator
    default:
      controlValue = defaultPenUp; // fully up position
      drawPenPosD_t.setLock(false); // lock parameter text field
      drawPenPosD_t.setText(new Integer(controlValue).toString());
      testVal_t.setLock(false);
      testVal_t.setText(new Integer(controlValue).toString());
      break;
  }
}
void drawPenPosD_t(String s){
  try{
    int value = parseInt(s);
    switch(curPenMode){
      case 1:
        if(value<=100 && value>=0){
          controlValue = value;
          testVal_t.setText(new Integer(controlValue).toString());
        }
        else
          println("This value doesn't match this tool's control logic!");
        break;
      case 2:
        println("You cannot enter any parameters for penforce!");
        break;
      case 0:
        // check whether make sense
        if(value<=defaultPenUp && value>=1000){
          controlValue = value;
          testVal_t.setText(new Integer(controlValue).toString());
        }
        else
          println("This value doesn't match this tool's control logic!");
      default:
        break;
    }
  }catch(NumberFormatException e){
    println("format wrong!");
  }
}
// TEST
void drawPenPosTest(){
  switch(curPenMode){
    case 0:
      addToCommandQueue(CMD_SETPENLIFTRANGE+controlValue+","+defaultPenUp+",END");
      break;
    case 1:
      addToCommandQueue(CMD_SETPENLIFTRANGE+controlValue+",END");
      addToCommandQueue(CMD_PENDOWN+"END");
      break;
    case 2:
      addToCommandQueue(CMD_SETPENLIFTRANGE+defaultResDown+","+defaultResUp+",END");
    default:
      break;
  }
}
public void drawGood(){
  tested = true;
  // upload tested parameters and then finish testing
  switch(curPenMode){
    case 0:
      addToCommandQueue(CMD_SETPENLIFTRANGE+controlValue+","+defaultPenUp+",1,END");
      break;
    case 1:
      addToCommandQueue(CMD_PENUP+"END");
      break;
    case 2:
      addToCommandQueue(CMD_SETPENLIFTRANGE+defaultResDown+","+defaultResUp+",1,END");
    default:
      break;
  }
  hideAllDraw_Test();
  showAllDraw_Vector();
}
public void drawTab(){
    test2Draw();
    page = 1;
}

public void save(){
  if(!savePanelVis){
    showSavePanel();
  }
  else{
    hideSavePanel();
  }
}
void savePanel_save(){
  savePropertiesFile();
  // clear old properties.
  props = null;
  loadFromPropertiesFile();
}
void savePanel_saveAs(){
  saveNewPropertiesFileWithFileChooser();
}
void savePanel_load(){
  loadNewPropertiesFilenameWithFileChooser();
}

/*------------------------------------  in draw page ---------------------------*/

/*------------------------------------  in test page ------------------------*/
public void testTab(){
  draw2Test();
  page = 2;
}
public void testPenPosX_t(String s){
  try{
    float value = Float.parseFloat(s);
    mousePos.x = value;
  }catch(NumberFormatException e){
    println("format wrong!!");
  }
}
public void testPenPosY_t(String s){
   try{
    float value = Float.parseFloat(s);
    mousePos.y = value;
  }catch(NumberFormatException e){
    println("format wrong!!");
  }
}
public void testPosTest(){
  if(mousePos!=null){
    PVector p = getDisplayMachine().asNativeCoords(mousePos); // in mm
    p = getDisplayMachine().inSteps(p); // transformed to steps
    // move to mouse vector position with straight line
    sendMoveToNativePosition(true,p);
  }
}
// pen logic
void testVal_t(String s){
  try{
    int value = parseInt(s);
    switch(curPenMode){
      case 1:
        if(value<=100 && value>=0)
          controlValue = value;
        else
          println("This value doesn't match this tool's control logic!");
        break;
      case 2:
        println("You cannot enter any parameters for penforce!");
        break;
      case 0:
        // check whether make sense
        if(value<=1830 && value>=1000)
          controlValue = value;
        else
          println("This value doesn't match this tool's control logic!");
      default:
        break;
    }
  }catch(NumberFormatException e){
    println("format wrong!");
  }
}

void testValTest(){
  drawPenPosTest();
}
public void testGood(){
  tested = true;
  // upload tested parameters and then finish testing
  switch(curPenMode){
    case 0:
      addToCommandQueue(CMD_SETPENLIFTRANGE+controlValue+","+defaultPenUp+",1,END");
      break;
    case 1:
      addToCommandQueue(CMD_PENUP+"END");
      break;
    case 2:
      addToCommandQueue(CMD_SETPENLIFTRANGE+defaultResDown+","+defaultResUp+",1,END");
    default:
      break;
  }
}
/*------------------------------------  in test page ------------------------*/
