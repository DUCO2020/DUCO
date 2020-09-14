/**
*  DUCO - CORE
*  robost communication enabling 2 times resend logic if failued.
*  After 3 times failure of parsing a comm. Jump to next
*/

boolean comms_waitForNextCommand(char *buf)
{
  // send ready
  // wait for instruction
  long idleTime = millis();
  int bufPos = 0;
  for (int i = 0; i<INLENGTH; i++) {
    buf[i] = 0;
  }  
  long lastRxTime = 0L;
  boolean terminated = false;
  while (!terminated)
  { 
    long timeSince = millis() - lastRxTime;
    
    // the buffer hasn't received a new char in less than 150ms
    // and this string is being filled! just without a '\n' as terminator
    // probably transmission failed, ask for resend
    if (bufPos!=0 && timeSince > 150)
    {
      // Clear the buffer and reset the position if it took too long
      for (int i = 0; i<INLENGTH; i++) {
        buf[i] = 0;
      }
      bufPos = 0;
      //only resend 2 times
      if(numberResend<2){
        comms_requestResend();
        numberResend++;
      }
      // multiple times of failure 
      // then skip this command
      else{
        comms_ready(); //skip
        numberResend=0; //reinitialization
      }
    }
    
    // in Microstepping, steppers' torque will be lost when powering down
    // so keep it uncomment
    //impl_runBackgroundProcesses();

    // if buffer being cleared by time out
    // then this will trigger another round of command receive
    timeSince = millis() - idleTime;
    if (timeSince > rebroadcastReadyInterval)
    {
      // issue a READY every 5000ms
      comms_ready();  // issue ready
      idleTime = millis();
    }
    
    // And now read the command if one exists.
    if (Serial.available() > 0)
    {
      // Get the char
      char ch = Serial.read();
      //if it's a terminator, then lets terminate the string
      if (ch == INTERMINATOR || ch == SEMICOLON) {
        buf[bufPos] = 0; // null terminate the string
        // no need to bypass "\n" now
        terminated = true; 
        for (int i = bufPos; i<INLENGTH-1; i++) {
          buf[i] = 0;
        }
      } else {
        // otherwise, just add it into the buffer
        buf[bufPos] = ch;
        bufPos++;
      }
      lastRxTime = millis(); // new RXtime
    }
  }

  idleTime = millis();
  lastOperationTime = millis();
  lastInteractionTime = lastOperationTime;
  return true;
}

void comms_parseAndExecuteCommand(char *inS)
{
  boolean commandParsed = comms_parseCommand(inS); // after which parameters and cmd are all ready!!
  // parsing check whether the cmd is legal
  // ending with ",END"
  if (commandParsed) 
  {
    // unknown comm check i.e.  if unknown, output error msg and return false
    if(impl_processCommand(lastCommand)){
      comms_ready();  // if executed, then send "ready" to let processing give next cmd
      // clear failure history, once it's executed
      numberResend=0;
    }
    else{
      //only resend 2 times
      if(numberResend<2){
        comms_requestResend();
        numberResend++;
      }
      // multiple times of failure 
      // then skip this command
      else{
        comms_ready(); //skip
        numberResend=0; //reinitialization
      }
    }
    
    // no need!! comms_waitForNextCommand will do this
    //for (int i = 0; i<INLENGTH; i++) { inS[i] = 0; }  //reset!! 
    commandConfirmed = false; 
  }
  else
  {
    // parsing failure caused by missing ",END"
    Serial.print(MSG_E_STR);
    Serial.print(F("Comm ("));
    Serial.print(inS);
    Serial.println(F(") not parsed."));
    //only resend 2 times
    if(numberResend<2){
      comms_requestResend();
      numberResend++;
    }
    // multiple times of failure 
    // then skip this command
    else{
      comms_ready(); //skip
      numberResend=0; //reinitialization
    }
  }
  inNoOfParams = 0;
}

// I don't think parse CMD_END out is needed
// since lastCommand should look like "CXX,xxx,xx,END\0\0\0\0\0\0\0\0\0\...."
// but still keep the original logic
boolean comms_parseCommand(char *inS)
{
  // strstr returns a pointer to the location of ",END" in the incoming string (inS).
  char* sub = strstr(inS, CMD_END); // find first occurence of CMD_END and return pointer pointed to it
  if(sub==NULL){
    return false;  // this cmd isn't complete
  }
  else{
    sub[strlen(CMD_END)] = 0; // terminate string after ",END"
    comms_extractParams(inS); //extract cmd and parameters
    return true;
  }
}  

// use inCmd to specify cmd kind and use inParam to assign global variables
void comms_extractParams(char* inS) 
{
  char in[strlen(inS)];
  strcpy(in, inS);
  char * param;
  byte paramNumber = 0;
  param = strtok(in, COMMA); // split in with "," return first token
  
  inParam1[0] = 0;
  inParam2[0] = 0;
  inParam3[0] = 0;
  inParam4[0] = 0;
  
  for (byte i=0; i<6; i++) {
      if (i == 0) {
        strcpy(inCmd, param); // inCmd contains the head looking like "C0X"
                              // actually not used since exec use StartsWith method to detect command kind
      }
      else {
        param = strtok(NULL, COMMA); // keep splitting with in
        if (param != NULL) {
          if (strstr(CMD_END, param) == NULL) {
            // It's not null AND it wasn't 'END' either
            paramNumber++;
          }
        }
        
        switch(i)
        {
          case 1:
            if (param != NULL) strcpy(inParam1, param);
            break;
          case 2:
            if (param != NULL) strcpy(inParam2, param);
            break;
          case 3:
            if (param != NULL) strcpy(inParam3, param);
            break;
          case 4:
            if (param != NULL) strcpy(inParam4, param);
            break;
          default:
            break;
        }
      }
  }
  inNoOfParams = paramNumber;
}


void comms_ready()
{
  // println will give a '\n' as terminator
  Serial.println(F(READY_STR)); // will be displayed on processing Serial Monitor
}
void comms_drawing()
{
  Serial.println(F(DRAWING_STR));
}
void comms_requestResend()
{
  Serial.println(F(RESEND_STR));
}
void comms_unrecognisedCommand(String &com)
{
  Serial.print(MSG_E_STR);
  Serial.print(com);
  Serial.println(F(" not recognised."));
}  
