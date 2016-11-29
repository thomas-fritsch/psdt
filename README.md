# PostScript Development Tools

[![Build Status](https://travis-ci.org/thomas-fritsch/psdt.svg?branch=master)](https://travis-ci.org/thomas-fritsch/psdt)
[![License](https://img.shields.io/badge/license-GPL%203.0-blue.svg)](http://www.gnu.org/licenses/gpl-3.0)
[![Download](https://api.bintray.com/packages/thomas-fritsch/eclipse/psdt/images/download.svg) ](https://bintray.com/thomas-fritsch/eclipse/psdt/_latestVersion)
[![Install](http://marketplace.eclipse.org/misc/installbutton.png "Drag to your running Eclipse workspace to install PSDT")]
  (http://marketplace.eclipse.org/marketplace-client-intro?mpc_install=3162861)

This project delivers a [PostScript](https://en.wikipedia.org/wiki/PostScript) Integrated Development Environment for the Eclipse platform.

[![Screenshot](http://thomas-fritsch.github.io/psdt/images/debugging.png)](http://thomas-fritsch.github.io/psdt/)

## Features

* Editor
	* Syntax Highlighting
	* Syntax Validation
	* Content Assist
	* Templates for well-known idioms (for, ifelse, image, repeat, stopped, ...)
	* Documentation Hovers
	* Documentation Hyperlinks
	* Toggle Comments
	* Outline/Structure View
	* Folding
	* Formatting
* Run/Debug
	* Launch with Ghostscript
	* Step in/over/out
	* Show Interpreter Stacks, Graphics State
	* Toggle/Enable/Disable Breakpoints
	* Run to Line
	* Watch Points
* Documentation
	* [PLRM](https://www.adobe.com/products/postscript/pdfs/PLRM.pd)
	  sections in Help Contents (all Level 1, 2 operators)

## Installation

#### Prerequisites

* [Java](https://www.java.com/) (version 6 or higher).
* [Eclipse](http://www.eclipse.org) (version 4.4 or higher).
* [Ghostscript](http://ghostscript.com/download/gsdnld.html) (any version).  
  Choose the flavor for your OS and follow the download/install instructions.

#### Installation from Marketplace

* Drag this [![Install](http://marketplace.eclipse.org/misc/installbutton.png
  "Drag to your running Eclipse workspace to install PSDT")]
  (http://marketplace.eclipse.org/marketplace-client-intro?mpc_install=3162861)
  button to your running Eclipse instance
* Follow the instructions in the usual manner

#### Installation from Update Site

* In Eclipse open menu _Help_ -> _Install New Software..._
* Use the _Add..._ button to add a new repository with  
  _Name:_ `PSDT`  
  _Location:_ `http://thomas-fritsch.github.io/psdt/repository/` 
* Wait for the software list to be displayed, select _PostScript Language_
  ![Install](install.png)]
* Follow the instructions in the usual manner

## Development setup

#### Prerequisites

* [JDK](http://www.oracle.com/technetwork/java/javase/downloads/) (version 7 or higher).
* [Maven](http://maven.apache.org/) (version 3).  
  Follow the instructions given in "Download, Install, Run Maven".

#### Build

A complete build (including unit tests) is done by:

    mvn clean verify

The generated update site will be in directory `de.tfritsch.psdt.updatesite/target/repository`.

#### IDE

The easiest way is to download and install the [Eclipse IDE for Java and DSL Developers]
(http://www.eclipse.org/downloads/packages/eclipse-ide-java-and-dsl-developers/neon1a).

Alternatively you can take an existing Eclipse instance and add the following components:
* [Xtext](http://marketplace.eclipse.org/content/xtext)
  [![Install](http://marketplace.eclipse.org/misc/installbutton.png "Drag and drop into a running Eclipse workspace to install Xtext")]
  (http://marketplace.eclipse.org/marketplace-client-intro?mpc_install=1073)
* [Eclipse Xtend](http://marketplace.eclipse.org/content/eclipse-xtend)
  [![Install](http://marketplace.eclipse.org/misc/installbutton.png "Drag and drop into a running Eclipse workspace to install Eclipse Xtend")]
  (http://marketplace.eclipse.org/marketplace-client-intro?mpc_install=148396)
* [EGit - Git Integration for Eclipse](http://marketplace.eclipse.org/content/egit-git-integration-eclipse)
  [![Install](http://marketplace.eclipse.org/misc/installbutton.png "Drag and drop into a running Eclipse workspace to install EGit - Git Integration for Eclipse")]
  (http://marketplace.eclipse.org/marketplace-client-intro?mpc_install=1336)
* [Maven Integration for Eclipse (Luna)](http://marketplace.eclipse.org/content/maven-integration-eclipse-luna)
  [![Install](http://marketplace.eclipse.org/misc/installbutton.png "Drag and drop into a running Eclipse workspace to install Maven Integration for Eclipse (Luna)")]
  (http://marketplace.eclipse.org/marketplace-client-intro?mpc_install=1774116)

## Release History

* [1.0.1](https://github.com/thomas-fritsch/psdt/releases/tag/1.0.1) - 24 Nov 2016
* [1.0.0](https://github.com/thomas-fritsch/psdt/releases/tag/1.0.0) - 30 Oct 2016
