DUCO

=======

![Art](/pics/Outline.jpg)

DUCO is an open-source, tool switchable robotic system capable of drawing multi-layer circuits on versatile vertical surface. Assembling parts are highly accessible and low cost. It's inspired by Sandy Noble's work [*Polargraph*](https://github.com/euphy/polargraph)

DUCO is developed for large scale circuits fabrication, but maintaining considerable local precision and resolution. It has default optimal configuration for several drawing substrates - wall paper, glass, wood and etc, also supporting other substrate exploitation.

While linear actuator, laser cutter are well explored in this project, DUCO still have the extensible ability to welcomes all other tools like vinyl cutter and dispenser.

## High-level ability

* Two-stepper locomotion system with well set Cartesian-to-polar solution
* Meter size canvas
* Up to 3 tools mounting platform.
* Ink loaded pen based fabrication with good line quality
* Highly user extensible. User can explore any tools, inks and drawing substrates
* Autonomous robotic system with pen switch, pen pressure function enabled
* Enough spare GPIOs. User can develop new functions since only a few pins are occupied

## What we offer here

This resposity contains Graphical User Interface, Arduino operation firmware and all design files that our team used to test and explore this platform.

* **DucoFirmware** C code on [Arduino](https://www.arduino.cc/), currently supporting UNO to control all motion and actuation commands. 
* **DucoGUI** developed interface based on [Processing](https://processing.org/) framework, allowing user to interact with DUCO like selecting tools, uploading design files and start a drawing task.
* **DucoTest** contains all design files in SVG format that our team used.
* **DucoModels** gives access to all 3D model parts we used.
* **DUCO_BOM** inventory list.

## Put parts together

1. Before moving to run DUCO, you should first have all assembling parts ready. You can either use prototype files in Duco_models folder or design your own 3D model as long as you figure out the correct dimension for assembling.

2. After you get all these accessories printed, first thing you may want to do is assembling the centre platform, we have a figure that you can refer to when you do that.

   ![figure](/pics/assembly.jpg)

3. Subsequently, use hot glue to attach the printed anchor with your steppers( for our choice we use 4-wire [NEMA 17](https://www.banggood.com/3D-Printer-High-Torque-17-Stepper-Motor-300mN-1_5A-2-phase-4-wire-p-1064247.html?p=CS120478587752016125&cur_warehouse=CN), it has a good rated current/ voltage about 5 volts which is suitable for a constant voltage driver.) Then you put a proper size of gear on the stepper driving axis for we need it to hang a belt.

## Hardware setup

1. The very first thing you need to do here is working out what size of your design is and choose a proper operiting area, after which you need to fix the two anchors on the top line. Remember to spare some space both horizontally and vertically, also collecting the dimensional data of your system

   ![figure](/pics/dimension.jpg)

2. Moving forward, two [GT2 timing belts](https://www.amazon.com/Printing-Zeelo-Fiberglass-Rostock-Printers/dp/B0897CJKS1/ref=sr_1_1_sspa?dchild=1&keywords=gt2+belt&qid=1600317379&sr=8-1-spons&psc=1&spLa=ZW5jcnlwdGVkUXVhbGlmaWVyPUEzMVNBWktLSzAxR1VIJmVuY3J5cHRlZElkPUEwNzQwMzE2Mzk0Rk41SzRHU0pWSyZlbmNyeXB0ZWRBZElkPUEwMTQ2NjkyMTRLRlIwNlRZUE42NSZ3aWRnZXROYW1lPXNwX2F0ZiZhY3Rpb249Y2xpY2tSZWRpcmVjdCZkb05vdExvZ0NsaWNrPXRydWU=) are involved. one end of each is both connected with center platform and the other one is tied to hold a weight. They are hanged on two anchors respectively. Note, choosing correct length is important, neither too short (not covering enough moving space) nor too long (causing loosen belts when the weight hits ground)

3. Now attach your Arduino Uno with motor shield. Our firmware is based on [Adafruit motor shield v2](https://learn.adafruit.com/adafruit-motor-shield-v2-for-arduino/overview), a typical constant voltage driver. If you want a more stable torque output, you may consider constant current driver AKA chopper driver. However using other shield requires you to modify the firmware configuration as well.

4. Uno and motor shield becomes control partner and you can stick them "in the brain" of our platform and also put metal stickers on the reflecters.

5. One last step you carrry out is to do wiring up

   - COMs on the shield: usually the stepper is together with 4-color wire, green/black is one couple, blue/red is another. each couple should be connected to one COM on the shield. One stepper is supposed to be connected to the same side's COMs, i.e. for one stepper COM1/2 are used, COM3/4 are responsible for another one.
   - Power port on the shield: + to 5V on DC, - to GND on DC
   - IR: Vcc to 5V on the shield, GND to GND on the shield, SIG to analog pin 1
   - Continuous servo:  to servo port 1 on the shield.
   - Linear actuator: to servo port 2 on the shield.
   - Arduino Uno: to your laptop with USB cable.

## Inventory 

We have an Excel table listing all materials that you may need.

## Q&A

1. Platform moving behavior is wrong.

   Probably something wrong with stepper wiring. Try to swap the connection that is under the same COM

2. When switching tool, the platform keeps rotating then stop and fails to locate a mounting slot.

   It's caused by unsuitable threshold set. Several reasons may result in this:

   - The metal sticker and the IR is not well aligned vertically
   - The metal sticker is not reflective enough
   -  Distance between IR and stickers is too far away.

   We recommend you to open an Arduino sketch and take a look at the IR feedback from analog pin 1. When sticker and IR are well aligned the value should be under 500, typically 200-350. If this is not your case, record your typical value and subtracted by 100-150. Then set this value to variables in Firmware: `thresholdxHigh`(x= 1,2,3) and try again.

   Note: three slots typical value should be almost the same (the program needs this assumption) and a good typical value is always much smaller than 1023. Adjust your `DEFAULT_UP_POSITION` in Firmware to achieve this.

3. Steppers are heating up.

   - The first thing you are looking into should be the supply voltage. Generally when it's higher than the rated voltage of your steppers, overheating takes place. Be sure to give correct voltage supply.
   - When the wires between two steppers and motor shield are not the same length. Wires are introducing extra resistance to your steppers, thus do your best to balance two wires' length(resistance)

4. Linear actuator shows no response or misbehaves.

   Basically caused by unstable connection between shield and linear actuator. Use some insulated tape to enhance the connection and make sure there's no other wires around that of linear actuator. Give it independent space since it's easy to be disturbed.









