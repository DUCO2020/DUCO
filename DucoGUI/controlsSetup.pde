void welcomeControlsSetup(){
    // text labels
    welcomeControls.add(welcomeProjectTitle);
    welcomeControls.add(welcomeSubType);
    welcomeControls.add(welcomeSerialPort);
    welcomeControls.add(welcomeMachineW);
    welcomeControls.add(welcomeMachineH);
    welcomeControls.add(welcomeCanvasW);
    welcomeControls.add(welcomeCanvasH);
    welcomeControls.add(welcomePenPosition); 
    welcomeControls.add(welcomeP1); 
    welcomeControls.add(welcomeP2); 
    welcomeControls.add(welcomeP3); 
    
    // text fields
    welcomeControls.add(welcomeMachineW_t);
    welcomeControls.add(welcomeMachineH_t);
    welcomeControls.add(welcomeCanvasW_t);
    welcomeControls.add(welcomeCanvasH_t);
    
    // dropdown list
    welcomeControls.add(welcomeSubSelect);
    welcomeControls.add(welcomeSerialSelect);
    welcomeControls.add(welcomeP1Select); 
    welcomeControls.add(welcomeP2Select); 
    welcomeControls.add(welcomeP3Select);
    
    // buttons
    welcomeControls.add(welcomeCreate);
    welcomeControls.add(welcomeOpenFile); 
    welcomeControls.add(welcomePosInfo); 
    //welcomeControls.add(welcomePosInfoPic); 
}

void drawControlsSetup(){
    // text labels
    drawControls.add(drawMachineArea);
    drawControls.add(drawMachineAreaW);
    drawControls.add(drawMachineAreaH);
    drawControls.add(drawCanvas);
    drawControls.add(drawCanvasW);
    drawControls.add(drawCanvasH);
    drawControls.add(drawHomePoint);
    drawControls.add(drawHomePointH);
    drawControls.add(drawVector);
    drawControls.add(drawVectorW);
    drawControls.add(drawVectorH);
    drawControls.add(drawVectorX);
    drawControls.add(drawVectorY);
    drawControls.add(drawVectorRatio);
    drawControls.add(drawDraw);
    drawControls.add(drawCurPos);
    drawControls.add(drawBasic);
    
    // text fields
    drawControls.add(drawMachineAreaW_t);
    drawControls.add(drawMachineAreaH_t);
    drawControls.add(drawCanvasW_t);
    drawControls.add(drawCanvasH_t);
    drawControls.add(drawHomePointH_t);
    drawControls.add(drawVectorW_t);
    drawControls.add(drawVectorH_t);
    drawControls.add(drawVectorX_t);
    drawControls.add(drawVectorY_t);
    drawControls.add(drawVectorRatio_t);

    // buttons
    drawControls.add(drawUpload);
    drawControls.add(drawClear);
    drawControls.add(drawStart);
    drawControls.add(drawTab);
    drawControls.add(testTab);
    drawControls.add(drawChangeFile);
    drawControls.add(drawBasicUpload);
    drawControls.add(drawSwitch);
    
    // dialogues
    drawControls.add(advancedSettings);
    drawControls.add(save);  // save/save as
    drawControls.add(savePanel);
    drawControls.add(savePanel_save);
    drawControls.add(savePanel_saveAs);
    drawControls.add(savePanel_load);
    
    // seems to be duplicate of drawTab/testTab ??
    drawControls.add(drawClickTab); 
    drawControls.add(testClickTab);

    // dropdown list
    drawControls.add(drawCurPosSelect);
    // labels
    drawControls.add(drawPenPos);
    drawControls.add(drawPenPosD);
    // text fields
    drawControls.add(drawPenPosD_t);
    // button
    drawControls.add(drawPenPosTest);
    drawControls.add(drawGood);
}

void vectorControlsSetup(){
    vectorControls.add(drawVectorW_t);
    vectorControls.add(drawVectorH_t);
    vectorControls.add(drawVectorX_t);
    vectorControls.add(drawVectorY_t);
    vectorControls.add(drawVectorRatio_t);
    vectorControls.add(drawUpload);
    vectorControls.add(drawClear);
    vectorControls.add(drawStart);

    vectorControls.add(drawVector);
    vectorControls.add(drawVectorW);
    vectorControls.add(drawVectorH);
    vectorControls.add(drawVectorX);
    vectorControls.add(drawVectorY);
    vectorControls.add(drawVectorRatio);
    vectorControls.add(drawChangeFile);

}

void drawTestControlsSetup(){
    drawTestControls.add(drawPenPos);
    drawTestControls.add(drawPenPosD);
    drawTestControls.add(drawPenPosD_t);
    drawTestControls.add(drawPenPosTest);
    drawTestControls.add(drawGood);
}


void testControlsSetup(){
    // labels
    testControls.add(testPos);
    testControls.add(testPosCap);
    testControls.add(testPosX);
    testControls.add(testPosY);
    testControls.add(testVal);
    testControls.add(testValCap);
    // text fields
    testControls.add(testPenPosX_t);
    testControls.add(testPenPosY_t);
    testControls.add(testVal_t);
    // buttons
    testControls.add(testPosTest);
    testControls.add(testValTest);
    testControls.add(testGood);
    

    // testControls.add(testDir);
    // testControls.add(testDirCap);
    // testControls.add(testP1);
    // testControls.add(testP1X);
    // testControls.add(testP1Y);

    // testControls.add(testP1X_t);
    // testControls.add(testP1Y_t);
    // testControls.add(testP2);
    // testControls.add(testP2X);
    // testControls.add(testP2Y);
    // testControls.add(testP2X_t);
    // testControls.add(testP2Y_t);
    // testControls.add(testDirTest);
    
    // tabs
    testControls.add(drawTab);
    testControls.add(testTab);
    
    // dialogues
    testControls.add(advancedSettings);
    testControls.add(save);
}

void setupAllControls(){
    allControls = new ArrayList<Controller>();
    for(Controller c: welcomeControls){
        allControls.add(c);
    }

    for(Controller c: drawControls){
        allControls.add(c);
    }
    for(Controller c: testControls){
        allControls.add(c);
    }
}



List<Controller> getAllControls()
{
  if (this.allControls == null)
    //this.allControls = buildAllControls();\
    setupAllControls();
  return this.allControls;
}
