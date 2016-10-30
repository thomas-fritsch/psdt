# PostScript Development Tools

[![Build Status](https://travis-ci.org/thomas-fritsch/psdt.svg?branch=master)](https://travis-ci.org/thomas-fritsch/psdt)
[![License](https://img.shields.io/badge/license-GPL%203.0-blue.svg)](http://www.gnu.org/licenses/gpl-3.0)
[![Bintray](https://img.shields.io/bintray/v/thomas-fritsch/eclipse/psdt.svg)](https://bintray.com/thomas-fritsch/eclipse/psdt/_latestVersion)

This project delivers a [PostScript](https://en.wikipedia.org/wiki/PostScript) Integrated Development Environment for the Eclipse platform.

[![Screenshot](http://thomas-fritsch.github.io/psdt/images/debugging.png)](http://thomas-fritsch.github.io/psdt/)

## Features

* Syntax Highlighting 
* Syntax Validation 
* Content Assist
* Documentation Hovers
* Run/Debug with Ghostscript
* Breakpoints
* Watch Points

## Installation

Make sure you have the following prerequisites installed:
* [Java](https://www.java.com/) (version 6 or higher).
* [Eclipse](http://www.eclipse.org) (version 4.4 or higher).
* [Ghostscript](http://ghostscript.com/download/gsdnld.html) (any version).  
  Choose the flavor for your OS and follow the download/install instructions.
  
#### Installation from Update Site

In Eclipse, do the following:
* Go to menu _Help_ -> _Install New Software..._
* In the resulting dialog click the _Add..._ button to present a further dialog
* Here enter `PSDT` as the _Name_ and <http://thomas-fritsch.github.io/psdt/repository/> 
  as the _Location_ and press OK
* The install view will present the available things, select the _PostScript
  Language_ category
* Proceed to install the software in the usual manner accepting all defaults
* Eclipse will prompt for a restart, accept this, then the PostScript Development
  Tools are usable

#### Installation of Alternate Versions

The above installation mechanism will install the latest official version of
PSDT. It is possible to install older or newer beta versions of the software
by using <http://dl.bintray.com/thomas-fritsch/eclipse/psdt/x.y.z> as the
update site URL, where x.y.z is the desired version. You can see the available
versions at <http://dl.bintray.com/thomas-fritsch/eclipse/psdt/>.

## Development setup

Make sure you have the following prerequisites installed:
* [JDK](http://www.oracle.com/technetwork/java/javase/downloads/) (version 7 or higher).
* [Maven](http://maven.apache.org/) (version 3).  
  Follow the instructions given in "Download, Install, Run Maven".

A complete build (including unit tests) is done by:

    mvn clean verify

The generated update site will be in directory `de.tfritsch.psdt.updatesite/target/repository`.

## Release History

* 1.0.0
  - First public release
