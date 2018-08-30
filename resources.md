---
layout: page
title: Resources
permalink: /resources/
---

Here are some useful resources and important software for this course.

## MARS (MIPS Simulator)

This lets us write assembly in a nice, friendly environment. (Without needing to transmit our code over a serial cable or whatever just to see if it worked... that was a bleak time. Nobody wants that.)

We will be using MARS for all of our assembly work in this course.
It is expected that assignments and projects you produce will run with this specific version of MARS (so be wary if you got a different version from somewhere else!)

**Download**: [Mars_2191_a.jar](Mars_2191_a.jar)

### Helpful Notes

* Requires Java 8+ to be installed. You can install the [JRE here](http://www.oracle.com/technetwork/java/javase/downloads/index.html) if you don't have it installed already.
* You likely want to make sure (under Settings) that "Initialize program counter to global main" is **checked** at first.
* It may be useful to **check** under Settings "Clear Run I/O upon assembling" and "Show labels window", but it is up to you.
* The first thing you probably want to do is resize the window so that the left-hand panel is bigger, so click and drag the right edge of that left panel to make sure we see a large area to type within.
* You probably want the run speed (slider at the top of the window) to be all the way to the right (FAST), but sometimes it is useful to slow things down.

### Linux Users

If you use openjdk, you will also need the openjfx package.
It is up to you to determine how to install those packages using your Linux distribution's package manager.

### Acknowledgements

This version of MARS is maintained by our own Jarrett Billingsley.
You can see a changelog (and any updates) [here](https://jarrettbillingsley.github.io/teaching/classes/cs0447/software.html),
but make sure your work still functions using the version posted here for all assignments and labs!
