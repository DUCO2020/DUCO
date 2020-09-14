##DUCO

========

DUCO is an open-source, tool switchable robotic system capable of drawing multi-layer circuits on versatile vertical surface. Assembling parts are highly accessible and low cost. It's inspired by Sandy Noble's work [*Polargraph*](https://github.com/euphy/polargraph)

DUCO is developed for large scale circuits fabrication, but maintaining considerable local precision and resolution. It has default optimal configuration for several drawing substrates - wall paper, glass and wood, also supporting other substrate exploitation.

While linear actuator, laser cutter are well explored in this project, DUCO still have the extensible ability to welcomes all other tools like vinyl cutter and dispenser.

## High-level ability

* Two-stepper locomotion system with well set Cartesian-to-polar solution
* Meter size canvas
* Up to 3 tools mounting platform.
* Ink loaded pen based fabrication with good line quality
* Highly user extensible. User can explore any tools, inks and drawing substrates
* autonomous robotic system with pen switch, pen pressure function enabled

## What we offer here

This resposity contains Graphical User Interface, Arduino operation firmware and all design files that our team used to test and explore this platform.

* **DucoFirmware** C code on [Arduino](https://www.arduino.cc/), currently supporting UNO to control all motion and actuation commands. 
* **DucoGUI** developed interface based on [Processing](https://processing.org/) framework, allowing user to interact with DUCO like selecting tools, uploading design files and start a drawing task.
* **Duco_test** contains all design files in SVG format that our team used.

## Some inspirations

If you are still struggling with your own design, a few inspirations provided about what we do with DUCO!

* Interactive piano: a capacitive touch response piano

  ![piano](\whatwedo\piano.jpg)

* 3D lamp: a laser cutting self-assembled lamp

  ![lamp](\whatwedo\lamp.png)

  







