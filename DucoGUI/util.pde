/**
 * define a box
 */
class Rectangle
{
  public PVector position = null;
  public PVector size = null;
  
  public Rectangle(float px, float py, float width, float height)
  {
    this.position = new PVector(px, py);
    this.size = new PVector(width, height);
  }
  public Rectangle(PVector position, PVector size)
  {
    this.position = position;
    this.size = size;
  }
  public Rectangle(Rectangle r)
  {
    this.position = new PVector(r.getPosition().x, r.getPosition().y);
    this.size = new PVector(r.getSize().x, r.getSize().y);
  }
  
  public float getWidth()
  {
    return this.size.x;
  }
  public void setWidth(float w)
  {
    this.size.x = w;
  }
  public float getHeight()
  {
    return this.size.y;
  }
  public void setHeight(float h)
  {
    this.size.y = h;
  }
  public PVector getPosition()
  {
    return this.position;
  }
  public PVector getSize()
  {
    return this.size;
  }
  public PVector getTopLeft()
  {
    return getPosition();
  }
  public PVector getTopRight()
  {
    return new PVector(this.size.x+this.position.x, this.position.y);
  }
  public PVector getBotRight()
  {
    return PVector.add(this.position, this.size);
  }
  public float getLeft()
  {
    return getPosition().x;
  }
  public float getRight()
  {
    return getPosition().x + getSize().x;
  }
  public float getTop()
  {
    return getPosition().y;
  }
  public float getBottom()
  {
    return getPosition().y + getSize().y;
  }
  
  public void setPosition(float x, float y)
  {
    if (this.position == null)
      this.position = new PVector(x, y);
    else
    {
      this.position.x = x;
      this.position.y = y;
    }
  }
  
  public Boolean surrounds(PVector p)
  {
    if (p.x >= this.getLeft()
    && p.x < this.getRight()
    && p.y >= this.getTop()
    && p.y < this.getBottom()-1)
      return true;
    else
      return false;
  }
}

/**
 * define scaling function
 */
class Scaler
{
  public float scale = 1.0;
  //private float pixelPerMM = 3.7795276;
  private float pixelPerMM = 1.0/mmPerPixel;
  
  public Scaler(float scale)
  {
    this.scale = scale;
  }
  public void setScale(float scale)
  {
    this.scale = scale;
  }
  // now scale to pixels
  public float scale(float in)
  {
    return in * pixelPerMM * scale;  // never store steps any more!!
    //return in * mmPerStep * scale;
  }
}

class PreviewVector extends PVector
{
  public String command;
}


/**
 * define javax.swing popping out window
 */
import java.awt.Dimension;
import java.awt.Toolkit;
import java.awt.BorderLayout;
import java.awt.GraphicsEnvironment;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowListener;
import java.awt.event.ActionListener;
import java.awt.event.WindowEvent;
import java.awt.event.ActionEvent;

public class JavaConsole implements WindowListener{
  public JFrame jframe;
  public JTextField[] tf;  // jtextfield group in a poping out window
  public JLabel[] jl; //jlabel group
  
  public JButton[] jb; // basic jButtons in a window
  public JToggleButton[] jtb; //jtoggle group
  public ButtonGroup bg; // only one can be selected in this group
  public JRadioButton[] bgArray; //store all references
  
  public JComboBox jcb1;
  public JLabel jcbl1;
  public JavaConsole(String st, int wid, int he){
    jframe = new JFrame(st);
    //jframe.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
    jframe.setSize(wid,he);
    jframe.setLayout(null);
  }
  public void initBasicButtons(){
    jb = new JButton[2];
    jb[0] = new JButton("confirm!");
    jb[1] = new JButton("close");
    jb[1].addActionListener(new ActionListener(){
      public void actionPerformed(ActionEvent av){
        jframe.setVisible(false); // default behaviour of JFrame
        jframe.getContentPane().removeAll();
        jframe.dispose();
      }
    });
  }
  public void initButtonGroup(String[] names){
    bgArray = new JRadioButton[names.length];
    bg = new ButtonGroup();
    for(int i=0;i<names.length;i++){
      JRadioButton rb = new JRadioButton(names[i]);
      bg.add(rb);
      bgArray[i]=rb;
    }
  }
  public void initTextFieldGroup(String[] names){
    tf = new JTextField[names.length];
    jl = new JLabel[names.length];
    // init text field with its name
    for(int i=0;i<names.length;i++){
      tf[i]= new JTextField(10);
      jl[i]= new JLabel(names[i]);
    }
  }
  public void initToggles(String[] names){
    jtb = new JToggleButton[names.length];
    for(int i=0;i<names.length;i++){
      jtb[i]=new JToggleButton(names[i],false); // default as not selected
    }
  }
  public void initComboBox(String[] names){
    jcb1 = new JComboBox(names);
    jcbl1 = new JLabel("Serial Port:");
  }
  
  public synchronized void windowClosing(WindowEvent evt)
  {
    jframe.setVisible(false); // default behaviour of JFrame
    jframe.getContentPane().removeAll();
    jframe.dispose();
  }
  
  public void windowIconified(WindowEvent evt) {
  }
  public void windowDeiconified(WindowEvent evt) {
  }
  public void windowOpened(WindowEvent evt) {
  }
  public void windowActivated(WindowEvent evt) {
  }
  public void windowDeactivated(WindowEvent evt) {
  }
  public void windowClosed(WindowEvent evt) {
  }
}

void modeSelection(int selector){
  switch(selector){
    case 1:
       this.usingSpeedMatch = false;
       this.usingAcceleration = true;
       break;
    case 2:
       this.usingSpeedMatch = true;
       this.usingAcceleration = false;
       break;
    case 3:
       this.usingSpeedMatch = true;
       this.usingAcceleration = true;
       break;
    case 0:   
    default:
       this.usingAcceleration = false;
       this.usingSpeedMatch = false;
       break;
  }
}

// properties loading&saving functions
void refreshTextAfterLoad(){
  df.applyPattern("###.##");
  
  welcomeMachineW_t.setText(df.format(getDisplayMachine().getSize().x));
  welcomeMachineH_t.setText(df.format(getDisplayMachine().getSize().y));
  welcomeCanvasW_t.setText(df.format(getDisplayMachine().getPage().getWidth()));
  welcomeCanvasH_t.setText(df.format(getDisplayMachine().getPage().getHeight()));
  drawMachineAreaW_t.setText(df.format(getDisplayMachine().getSize().x));
  drawMachineAreaH_t.setText(df.format(getDisplayMachine().getSize().y));
  drawCanvasW_t.setText(df.format(getDisplayMachine().getPage().getWidth()));
  drawCanvasH_t.setText(df.format(getDisplayMachine().getPage().getHeight()));
  drawHomePointH_t.setText(df.format(getHomePoint().y));
  drawVectorX_t.setText(df.format(vectorPosition.x));
  drawVectorY_t.setText(df.format(vectorPosition.y));
  // vectorScaling?
}
Properties getProperties()
{
  if (props == null)
  {
    FileInputStream propertiesFileStream = null;
    try
    {
      props = new Properties();
      String fileToLoad = sketchPath(propertiesFilename);

      File propertiesFile = new File(fileToLoad);
      if (!propertiesFile.exists())
      {
        println("saving.");
        savePropertiesFile();
        println("saved.");
      }

      propertiesFileStream = new FileInputStream(propertiesFile);
      props.load(propertiesFileStream); // load method deals with fileInputStream object
      println("Successfully loaded properties file " + fileToLoad);
    }
    catch (IOException e)
    {
      println("Couldn't read the properties file - will attempt to create one.");
      println(e.getMessage());
    }
    finally
    {
      try 
      { 
        propertiesFileStream.close();
      }
      catch (Exception e) 
      {
        println("Exception: "+e.getMessage());
      };
    }
  }
  return props;
}
void loadFromPropertiesFile()
{
  // machine/canvas setting
  getDisplayMachine().loadDefinitionFromProperties(getProperties());
  // motor settings
  this.currentMachineMaxSpeed = getFloatProperty("DUCO.motors.maxSpeed", 600.0);
  this.currentMachineAccel = getFloatProperty("DUCO.motors.accel", 400.0);
  this.inAirMaxSpeed = getFloatProperty("DUCO.motors.inAirMaxSpeed", 400.0);
  this.inAirAccel = getFloatProperty("DUCO.motors.inAirAccel", 100.0);
  speedModeSelector = getIntProperty("DUCO.speedMode",0);
  modeSelection(speedModeSelector);
  usingMicrostep = getBooleanProperty("DUCO.motors.usingMicrostep",false);
  
  // vector position
  getVectorPosition().x = getFloatProperty("DUCO.vector.position.x", 0.0);
  getVectorPosition().y = getFloatProperty("DUCO.vector.position.y", 0.0);
  // homePoint position
  float homePointY = getFloatProperty("DUCO.homepoint.y", 20.0);
  this.homePointCartesian = new PVector(0, homePointY);
  centerHomepoint();
  println("home point loaded: " + homePointCartesian + ", " + getHomePoint());
  // refreshing
  refreshTextAfterLoad();
  println("Finished loading configuration from properties file.");
}

void savePropertiesFile()
{
  Properties props = new Properties();
  props = getDisplayMachine().loadDefinitionIntoProperties(props);
  df.applyPattern("###.##");
  props.setProperty("DUCO.motors.maxSpeed", df.format(currentMachineMaxSpeed));
  props.setProperty("DUCO.motors.accel", df.format(currentMachineAccel));
  props.setProperty("DUCO.motors.inAirMaxSpeed", df.format(inAirMaxSpeed));
  props.setProperty("DUCO.motors.inAirAccel", df.format(inAirAccel));
  props.setProperty("DUCO.speedMode",new Integer(speedModeSelector).toString());
  props.setProperty("DUCO.motors.usingMicrostep",new Boolean(usingMicrostep).toString());
  PVector hp = null;  
  if (getHomePoint() != null)
  {
    hp = getHomePoint();
  }
  else
    hp = new PVector(500.0, 20.0);
  props.setProperty("DUCO.homepoint.y", df.format(hp.y));
  props.setProperty("DUCO.vector.position.x", df.format(getVectorPosition().x));
  props.setProperty("DUCO.vector.position.y", df.format(getVectorPosition().y));
  FileOutputStream propertiesOutput = null;

  try
  {
    //save the properties to a file
    File propertiesFile = new File(sketchPath(propertiesFilename));
    if (propertiesFile.exists())
    {
      propertiesOutput = new FileOutputStream(propertiesFile);
      Properties oldProps = new Properties();
      FileInputStream propertiesFileStream = new FileInputStream(propertiesFile);
      oldProps.load(propertiesFileStream);
      oldProps.putAll(props);
      oldProps.store(propertiesOutput, "   *** DUCO properties file   ***  ");
      println("Saved settings.");
    }
    else
    { // create it
      propertiesFile.createNewFile();
      propertiesOutput = new FileOutputStream(propertiesFile);
      props.store(propertiesOutput, "   ***  DUCO properties file   ***  ");
      println("Created file.");
    }
  }
  catch (Exception e)
  {
    println("Exception occurred while creating new properties file: " + e.getMessage());
  }
  finally
  {
    if (propertiesOutput != null)
    {
      try
      {
        propertiesOutput.close();
      }
      catch (Exception e2) {
        println("what now!"+e2.getMessage());
      }
    }
  }
}

// propertiesFilter used by saving/loading new properties
class PropertiesFileFilter extends javax.swing.filechooser.FileFilter 
{
  public boolean accept(File file) {
    String filename = file.getName();
    filename.toLowerCase();
    if (file.isDirectory() || filename.endsWith(".properties.txt")) 
      return true;
    else
      return false;
  }
  public String getDescription() {
    return "Properties files (*.properties.txt)";
  }
}
// load new properties
void loadNewPropertiesFilenameWithFileChooser()
{
  SwingUtilities.invokeLater(new Runnable() 
  {
    public void run() 
    {
      JFileChooser fc = new JFileChooser();
      fc.setFileFilter(new PropertiesFileFilter());

      fc.setDialogTitle("Choose a config file...");

      int returned = fc.showOpenDialog(frame);
      if (returned == JFileChooser.APPROVE_OPTION) 
      {
        File file = fc.getSelectedFile();
        if (file.exists())
        {
          println("New properties file exists.");
          newPropertiesFilename = file.toString();
          println("new propertiesFilename: "+  newPropertiesFilename);
          propertiesFilename = newPropertiesFilename;
          // clear old properties.
          props = null;
          loadFromPropertiesFile();
        }
      }
    }
  }
  );
}
// save new properties
void saveNewPropertiesFileWithFileChooser()
{
  SwingUtilities.invokeLater(new Runnable() 
  {
    public void run() 
    {
      JFileChooser fc = new JFileChooser();
      fc.setFileFilter(new PropertiesFileFilter());

      fc.setDialogTitle("Enter a config file name...");

      int returned = fc.showSaveDialog(frame);
      if (returned == JFileChooser.APPROVE_OPTION) 
      {
        File file = fc.getSelectedFile();
        newPropertiesFilename = file.toString();
        newPropertiesFilename.toLowerCase();
        if (!newPropertiesFilename.endsWith(".properties.txt"))
          newPropertiesFilename+=".properties.txt";

        println("new propertiesFilename: "+  newPropertiesFilename);
        propertiesFilename = newPropertiesFilename;
        savePropertiesFile();
        // clear old properties.
        props = null;
        loadFromPropertiesFile();
      }
    }
  }
  );
}
// save/load util!!
boolean getBooleanProperty(String id, boolean defState) 
{
  return boolean(getProperties().getProperty(id, ""+defState));
}

int getIntProperty(String id, int defVal) 
{
  return int(getProperties().getProperty(id, ""+defVal)); // find key id! if none, return default value
}

float getFloatProperty(String id, float defVal) 
{
  return float(getProperties().getProperty(id, ""+defVal));
}
String getStringProperty(String id, String defVal)
{
  return getProperties().getProperty(id, defVal);
}


// vector loading functions
RShape loadShapeFromFile(String filename) {
  RShape sh = null;
  if (filename.toLowerCase().endsWith(".svg")) {
    sh = RG.loadShape(filename); //RG.loadShape facing some problems
    // requiring processing.xml.XMLElement class which has been removed by processing 2+
    // using new version of Geomerative
  }
  return sh;
}

class VectorFileFilter extends javax.swing.filechooser.FileFilter 
{
  public boolean accept(File file) {
    String filename = file.getName();
    filename.toLowerCase();
    if (file.isDirectory() || filename.endsWith(".svg") || filename.endsWith(".gco") || filename.endsWith(".g"))
      return true;
    else
      return false;
  }
  public String getDescription() {
    return "Vector graphic files (SVG, GCode)";
  }
}
void loadVectorWithFileChooser()
{
  SwingUtilities.invokeLater(new Runnable() 
  {
    public void run() {
      JFileChooser fc = new JFileChooser();
      fc.setFileFilter(new VectorFileFilter());

      fc.setDialogTitle("Choose a vector file...");

      int returned = fc.showOpenDialog(frame);
      if (returned == JFileChooser.APPROVE_OPTION) 
      {
        File file = fc.getSelectedFile();
        if (file.exists())
        {
          RShape shape = loadShapeFromFile(file.getPath());
          if (shape != null) 
          {
            setVectorFilename(file.getPath());
            //println(file.getPath());
            setVectorShape(shape);
          }
          else 
          {
            println("File not found (" + file.getPath() + ")");
          }
        }
      }
    }
  }
  );
}
