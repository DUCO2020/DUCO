class Machine
{
  protected PVector machineSize = new PVector(4000,6000);

  protected Rectangle page = new Rectangle(1000,1000,2000,3000);
  protected Rectangle pictureFrame = new Rectangle(1600,1600,800,800);

  protected Float stepsPerRev = 800.0;
  protected Float mmPerRev = 95.0;
  
  protected Float mmPerStep = null;
  protected Float stepsPerMM = null;
  protected Float maxLength = null;
  protected List<Float> gridLinePositions = null;
  
  
  
  public Machine(Integer width, Integer height, Float stepsPerRev, Float mmPerRev)
  {
    this.setSize(width, height);
    this.setStepsPerRev(stepsPerRev);
    this.setMMPerRev(mmPerRev);
  }
  
  public void setSize(Integer width, Integer height)
  {
    PVector s = new PVector(width, height);
    this.machineSize = s;
    maxLength = null;
  }
  public PVector getSize()
  {
    return this.machineSize;
  }
  public Float getMaxLength()
  {
    if (maxLength == null)
    {
      maxLength = dist(0,0, getWidth(), getHeight());
    }
    return maxLength;
  }
  
  public void setPage(Rectangle r)
  {
    this.page = r;
  }
  public Rectangle getPage()
  {
    return this.page;
  }
  public float getPageCentrePosition(float pageWidth)
  {
    return (getWidth()- pageWidth/2)/2;
  }

  public void setPictureFrame(Rectangle r)
  {  
    this.pictureFrame = r;
  }
  public Rectangle getPictureFrame()
  {
    return this.pictureFrame;
  }
    
  public Integer getWidth()
  {
    return int(this.machineSize.x);
  }
  public Integer getHeight()
  {
    return int(this.machineSize.y);
  }
  
  public void setStepsPerRev(Float s)
  {
    this.stepsPerRev = s;
  }
  public Float getStepsPerRev()
  {
    mmPerStep = null;
    stepsPerMM = null;
    return this.stepsPerRev;
  }
  public void setMMPerRev(Float d)
  {
    mmPerStep = null;
    stepsPerMM = null;
    this.mmPerRev = d;
  }
  public Float getMMPerRev()
  {
    return this.mmPerRev;
  }
  public Float getMMPerStep()
  {
    if (mmPerStep == null)
    {
      mmPerStep = mmPerRev / stepsPerRev;
    }
    return mmPerStep;
  }
  public Float getStepsPerMM()
  {
    if (stepsPerMM == null)
    {
      stepsPerMM = stepsPerRev / mmPerRev;
    }
    return stepsPerMM;
  }
  
  public int inSteps(int inMM) 
  {
    double steps = inMM * getStepsPerMM();
    steps += 0.5;
    int stepsInt = (int) steps;
    return stepsInt;
  }
  
  public int inSteps(float inMM) 
  {
    double steps = inMM * getStepsPerMM();
    steps += 0.5;
    int stepsInt = (int) steps;
    return stepsInt;
  }
  
  public PVector inSteps(PVector mm)
  {
    PVector steps = new PVector(inSteps(mm.x), inSteps(mm.y));
    return steps;
  }
  
  public int inMM(float steps) 
  {
    double mm = steps / getStepsPerMM();
    mm += 0.5;
    int mmInt = (int) mm;
    return mmInt;
  }
  
  public PVector inMM (PVector steps)
  {
    PVector mm = new PVector(inMM(steps.x), inMM(steps.y));
    return mm;
  }
  

    
  public PVector asNativeCoords(PVector cartCoords)
  {
    return asNativeCoords(cartCoords.x, cartCoords.y);
  }
  public PVector asNativeCoords(float cartX, float cartY)
  {
    float distA = dist(0,0,cartX, cartY);
    float distB = dist(getWidth(),0,cartX, cartY);
    PVector pgCoords = new PVector(distA, distB);
    return pgCoords;
  }
  
  
  public PVector asCartesianCoords(PVector pgCoords)
  {
    float calcX = int((pow(getWidth(), 2) - pow(pgCoords.y, 2) + pow(pgCoords.x, 2)) / (getWidth()*2));
    float calcY = int(sqrt(pow(pgCoords.x,2)-pow(calcX,2)));
    PVector vect = new PVector(calcX, calcY);
    return vect;
  }
  
  public Integer convertSizePreset(String preset)
  {
    Integer result = A3_SHORT;
    if (preset.equalsIgnoreCase(PRESET_A3_SHORT))
      result = A3_SHORT;
    else if (preset.equalsIgnoreCase(PRESET_A3_LONG))
      result = A3_LONG;
    else if (preset.equalsIgnoreCase(PRESET_A2_SHORT))
      result = A2_SHORT;
    else if (preset.equalsIgnoreCase(PRESET_A2_LONG))
      result = A2_LONG;
    else if (preset.equalsIgnoreCase(PRESET_A2_IMP_SHORT))
      result = A2_IMP_SHORT;
    else if (preset.equalsIgnoreCase(PRESET_A2_IMP_LONG))
      result = A2_IMP_LONG;
    else if (preset.equalsIgnoreCase(PRESET_A1_SHORT))
      result = A1_SHORT;
    else if (preset.equalsIgnoreCase(PRESET_A1_LONG))
      result = A1_LONG;
    else
    {
      try
      {
        result = Integer.parseInt(preset);
      }
      catch (NumberFormatException nfe)
      {
        result = A3_SHORT;
      }
    }
    return result;
  }
  
  public void loadDefinitionFromProperties(Properties props)
  {
    // get these first because they are important to convert the rest of them
    setStepsPerRev(getFloatProperty("DUCO.motors.stepsPerRev", 800.0));
    setMMPerRev(getFloatProperty("DUCO.motors.mmPerRev", 95.0));
    // machine size
    setSize(getIntProperty("DUCO.machine.width", 600), getIntProperty("DUCO.machine.height", 800));
    // page size
    float pw = getIntProperty("DUCO.page.width", A3_SHORT);
    float ph = getIntProperty("DUCO.page.height", A3_LONG);
    PVector pageSize = new PVector(pw, ph);
    // page position
    float px = (getSize().x - pageSize.x) / 2.0; // default as center point
    float py = getFloatProperty("DUCO.page.position.y", 120);
    PVector pagePos = new PVector(px, py);
    Rectangle page = new Rectangle(pagePos, pageSize);
    setPage(page);
    //set Picture Frame, default as page size and pos
    setFrame();
  }
  
  
  public Properties loadDefinitionIntoProperties(Properties props)
  {
    // Put keys into properties file:
    props.setProperty("DUCO.motors.stepsPerRev", getStepsPerRev().toString());
    props.setProperty("DUCO.motors.mmPerRev", getMMPerRev().toString());

    // machine width
    props.setProperty("DUCO.machine.width", Integer.toString((int) getWidth()));
    // machine.height
    props.setProperty("DUCO.machine.height", Integer.toString((int) getHeight()));

    // page size
    // page position
    float pageSizeX = 0.0;
    float pageSizeY = 0.0;
    float pagePosY = 0.0;
    if (getPage() != null)
    {
      pageSizeX = getPage().getWidth();
      pageSizeY = getPage().getHeight();
      pagePosY = getPage().getTop();
    }
    props.setProperty("DUCO.page.width", Integer.toString((int) pageSizeX));
    props.setProperty("DUCO.page.height", Integer.toString((int) pageSizeY));
    props.setProperty("DUCO.page.position.y", Integer.toString((int) pagePosY));
    return props;
  }
}
