
static final String CMD_CHANGELENGTH = "C01,";
static final String CMD_CHANGESPEEDMODE = "C03,";
static final String CMD_CHANGEMOTORMODE = "C04,";
static final String CMD_SETPOSITION = "C09,";
static final String CMD_PLATROTATE = "C11,";
static final String CMD_SWITCHPEN = "C12,";
static final String CMD_PENDOWN = "C13,";
static final String CMD_PENUP = "C14,";
static final String CMD_CHANGELENGTHDIRECT = "C17,";
static final String CMD_CHANGEMACHINESIZE = "C24,";
static final String CMD_CHANGEMACHINENAME = "C25,";
static final String CMD_REQUESTMACHINESIZE = "C26,";
static final String CMD_RESETMACHINE = "C27,";
static final String CMD_CHANGEMACHINEMMPERREV = "C29,";
static final String CMD_CHANGEMACHINESTEPSPERREV = "C30,";
static final String CMD_SETMOTORSPEED = "C31,";
static final String CMD_SETMOTORACCEL = "C32,";
static final String CMD_CHANGELENGTH_RELATIVE = "C40,";
static final String CMD_SETPENLIFTRANGE = "C45,";

static final int PATH_SORT_NONE = 0;
static final int PATH_SORT_MOST_POINTS_FIRST = 1;
static final int PATH_SORT_GREATEST_AREA_FIRST = 2;
static final int PATH_SORT_CENTRE_FIRST = 3;
static final int PATH_SORT_NEAREST_FIRST = 4;


private PVector mouseVector = new PVector(0, 0);

Comparator xAscending = new Comparator() 
{
  public int compare(Object p1, Object p2)
  {
    PVector a = (PVector) p1;
    PVector b = (PVector) p2;

    int xValue = new Float(a.x).compareTo(b.x);
    return xValue;
  }
};

Comparator yAscending = new Comparator() 
{
  public int compare(Object p1, Object p2)
  {
    PVector a = (PVector) p1;
    PVector b = (PVector) p2;

    int yValue = new Float(a.y).compareTo(b.y);
    return yValue;
  }
};

void sendResetMachine()
{
  String command = CMD_RESETMACHINE + "END";
  addToCommandQueue(command);
}
void sendRequestMachineSize()
{
  String command = CMD_REQUESTMACHINESIZE + "END";
  addToCommandQueue(command);
}
void sendMachineSpec()
{
  // ask for input to get the new machine size
  String command = CMD_CHANGEMACHINENAME+newMachineName+",END";
  addToCommandQueue(command);
  command = CMD_CHANGEMACHINESIZE+getDisplayMachine().getWidth()+","+getDisplayMachine().getHeight()+",END";
  addToCommandQueue(command);
}

public PVector getMouseVector()
{
  if (mouseVector == null)
  {
    mouseVector = new PVector(0, 0);
  }

  mouseVector.x = mouseX;
  mouseVector.y = mouseY;
  return mouseVector;
}

// functions for move to pinpoint with/without straight trace 
// C01 will use max Speed to implement
// C17 will both use accel/ max speed
void sendMoveToNativePosition(boolean direct, PVector p)
{
  String command = null;
  if (p==null)
    command = CMD_CHANGELENGTH+int(-1)+","+int(-1)+",END";
  else if(direct)
    command = CMD_CHANGELENGTHDIRECT+int(p.x+0.5)+","+int(p.y+0.5)+","+getMaxSegmentLength()+",END";  // sort of guarantee straightline trace
  else
    command = CMD_CHANGELENGTH+(int)p.x+","+(int)p.y+",END"; // do not guarantee trace!
  addToCommandQueue(command);
}

int getMaxSegmentLength()
{
  return this.maxSegmentLength;
}

void sendSetPosition()
{
  PVector p = getDisplayMachine().scaleToDisplayMachine(getMouseVector()); // return mm
  p = getDisplayMachine().convertToNative(p);
  p = getDisplayMachine().inSteps(p); // mm to steps

  String command = CMD_SETPOSITION+int(p.x+0.5)+","+int(p.y+0.5)+",END";
  addToCommandQueue(command);
}
void sendSetHomePosition()
{
  //debugging
  PVector hp = getHomePoint(); // in MM
  PVector pgCoords = getDisplayMachine().inSteps(getDisplayMachine().asNativeCoords(hp));

  String command = CMD_SETPOSITION+int(pgCoords.x+0.5)+","+int(pgCoords.y+0.5)+",END";
  addToCommandQueue(command);
}

/* -------------------------------- related to vector drawing ------------------------*/
void speedUp(){
  // speedup!!
  df.applyPattern("###.##");
  addToCommandQueue(CMD_CHANGESPEEDMODE + 1 + ",END");
  addToCommandQueue(CMD_SETMOTORSPEED+df.format(inAirMaxSpeed)+",1,END");
  addToCommandQueue(CMD_SETMOTORACCEL+df.format(inAirAccel)+",1,END");
}
void returnToSetSpeed(){
  //return to set speed mode
  df.applyPattern("###.##");
  addToCommandQueue(CMD_CHANGESPEEDMODE + speedModeSelector + ",END");
  addToCommandQueue(CMD_SETMOTORSPEED+df.format(currentMachineMaxSpeed)+",1,END");
  if(usingAcceleration) addToCommandQueue(CMD_SETMOTORACCEL+df.format(currentMachineAccel)+",1,END");
}
void sendVectorShapes()
{
  sendVectorShapes(getVectorShape(), vectorScaling/100, getVectorPosition(), PATH_SORT_NEAREST_FIRST);
}

// parse a whole SVG to a bunch of String CMDs!!!!!!
void sendVectorShapes(RShape vec, float scaling, PVector position, int pathSortingAlgorithm)
{
  println("Send vector shapes.");
  RPoint[][] pointPaths = vec.getPointsInPaths();      

  // sort the paths to optimise the draw sequence
  switch (pathSortingAlgorithm) {
    case PATH_SORT_MOST_POINTS_FIRST: pointPaths = sortPathsLongestFirst(pointPaths, pathLengthHighPassCutoff); break;
    case PATH_SORT_GREATEST_AREA_FIRST: pointPaths = sortPathsGreatestAreaFirst(vec, pathLengthHighPassCutoff); break;
    case PATH_SORT_CENTRE_FIRST: pointPaths = sortPathsCentreFirst(vec, pathLengthHighPassCutoff); break;
    case PATH_SORT_NEAREST_FIRST: pointPaths = sortPathsNearestFirst(pointPaths); break;
    default: break;
  }

  String command = "";
  PVector lastPoint = new PVector();
  boolean liftToGetToNewPoint = true;

  // go through and get each path
  for (int i = 0; i<pointPaths.length; i++)
  {
    if (pointPaths[i] != null) 
    {
      boolean firstPointFound = false;
      if (pointPaths[i].length > pathLengthHighPassCutoff)
      {
        // filteredPoints represent one component line using a list of points
        List<PVector> filteredPoints = filterPoints(pointPaths[i], VECTOR_FILTER_LOW_PASS, minimumVectorLineLength, scaling, position);
        if (!filteredPoints.isEmpty())
        {
          // draw the first one with a pen up and down to get to it
          PVector p = filteredPoints.get(0);
          if ( p.x == lastPoint.x && p.y == lastPoint.y )
            liftToGetToNewPoint = false;
          else
            liftToGetToNewPoint = true;

          // pen UP! (IF THE NEW POINT IS DIFFERENT FROM THE LAST ONE!)
          if (liftToGetToNewPoint){
            // speedup!!
            if(!usingMicrostep)speedUp();
            
            addToCommandQueue(CMD_PENUP+"END");
            command = CMD_CHANGELENGTHDIRECT+(int)p.x+","+(int)p.y+","+getMaxSegmentLength()+",END";
            addToCommandQueue(command);
            
            // return to set speed mode
            if(!usingMicrostep)returnToSetSpeed();
            addToCommandQueue(CMD_PENDOWN+"END");
          }

          // then just iterate through the rest
          for (int j=1; j<filteredPoints.size(); j++)
          {
            p = filteredPoints.get(j);
            command = CMD_CHANGELENGTHDIRECT+(int)p.x+","+(int)p.y+","+getMaxSegmentLength()+",END";
            addToCommandQueue(command);
          }
          lastPoint = new PVector(p.x, p.y); 
        }
      }
    }
  }
  // checked!!
  // speedup!!
  if(!usingMicrostep)speedUp();
  addToCommandQueue(CMD_PENUP+"END");
  // should trigger resendCommand() func
  addToCommandQueue("fool!");
  // add Reture home function here!!!
  sendMoveToNativePosition(false,null);
  // return to set speed mode
  if(!usingMicrostep)returnToSetSpeed();
  println("finished.");
}

/**
This function sort all path with continous drawing as first priority
shortest distance to next path as second priority
*/
public RPoint[][] sortPathsNearestFirst(RPoint[][] pointPaths)
{
  List<RPoint[]> pathsList = new ArrayList<RPoint[]>(pointPaths.length);
  List<RPoint[]> startEnd = new ArrayList<RPoint[]>(pointPaths.length); // store all start/end points
  RPoint[][] sortedPaths = new RPoint[pointPaths.length][];
  for (int i = 0; i<pointPaths.length; i++)
  {
    RPoint[] temp = new RPoint[2];
    if (pointPaths[i] != null) 
    {
      int idx = pointPaths[i].length-1;
      temp[0]=pointPaths[i][0];
      temp[1]=pointPaths[i][idx];
      pathsList.add(pointPaths[i]);
      startEnd.add(temp);
    }
  }
  
  int j = 1;
  sortedPaths[0]= pathsList.get(0);
  RPoint[] firstPath = pathsList.remove(0);
  startEnd.remove(0);
  while(!pathsList.isEmpty()){
    // implement sort logic
    // first sort any overlapped start/end point with firstPath's end.
    boolean overlapped = false;
    int len = firstPath.length;
    RPoint firstPathEnd = firstPath[len-1];
    for(int i=0;i<(2*startEnd.size());i++){
      int idx1 = i/2;
      int idx2 = i-2*idx1;
      //if(firstPathEnd==startEnd.get(idx1)[idx2]){
      if(checkOverlapped(firstPathEnd,startEnd.get(idx1)[idx2])){
        firstPath = pathsList.remove(idx1);
        startEnd.remove(idx1);
        if(idx2!=0){
          //end match
          //reverse the path orientation
          int n = firstPath.length;
          RPoint exchange;
          for(int m=0 ;m < n/2 ; m++){
            exchange = firstPath[m];
            firstPath[m]=firstPath[n-m-1];
            firstPath[n-m-1]= exchange;
          }
        }
        overlapped = true;
        sortedPaths[j]=firstPath;
        break; // one line a time!!!
      }
    }
    // find nearest median2median line instead
    // if no overlapped
    if(!overlapped){
      int index = 0;
      float shortestDist=0;
      float medianX = (firstPath[0].x+firstPathEnd.x)/2;
      float medianY = (firstPath[0].y+firstPathEnd.y)/2;
      RPoint firstPathMedian = new RPoint(medianX,medianY);
      for(int i=0;i<startEnd.size();i++){
        medianX = (startEnd.get(i)[0].x+startEnd.get(i)[1].x)/2;
        medianY = (startEnd.get(i)[0].y+startEnd.get(i)[1].y)/2;
        RPoint imedian = new RPoint(medianX,medianY);
        if(i==0){
          shortestDist = firstPathMedian.dist(imedian);
          index = 0;
        }
        else if(firstPathMedian.dist(imedian)<shortestDist){
          shortestDist = firstPathMedian.dist(imedian);
          index = i;
        }   
      }
      firstPath = pathsList.remove(index);
      sortedPaths[j]=firstPath;
      startEnd.remove(index);
    }
    j++;
  }
  return sortedPaths; //<>// //<>//
}
public boolean checkOverlapped(RPoint p1, RPoint p2){
  // ignore very small deviation!!!! //<>//
  if(round(abs(p1.x-p2.x))==0 && round(abs(p1.y-p2.y)) == 0){
    return true;
  }
  else{
    return false;
  }
}

public RPoint[][] sortPathsLongestFirst(RPoint[][] pointPaths, int highPassCutoff)
{
  // put the paths into a list
  List<RPoint[]> pathsList = new ArrayList<RPoint[]>(pointPaths.length);
  for (int i = 0; i<pointPaths.length; i++)
  {
    if (pointPaths[i] != null) 
    {
      pathsList.add(pointPaths[i]);
    }
  }

  // sort the list
  Collections.sort(pathsList, new Comparator<RPoint[]>() {
    public int compare(RPoint[] o1, RPoint[] o2) {
      if (o1.length > o2.length) {
        return -1;
      } 
      else if (o1.length < o2.length) {
        return 1;
      } 
      else {
        return 0;
      }
    }
  }
  );

  // filter out some short paths
  pathsList = removeShortPaths(pathsList, highPassCutoff);

  // and put them into a new array
  for (int i=0; i<pathsList.size(); i++)
  {
    pointPaths[i] = pathsList.get(i);
  }

  return pointPaths;
}

public RPoint[][] sortPathsGreatestAreaFirst(RShape vec, int highPassCutoff)
{
  // put the paths into a list
  SortedMap<Float, RPoint[]> pathsList = new TreeMap<Float, RPoint[]>();

  int noOfChildren = vec.countChildren();
  for (int i=0; i < noOfChildren; i++)
  {
    float area = vec.children[i].getArea();
    RPoint[] path = vec.children[i].getPointsInPaths()[0];
    pathsList.put(area, path);
  }

  RPoint[][] pointPaths = vec.getPointsInPaths();  
  List<RPoint[]> filtered = new ArrayList<RPoint[]>();
  
  // and put them into a new array
  int i = 0;
  for (Float k : pathsList.keySet())
  {
    if (k >= highPassCutoff)
    {
      filtered.add(pathsList.get(k));
      println("Filtered kept path of area " + k);
    }
    else
      println("Filtered discarded path of area " + k);
  }
  
  pointPaths = new RPoint[filtered.size()][];
  for (i = 0; i < filtered.size(); i++)
  {
    pointPaths[i] = filtered.get(i);
  }

  return pointPaths;
}

public RPoint[][] sortPathsCentreFirst(RShape vec, int highPassCutoff)
{
  // put the paths into a list
  int noOfChildren = vec.countChildren();
  List<RShape> pathsList = new ArrayList<RShape>(noOfChildren);
  for (int i=0; i < noOfChildren; i++)
    pathsList.add(vec.children[i]);
  List<RShape> orderedPathsList = new ArrayList<RShape>(noOfChildren);

  // make a tiny area in the centre of the shape,
  // plan to increment the size of the area until it covers vec entirely
  // (radius of area min = 0, max = distance from shape centre to any corner.)
  
  float aspectRatio = vec.getHeight() / vec.getWidth();
  int n = 0;
  float w = 1.0;
  float h = w * aspectRatio;
  
  RPoint topLeft = vec.getTopLeft();
  RPoint botRight = vec.getBottomRight();
  
  PVector centre = new PVector(vec.getWidth()/2, vec.getHeight()/2);

  float vecWidth = vec.getWidth();
  
  while (w <= vecWidth)
  {
    w+=6.0;
    h = w * aspectRatio;
    
    //println(n++ + ". Rect w " + w + ", h " + h);
    RShape field = RShape.createRectangle(centre.x-(w/2.0), centre.y-(h/2.0), w, h);
    // add all the shapes that are entirely inside the circle to orderedPathsList
    ListIterator<RShape> it = pathsList.listIterator();
    int shapesAdded = 0;
    while (it.hasNext())
    {
      RShape sh = it.next();
      if (field.contains(sh.getCenter()))
      {
        orderedPathsList.add(sh);
        // remove the shapes from pathsList (so it isn't found again)
        shapesAdded++;
        it.remove();
      }
    }
    // increase the size of the circle and try again
  }

  RPoint[][] pointPaths = new RPoint[orderedPathsList.size()][];// vec.getPointsInPaths();
  for (int i = 0; i < orderedPathsList.size(); i++)
  {
    pointPaths[i] = orderedPathsList.get(i).getPointsInPaths()[0];
  }

  return pointPaths;
}


List<RPoint[]> removeShortPaths(List<RPoint[]> list, int cutoff)
{
  if (cutoff > 0)
  {
    int numberOfPaths = list.size();
    ListIterator<RPoint[]> it = list.listIterator();
    while (it.hasNext ())
    {
      RPoint[] paths = it.next();
      if (paths == null || cutoff >= paths.length)
      {
        it.remove();
      }
    }
  }
  return list;
}  

List<PVector> filterPoints(RPoint[] points, int filterToUse, long filterParam, float scaling, PVector position)
{
  return filterPointsLowPass(points, filterParam, scaling, position);
}

// process the points: scale back, translate from Cartisian Coordinates to Polar Coordinates, translate from mm to Steps
List<PVector> filterPointsLowPass(RPoint[] points, long filterParam, float scaling, PVector position) // vector position which is in MM
{
  List<PVector> result = new ArrayList<PVector>();
  // scale and convert all the points first
  List<PVector> scaled = new ArrayList<PVector>(points.length);
  for (int j = 0; j<points.length; j++)
  {
    RPoint firstPoint = points[j];
    PVector p = new PVector(firstPoint.x, firstPoint.y);
    p = PVector.mult(p, scaling);  // needed to convert into MM first!!!
    p = PVector.mult(p, mmPerPixel);
    p = PVector.add(p, position);
    if (getDisplayMachine().getPictureFrame().surrounds(p))
    {
      p = getDisplayMachine().asNativeCoords(p); // also calculation in MM
      p = getDisplayMachine().inSteps(p); // in steps, ready to be out
      scaled.add(p);
    }
  }

  if (scaled.size() > 1)
  {
    PVector p = scaled.get(0);
    result.add(p);

    for (int j = 1; j<scaled.size(); j++)
    {
      p = scaled.get(j);
      // and even then, only bother drawing if it's a move of over "x" steps
      int diffx = int(p.x) - int(result.get(result.size()-1).x);
      int diffy = int(p.y) - int(result.get(result.size()-1).y);
      // ignore too small length lines and repeated points!!!
      if (abs(diffx) > filterParam || abs(diffy) > filterParam)
      {
        //println("Adding point " + p + ", last: " + result.get(result.size()-1));
        result.add(p);
      }
    }
  }

  if (result.size() < 2)
    result.clear();

  //println("finished filter.");
  return result;
}
/* -------------------------------- related to vector drawing ------------------------*/
