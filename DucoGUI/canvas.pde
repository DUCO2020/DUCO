class DisplayMachine extends Machine
{
  private Rectangle outline = null;
  private float scaling = 1.0;
  private Scaler scaler = null;
  private PVector offset = null;
  private float imageTransparency = 1.0;
  private boolean drawGuidePoint = false;
  private PVector guide = new PVector(0,0);  //leftTop
  boolean refreshGuide = true; // not necessary to have this function

  public DisplayMachine(Machine m, PVector offset, float scaling)
  {
    // construct
    super(m.getWidth(), m.getHeight(), m.getMMPerRev(), m.getStepsPerRev());
    super.machineSize = m.machineSize;
    super.page = m.page;
    super.pictureFrame = m.pictureFrame;
    super.stepsPerRev = m.stepsPerRev;
    super.mmPerRev = m.mmPerRev;

    super.mmPerStep = m.mmPerStep;
    super.stepsPerMM = m.stepsPerMM;
    super.maxLength = m.maxLength;
    this.offset = offset;
    this.scaling = scaling;
    this.scaler = new Scaler(scaling);
    this.outline = null;
  }
  public Rectangle getOutline()
  {
    float w = sc(super.getWidth());
    float h = sc(super.getHeight());
    outline = new Rectangle(offset, new PVector( w,h ));
    return this.outline;
  }

  private Scaler getScaler()
  {
    if (scaler == null)
      this.scaler = new Scaler(getScaling());
    return scaler;
  }

  public void setScale(float scale)
  {
    this.scaling = scale;
    this.scaler = new Scaler(scale);
  }
  public float getScaling()
  {
    return this.scaling;
  }
  // return pixel values now!!!!
  public float sc(float val)
  {
    return getScaler().scale(val);
  }
  // set offset in pixel
  public void setOffset(PVector offset)
  {
    this.offset = offset;
  }
  public PVector getOffset()
  {
    return this.offset;
  }
  public void setImageTransparency(float trans)
  {
    this.imageTransparency = trans;
  }
  public int getImageTransparency()
  {
    float f = 255.0 * this.imageTransparency;
    f += 0.5;
    int result = (int) f;
    return result;
  }
  

  public final int DROP_SHADOW_DISTANCE = 4;
  public String getZoomText()
  {
    df.applyPattern("###");
    String zoom = df.format(scaling * 100) + "% zoom";   // scaling 0~1
    return zoom;
  }

  public String getDimensionsAsText(Rectangle r)
  {
    return getDimensionsAsText(r.getSize());
  }
  public String getDimensionsAsText(PVector p)
  {
    String dim = p.x + " x " + p.y + "mm";
    return dim;
  }

  public void drawLineLengthTexts()
  {
    PVector actual = asNativeCoords(scaleToDisplayMachine(getMouseVector()));
    PVector cart = scaleToDisplayMachine(getMouseVector());
    df.applyPattern("###.#");

    text("Line 1: " + df.format(actual.x) + "mm", getDisplayMachine().getOutline().getLeft()+10, getDisplayMachine().getOutline().getTop()+18);
    text("Line 2: " + df.format(actual.y) + "mm", getDisplayMachine().getOutline().getLeft()+10, getDisplayMachine().getOutline().getTop()+28);

    text("X Position: " + df.format(cart.x) + "mm", getDisplayMachine().getOutline().getLeft()+10, getDisplayMachine().getOutline().getTop()+42);
    text("Y Position: " + df.format(cart.y) + "mm", getDisplayMachine().getOutline().getLeft()+10, getDisplayMachine().getOutline().getTop()+52);
  }

  public void draw()
  {
    // work out the scaling factor.
    noStroke();
    // draw machine outline
    fill(getMachineColour());
    rect(getOutline().getLeft(), getOutline().getTop(), getOutline().getWidth(), getOutline().getHeight());

    if (displayingGuides)
    {
      stroke(getGuideColour());
      strokeWeight(1);
      // centre line
      line(getOutline().getLeft()+(getOutline().getWidth()/2), getOutline().getTop(), 
      getOutline().getLeft()+(getOutline().getWidth()/2), getOutline().getBottom());

      // page top line
      line(getOutline().getLeft(), getOutline().getTop()+sc(getHomePoint().y), 
      getOutline().getRight(), getOutline().getTop()+sc(getHomePoint().y));
    }

    // draw page
    fill(getPageColour());
    rect(getOutline().getLeft()+sc(getPage().getLeft()), 
    getOutline().getTop()+sc(getPage().getTop()), 
    sc(getPage().getWidth()), 
    sc(getPage().getHeight()));
    text("page " + getDimensionsAsText(getPage()), getOutline().getLeft()+sc(getPage().getLeft()), 
    getOutline().getTop()+sc(getPage().getTop())-3);
    noFill();

    stroke(getBackgroundColour(),150);
    strokeWeight(3);
    noFill();
    rect(getOutline().getLeft()-2, getOutline().getTop()-2, getOutline().getWidth()+3, getOutline().getHeight()+3);

    stroke(getMachineColour(),150);
    strokeWeight(3);
    noFill();
    rect(getOutline().getLeft()+sc(getPage().getLeft())-2, 
    getOutline().getTop()+sc(getPage().getTop())-2, 
    sc(getPage().getWidth())+4, 
    sc(getPage().getHeight())+4);
    
    // getHomePoint() return value as mm in Cartesian
    PVector homepoint = new PVector(getHomePoint().x,getHomePoint().y);
    PVector onScreen = scaleToScreen(homepoint);  // as pixel
    ellipse(onScreen.x, onScreen.y, 15, 15);
    strokeWeight(2);
    stroke(255);
    ellipse(onScreen.x, onScreen.y, 15, 15);
    
    fill(0);
    text("Home point", onScreen.x+ 15, onScreen.y-5);
    text(int(getHomePoint().x+0.5) + ", " + int(getHomePoint().y+0.5), onScreen.x+ 15, onScreen.y+15);
    noFill();
    
    
    if (displayingGuides&& 
      getOutline().surrounds(getMouseVector())
      && mouseOverControls().isEmpty())
    {
      drawLineLengthTexts();
      cursor(CROSS);
    }else{
      cursor(ARROW);
    }
    if (displayingVector && getVectorShape() != null)
    {
      displayVectorImage();
    }
    
    if (getGuidePoint()){
      guidePoint();
    }
    drawPictureFrame();
    
  }
  
  public void displayVectorImage()
  {
    displayVectorImage(getVectorShape(), vectorScaling/100, getVectorPosition(), color(0,0,0));
  }
  
  public void displayVectorImage(RShape vec, float scaling, PVector position, int strokeColour)
  { 
    if(refreshGuide){
      guide = scaleToScreen(getVectorPosition());  // vector position is stored as MM
    }
    RPoint[][] pointPaths = vec.getPointsInPaths();
    RG.ignoreStyles();
    strokeWeight(1);
    if (pointPaths != null)
    {
      for(int i = 0; i<pointPaths.length; i++)
      {
        if (pointPaths[i] != null) 
        {
          boolean inShape = false;
          for (int j = 0; j<pointPaths[i].length; j++)
          {
            Rectangle pf = getPictureFrame();
            PVector p = new PVector(pointPaths[i][j].x, pointPaths[i][j].y); // will be in pixel
            p = PVector.mult(p, scaling);
            p = PVector.mult(p, mmPerPixel); // first convert into mm since position is in MM
            p = PVector.add(p, position);
            if (pf.surrounds(p))  // check whether p in **real size** is inside pictureFrame
            {
              if (!inShape) 
              {
                beginShape();
                inShape = true;
              }
              p = scaleToScreen(p);
              stroke(strokeColour);
              vertex(p.x, p.y);
            }
            else
            {
              if (inShape) 
              {
                endShape();
                inShape = false;
              }
            }
          }
          if (inShape) endShape();
        }
      }
    }
  }
  
  public void guidePoint(){
    fill(255,0,0,128);
    ellipse(guide.x, guide.y, 10,10);
    noFill();
  }
  
  public void setGuidePoint(boolean flag){
    drawGuidePoint = flag;
  }
  
  public boolean getGuidePoint(){
    return drawGuidePoint;
  }
  
  /**  Given a point on-screen with pixel units, this works out where on the 
   actual machine it refers to.
   */
  // all testing points and on screen points should be tranlated by this function
  // to mm
  public PVector scaleToDisplayMachine(PVector screen)
  {
    // offset
    float x = screen.x - getOffset().x;
    float y = screen.y - getOffset().y;

    // transform
    float scalingFactor = 1.0/getScaling();
    x = scalingFactor * x;
    y = scalingFactor * y;
    
    // from pixel back to mm
    x = mmPerPixel * x;
    y = mmPerPixel * y;

    // and out
    PVector mach = new PVector(x, y);
    return mach;
  }

  /** This works out the position, on-screen of a specific point on the machine.
   Both values are cartesian coordinates.
   */
  public PVector scaleToScreen(PVector mach)
  {
    // transform
    float x = mach.x * scaling;
    float y = mach.y * scaling;
    
    // transform to pixel
    x = x * (1.0/mmPerPixel);
    y = y * (1.0/mmPerPixel);

    // offset should be in pixel too
    x = x + getOffset().x;
    y = y + getOffset().y;

    // and out!
    PVector screen = new PVector(x, y);
    return screen;
  }

  // converts a cartesian coord into a native one
  public PVector convertToNative(PVector cart)
  {
    // width of machine in mm
    float width = super.getWidth();

    // work out distances
    float a = dist(0, 0, cart.x, cart.y);
    float b = dist(width, 0, cart.x, cart.y);

    // and out
    PVector nativeMM = new PVector(a, b);
    return nativeMM;
  }

  void drawPictureFrame()
  {
    strokeWeight(1);

    PVector topLeft = scaleToScreen(getPictureFrame().getTopLeft());
    PVector botRight = scaleToScreen(getPictureFrame().getBotRight());

    stroke (getFrameColour());

    // top left    
    line(topLeft.x-4, topLeft.y, topLeft.x-10, topLeft.y);
    line(topLeft.x, topLeft.y-4, topLeft.x, topLeft.y-10);

    // top right
    line(botRight.x+4, topLeft.y, botRight.x+10, topLeft.y);
    line(botRight.x, topLeft.y-4, botRight.x, topLeft.y-10);

    // bot right
    line(botRight.x+4, botRight.y, botRight.x+10, botRight.y);
    line(botRight.x, botRight.y+4, botRight.x, botRight.y+10);

    // bot left
    line(topLeft.x-4, botRight.y, topLeft.x-10, botRight.y);
    line(topLeft.x, botRight.y+4, topLeft.x, botRight.y+10);

    stroke(255);
  }  
}
