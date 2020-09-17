void setupWelcomePage(){
    welcomeProjectTitle = cp5.addTextlabel("welcomeProjectTitle")
                    .setText("Large Scale Drawing System")
                    .setPosition(148,167)
                    .setColorValue(#000000)
                    .setFont(projectTitle)
                    ;
    welcomeSubType = cp5.addTextlabel("welcomeSubType")
                    .setText("Substrate type")
                    .setPosition(161,260)
                    .setColorValue(capation)
                    .setFont(subTitle)
                    ;
    welcomeSerialPort = cp5.addTextlabel("welcomeSerialPort")
                    .setText("Serial port")
                    .setPosition(378,260)
                    .setColorValue(capation)
                    .setFont(subTitle)
                    ;
    welcomeMachineW = cp5.addTextlabel("welcomeMachineW")
                    .setText("Machine area width")
                    .setPosition(161,335)
                    .setColorValue(capation)
                    .setFont(subTitle)
                    ;
    welcomeMachineH = cp5.addTextlabel("welcomeMachineH")
                    .setText("Machine area height")
                    .setPosition(378,335)
                    .setColorValue(capation)
                    .setFont(subTitle)
                    ;
    welcomeCanvasW = cp5.addTextlabel("welcomeCanvasW")
                    .setText("Canvas width")
                    .setPosition(161,410)
                    .setColorValue(capation)
                    .setFont(subTitle)
                    ;
    welcomeCanvasH = cp5.addTextlabel("welcomeCanvasH")
                    .setText("Canvas height")
                    .setPosition(378,410)
                    .setColorValue(capation)
                    .setFont(subTitle)
                    ;
    welcomePenPosition = cp5.addTextlabel("welcomePenPosition")
                    .setText("Pen position")
                    .setPosition(161,500)
                    .setColorValue(#000000)
                    .setFont(title)
                    ;
    welcomeP1 = cp5.addTextlabel("welcomeP1")
                    .setText("Position1")
                    .setPosition(161,532)
                    .setColorValue(capation)
                    .setFont(subTitle)
                    ;                    
    welcomeP2 = cp5.addTextlabel("welcomeP2")
                    .setText("Position2")
                    .setPosition(378,532)
                    .setColorValue(capation)
                    .setFont(subTitle)
                    ;
    welcomeP3 = cp5.addTextlabel("welcomeP3")
                    .setText("Position3")
                    .setPosition(161,607)
                    .setColorValue(capation)
                    .setFont(subTitle)
                    ;



    welcomeMachineW_t = cp5.addTextfield("welcomeMachineW_t")
                        .setPosition(161,362)
                        .setSize(208,40)
                        .setCaptionLabel("")
                        .setColorBackground(#ffffff)
                        .setColorForeground(menu_color)
                        .setFocus(false)
                        .setAutoClear(false)
                        .setColor(#000000)
                        .setFont(wh);
    welcomeMachineH_t = cp5.addTextfield("welcomeMachineH_t")
                        .setPosition(378,362)
                        .setSize(208,40)
                        .setCaptionLabel("")
                        .setColorBackground(#ffffff)
                        .setColorForeground(menu_color)
                        .setFocus(false)
                        .setAutoClear(false)
                        .setColor(#000000)
                        .setFont(wh);
    welcomeCanvasW_t = cp5.addTextfield("welcomeCanvasW_t")
                        .setPosition(161,437)
                        .setSize(208,40)
                        .setCaptionLabel("")
                        .setColorBackground(#ffffff)
                        .setColorForeground(menu_color)
                        .setFocus(false)
                        .setAutoClear(false)
                        .setColor(#000000)
                        .setFont(wh);
    welcomeCanvasH_t = cp5.addTextfield("welcomeCanvasH_t")
                        .setPosition(378,437)
                        .setSize(208,40)
                        .setCaptionLabel("")
                        .setColorBackground(#ffffff)
                        .setColorForeground(menu_color)
                        .setFocus(false)
                        .setAutoClear(false)
                        .setColor(#000000)
                        .setFont(wh);

    welcomeCreate = cp5.addButton("welcomeCreate")
                    .setPosition(153,714)
                    .setSize(425,40)
                    .setImages(loadImage("create.png"), loadImage("create.png"), loadImage("create.png"))
                    .updateSize();
    welcomeOpenFile = cp5.addButton("welcomeOpenFile")
                    .setPosition(33,28)
                    .setSize(168,24)
                    .setImages(loadImage("openfile.png"), loadImage("openfile.png"), loadImage("openfile.png"))
                    .updateSize();
    welcomePosInfo = cp5.addButton("welcomePosInfo")
                    .setPosition(274,500)
                    .setSize(24,24)
                    .setImages(loadImage("Info.png"), loadImage("Info.png"), loadImage("Info.png"))
                    .updateSize();    


    welcomeSubSelect = cp5.addDropdownList("welcomeSubSelect")
                    .setPosition(161,287)
                    .setSize(208,200)
                    //.setBackgroundColor(background_color)
                    .setColorBackground(menu_color)
                    .setCaptionLabel("")
                    .addItem("Arcrylic",0)
                    .addItem("Glass",1)
                    .addItem("Wall paint",2)
                    .addItem("Wall paper",3)
                    .addItem("Wood",4)
                    .addItem("Ceramic",5)
                    .addItem("*Photo paper*",6)
                    .setItemHeight(30)
                    .setBarHeight(30)
                    .setColorValue(#000000)
                    .setColorLabel(#000000)
                    .setFont(listTitle)
                    .close();
    welcomeSerialSelect = cp5.addDropdownList("welcomeSerialSelect")
                    .setPosition(378,287)
                    .setSize(208,200)
                    //.setBackgroundColor(background_color)
                    .setColorBackground(menu_color)
                    .setCaptionLabel("")
                    .addCallback(serialCB)
                    //.addItem("COM1",0)
                    //.addItem("COM2",1)
                    //.addItem("COM3",2)
                    .setItemHeight(30)
                    .setBarHeight(30)
                    .setColorValue(#000000)
                    .setColorLabel(#000000)
                    .setFont(listTitle)
                    .close(); 
    welcomeP3Select = cp5.addDropdownList("welcomeP3Select")
                    .setPosition(161,634)
                    .setSize(208,160)
                    //.setBackgroundColor(background_color)
                    .setColorBackground(menu_color)
                    .setCaptionLabel("")
                    .addItem("Pen",0)
                    .addItem("Laser Cutter",1)
                    .addItem("Pen force",2)
                    .setItemHeight(30)
                    .setBarHeight(30)
                    .setColorValue(#000000)
                    .setColorLabel(#000000)
                    .setFont(listTitle)
                    .close();  
    welcomeP2Select = cp5.addDropdownList("welcomeP2Select")
                    .setPosition(378,559)
                    .setSize(208,160)
                    //.setBackgroundColor(background_color)
                    .setColorBackground(menu_color)
                    .setCaptionLabel("")
                    .addItem("Pen",0)
                    .addItem("Laser Cutter",1)
                    .addItem("Pen force",2)
                    .setItemHeight(30)
                    .setBarHeight(30)
                    .setColorValue(#000000)
                    .setColorLabel(#000000)
                    .setFont(listTitle)
                    .close();  
    welcomeP1Select = cp5.addDropdownList("welcomeP1Select")
                    .setPosition(161,559)
                    .setSize(208,160)
                    //.setBackgroundColor(background_color)
                    .setColorBackground(menu_color)
                    .setCaptionLabel("")
                    .addItem("Pen",0)
                    .addItem("Laser Cutter",1)
                    .addItem("pen force",2)
                    .setItemHeight(30)
                    .setBarHeight(30)
                    .setColorValue(#000000)
                    .setColorLabel(#000000)
                    .setFont(listTitle)
                    .close(); 
    welcomePosInfoPic = cp5.addButton("welcomePosInfoPic")
                    .setPosition(306,502)
                    .setSize(280,124)
                    .setImages(loadImage("info_position.png"), loadImage("info_position.png"), loadImage("info_position.png"))
                    .updateSize();     

}

void setupDrawPage(){
    drawMachineArea = cp5.addTextlabel("drawMachineArea")
                    .setText("Machine area")
                    .setPosition(24,107)
                    .setSize(109,24)
                    .setColorValue(#000000)
                    .setFont(f14);
    drawMachineAreaW = cp5.addTextlabel("drawMachineAreaW")
                    .setText("w")
                    .setPosition(24,140)
                    .setSize(14,24)
                    .setColorValue(capation)
                    .setFont(f14);
    drawMachineAreaH = cp5.addTextlabel("drawMachineAreaH")
                    .setText("h")
                    .setPosition(140,140)
                    .setSize(14,24)
                    .setColorValue(capation)
                    .setFont(f14);
    drawCanvas = cp5.addTextlabel("drawCanvas")
                    .setText("Canvas")
                    .setPosition(24,183)
                    .setSize(109,24)
                    .setColorValue(#000000)
                    .setFont(f14);
    drawCanvasW = cp5.addTextlabel("drawCanvasW")
                    .setText("w")
                    .setPosition(24,216)
                    .setSize(14,24)
                    .setColorValue(capation)
                    .setFont(f14);
    drawCanvasH = cp5.addTextlabel("drawCanvasH")
                    .setText("h")
                    .setPosition(140,216)
                    .setSize(14,24)
                    .setColorValue(capation)
                    .setFont(f14);
    drawHomePoint = cp5.addTextlabel("drawHomePoint")
                    .setText("Home point")
                    .setPosition(24,264)
                    .setSize(109,24)
                    .setColorValue(#000000)
                    .setFont(f14);
    drawHomePointH = cp5.addTextlabel("drawHomePointH")
                    .setText("height")
                    .setPosition(24,295)
                    .setSize(41,28)
                    .setColorValue(capation)
                    .setFont(f14);
    drawVector = cp5.addTextlabel("drawVector")
                    .setText("Vector")
                    .setPosition(24,536)
                    .setSize(78,24)
                    .setColorValue(#000000)
                    .setFont(f14);
    drawVectorW = cp5.addTextlabel("drawVectorW")
                    .setText("w")
                    .setPosition(24,571)
                    .setSize(14,24)
                    .setColorValue(capation)
                    .setFont(f14);
    drawVectorH = cp5.addTextlabel("drawVectorH")
                    .setText("h")
                    .setPosition(140,571)
                    .setSize(14,24)
                    .setColorValue(capation)
                    .setFont(f14);
    drawVectorX = cp5.addTextlabel("drawVectorX")
                    .setText("x")
                    .setPosition(24,618)
                    .setSize(14,24)
                    .setColorValue(capation)
                    .setFont(f14);
    drawVectorY = cp5.addTextlabel("drawVectorY")
                    .setText("y")
                    .setPosition(140,618)
                    .setSize(14,24)
                    .setColorValue(capation)
                    .setFont(f14);
    drawVectorRatio = cp5.addTextlabel("drawVectorRatio")
                    .setText("ratio")
                    .setPosition(24,663)
                    .setSize(30,28)
                    .setColorValue(capation)
                    .setFont(f14);
    drawDraw= cp5.addTextlabel("drawDraw")
                    .setText("DRAW")
                    .setPosition(24,396)
                    .setSize(139,25)
                    .setColorValue(#367BF5)
                    .setFont(f14);
    drawBasic= cp5.addTextlabel("drawBasic")
                    .setText("BASIC PARAMETERS")
                    .setPosition(26,60)
                    .setSize(139,25)
                    .setColorValue(#367BF5)
                    .setFont(f14);

    drawMachineAreaW_t = cp5.addTextfield("drawMachineAreaW_t")
                        .setPosition(41,133)
                        .setSize(94,38)
                        .setCaptionLabel("")
                        .setColorBackground(#ffffff)
                        .setColorForeground(menu_color)
                        .setFocus(false)
                        .setAutoClear(false)
                        .setColor(#000000)
                        .setFont(wh);
    drawMachineAreaH_t = cp5.addTextfield("drawMachineAreaH_t")
                        .setPosition(157,133)
                        .setSize(94,38)
                        .setCaptionLabel("")
                        .setColorBackground(#ffffff)
                        .setColorForeground(menu_color)
                        .setFocus(false)
                        .setAutoClear(false)
                        .setColor(#000000)
                        .setFont(wh);
    drawCanvasW_t = cp5.addTextfield("drawCanvasW_t")
                        .setPosition(41,209)
                        .setSize(94,38)
                        .setCaptionLabel("")
                        .setColorBackground(#ffffff)
                        .setColorForeground(menu_color)
                        .setFocus(false)
                        .setAutoClear(false)
                        .setColor(#000000)
                        .setFont(wh);
    drawCanvasH_t = cp5.addTextfield("drawCanvasH_t")
                        .setPosition(157,209)
                        .setSize(94,38)
                        .setCaptionLabel("")
                        .setColorBackground(#ffffff)
                        .setColorForeground(menu_color)
                        .setFocus(false)
                        .setAutoClear(false)
                        .setColor(#000000)
                        .setFont(wh);
    drawHomePointH_t = cp5.addTextfield("drawHomePointH_t")
                        .setPosition(72,290)
                        .setSize(179,38)
                        .setCaptionLabel("")
                        .setColorBackground(#ffffff)
                        .setColorForeground(menu_color)
                        .setFocus(false)
                        .setAutoClear(false)
                        .setColor(#000000)
                        .setFont(wh);
    drawVectorW_t = cp5.addTextfield("drawVectorW_t")
                        .setPosition(41,564)
                        .setSize(91,38)
                        .setCaptionLabel("")
                        .setColorBackground(#ffffff)
                        .setColorForeground(menu_color)
                        .setFocus(false)
                        .setAutoClear(false)
                        .setColor(#000000)
                        .setFont(wh);
    drawVectorH_t = cp5.addTextfield("drawVectorH_t")
                        .setPosition(157,564)
                        .setSize(94,38)
                        .setCaptionLabel("")
                        .setColorBackground(#ffffff)
                        .setColorForeground(menu_color)
                        .setFocus(false)
                        .setAutoClear(false)
                        .setColor(#000000)
                        .setFont(wh);
    drawVectorX_t = cp5.addTextfield("drawVectorX_t")
                        .setPosition(41,611)
                        .setSize(91,38)
                        .setCaptionLabel("")
                        .setColorBackground(#ffffff)
                        .setColorForeground(menu_color)
                        .setFocus(false)
                        .setAutoClear(false)
                        .setColor(#000000)
                        .setFont(wh);
    drawVectorY_t = cp5.addTextfield("drawVectorY_t")
                        .setPosition(157,611)
                        .setSize(94,38)
                        .setCaptionLabel("")
                        .setColorBackground(#ffffff)
                        .setColorForeground(menu_color)
                        .setFocus(false)
                        .setAutoClear(false)
                        .setColor(#000000)
                        .setFont(wh);
    drawVectorRatio_t = cp5.addTextfield("drawVectorRatio_t")
                        .setPosition(59,658)
                        .setSize(192,38)
                        .setCaptionLabel("")
                        .setColorBackground(#ffffff)
                        .setColorForeground(menu_color)
                        .setFocus(false)
                        .setAutoClear(false)
                        .setColor(#000000)
                        .setFont(wh);
    drawUpload = cp5.addButton("drawUpload")
                    .setPosition(30,774)
                    .setSize(110,40)
                    .setImages(loadImage("draw_upload.png"), loadImage("draw_upload.png"), loadImage("draw_upload.png"));    
    drawClear = cp5.addButton("drawClear")
                    .setPosition(147,774)
                    .setSize(105,40)
                    .setImages(loadImage("draw_clear.png"), loadImage("draw_clear.png"), loadImage("draw_clear.png"));    
    drawStart = cp5.addButton("drawStart")
                    .setPosition(22,825)
                    .setSize(224,40)
                    .setImages(loadImage("draw_start.png"), loadImage("draw_start.png"), loadImage("draw_start.png")); 
    drawTab = cp5.addButton("drawTab")
                    .setPosition(312,23)
                    .setImages(loadImage("draw.png"), loadImage("draw.png"), loadImage("draw.png"))
                                        .updateSize();  
    testTab = cp5.addButton("testTab")
                    .setPosition(418,23)
                    .setImages(loadImage("test.png"), loadImage("test.png"), loadImage("test.png"))
                    .setSize(85,56);
    advancedSettings = cp5.addButton("advancedSettings")
                    .setPosition(1381,5)
                    .setSize(40,40)
                    .setImages(loadImage("settings.png"), loadImage("settings.png"), loadImage("settings.png"));                                      


    drawBasicUpload = cp5.addButton("drawBasicUpload")
                    .setPosition(197,345)
                    .setSize(59,24)
                    .setImages(loadImage("draw_subupload.png"), loadImage("draw_subupload.png"), loadImage("draw_subupload.png"));    
    drawSwitch = cp5.addButton("drawSwitch")
                    .setPosition(200,445)
                    .setSize(53,24)
                    .setImages(loadImage("switch.png"), loadImage("switch.png"), loadImage("switch.png"));    

    drawChangeFile = cp5.addButton("drawChangeFile")
                    .setPosition(145,540)
                    .setSize(94,24)
                    .setImages(loadImage("uploadVector.png"), loadImage("uploadVector.png"), loadImage("uploadVector.png")); 

    save = cp5.addButton("save")
                    .setPosition(26,21)
                    .setImages(loadImage("save.png"), loadImage("save.png"), loadImage("save.png"))
                    .updateSize(); 

    drawCurPos = cp5.addTextlabel("drawCurPos")
                    .setText("Current Position")
                    .setPosition(24,439)
                    .setSize(168,24)
                    .setColorValue(#000000)
                    .setFont(f14);


    drawClickTab = cp5.addButton("drawClickTab")
                    .setPosition(275,0)
                    .setImages(loadImage("draw_click.png"), loadImage("draw_click.png"), loadImage("draw_click.png"))
                    .setSize(104,56);  
    testClickTab = cp5.addButton("testClickTab")
                    .setPosition(379,-4)
                    .setImages(loadImage("test_click.png"), loadImage("test_click.png"), loadImage("test_click.png"))
                    .setSize(104,56);
    drawPenPos = cp5.addTextlabel("drawPenPos")
                    .setText("Test current position")
                    .setPosition(24,555)
                    .setSize(182,24)
                    .setColorValue(#000000)
                    .setFont(f14);
    drawPenPosD = cp5.addTextlabel("drawPenPosD")
                    .setText("val")
                    .setPosition(24,595)
                    .setSize(18,18)
                    .setColorValue(#000000)
                    .setFont(f14);  
    drawPenPosD_t = cp5.addTextfield("drawPenPosD_t")
                        .setPosition(50,587)
                        .setSize(195,40)
                        .setCaptionLabel("")
                        .setColorBackground(#ffffff)
                        .setColorForeground(menu_color)
                        .setFocus(false)
                        .setAutoClear(false)
                        .setColor(#000000)
                        .setFont(wh);
    drawPenPosTest = cp5.addButton("drawPenPosTest")
                    .setPosition(50,640)
                    .setSize(203,40)
                    .setImages(loadImage("penpostest.png"), loadImage("penpostest.png"), loadImage("penpostest.png"));    
    drawGood = cp5.addButton("drawGood")
                    .setPosition(40,700)
                    .setSize(203,40)
                    .setImages(loadImage("good.png"), loadImage("good.png"), loadImage("good.png"));  
    drawCurPosSelect = cp5.addDropdownList("drawCurPosSelect")
                    .setPosition(24,471)
                    .setSize(229,160)
                    //.setBackgroundColor(background_color)
                    .setColorBackground(menu_color)
                    .setCaptionLabel("")
                    .addItem("Linear Actuator",0)
                    .addItem("Laser Cutter",1)
                    .addItem("Pen Force",2)
                    .setItemHeight(30)
                    .setBarHeight(30)
                    .setColorValue(#000000)
                    .setColorLabel(#000000)
                    .setFont(listTitle)
                    .close();


                                        
}

void setupTestPage(){

    testPos = cp5.addTextlabel("testPos")
                    .setText("TEST POSITION AND DIRECTION")
                    .setPosition(24,67)
                    .setSize(234,30)
                    .setColorValue(#367BF5)
                    .setFont(f14);
    testPosCap = cp5.addTextlabel("testPosCap")
                    .setText("Point for testing")
                    .setPosition(24,113)
                    .setSize(144,17)
                    .setColorValue(#000000)
                    .setFont(f14);
    testPosX = cp5.addTextlabel("testPosX")
                    .setText("x")
                    .setPosition(24,146)
                    .setSize(18,18)
                    .setColorValue(#000000)
                    .setFont(wh);
    testPosY = cp5.addTextlabel("testPosY")
                    .setText("y")
                    .setPosition(137,146)
                    .setSize(18,18)
                    .setColorValue(#000000)
                    .setFont(wh);


    testVal = cp5.addTextlabel("testVal")
                    .setText("TEST PEN CONFIG")
                    .setPosition(26,312)
                    .setSize(234,30)
                    .setColorValue(#367BF5)
                    .setFont(f14);
    testValCap = cp5.addTextlabel("testValCap")
                    .setText("Config value: ")
                    .setPosition(24,360)
                    .setSize(144,17)
                    .setColorValue(#000000)
                    .setFont(f14);
    testVal_t = cp5.addTextfield("testVal_t")
                        .setPosition(28,395)
                        .setSize(222,40)
                        .setCaptionLabel("")
                        .setColorBackground(#ffffff)
                        .setColorForeground(menu_color)
                        .setFocus(false)
                        .setAutoClear(false)
                        .setColor(#000000)
                        .setFont(wh);

    testPenPosX_t = cp5.addTextfield("testPenPosX_t")
                        .setPosition(52,143)
                        .setSize(80,30)
                        .setCaptionLabel("")
                        .setColorBackground(#ffffff)
                        .setColorForeground(menu_color)
                        .setFocus(false)
                        .setAutoClear(false)
                        .setColor(#000000)
                        .setFont(wh);
    testPenPosY_t = cp5.addTextfield("testPenPosY_t")
                        .setPosition(168,143)
                        .setSize(80,30)
                        .setCaptionLabel("")
                        .setColorBackground(#ffffff)
                        .setColorForeground(menu_color)
                        .setFocus(false)
                        .setAutoClear(false)
                        .setColor(#000000)
                        .setFont(wh);
    
    testPosTest = cp5.addButton("testPosTest")
                    .setPosition(52,200)
                    .setSize(196,40)
                    .setImages(loadImage("postest.png"), loadImage("postest.png"), loadImage("postest.png"));    
    testValTest = cp5.addButton("testValTest")
                    .setPosition(28,460)
                    .setSize(196,40)
                    .setImages(loadImage("valtest.png"), loadImage("valtest.png"), loadImage("valtest.png"));    
    testGood = cp5.addButton("testGood")
                 .setPosition(28,520)
                 .setSize(222,40)
                 .setImages(loadImage("good.png"), loadImage("good.png"), loadImage("good.png"));

    savePanel = cp5.addButton("savePanel")
                    .setPosition(22,48)
                    .setImages(loadImage("savePanel.png"), loadImage("savePanel.png"), loadImage("savePanel.png"))
                                        .updateSize()
                    .setLock(true); // no controlEvent sent back  
    savePanel_save = cp5.addButton("savePanel_save")
                    .setPosition(75,83)
                    .setImages(loadImage("saveButton.png"), loadImage("saveButton.png"), loadImage("saveButton.png"))
                                        .updateSize();  
    savePanel_saveAs = cp5.addButton("savePanel_saveAs")
                    .setPosition(65,133)
                    .setImages(loadImage("saveAsButton.png"), loadImage("saveAsButton.png"), loadImage("saveAsButton.png"))
                                        .updateSize();  
    savePanel_load = cp5.addButton("savePanel_load")
                    .setPosition(75,183)
                    .setImages(loadImage("loadButton.png"), loadImage("loadButton.png"), loadImage("loadButton.png"))
                                        .updateSize();  

}
