# PostScript Development Tools

[![Build Status](https://travis-ci.org/thomas-fritsch/psdt.svg?branch=master)](https://travis-ci.org/thomas-fritsch/psdt)
[![License](https://img.shields.io/badge/license-GPL%203.0-blue.svg)](http://www.gnu.org/licenses/gpl-3.0)
[![Download](https://api.bintray.com/packages/thomas-fritsch/eclipse/psdt/images/download.svg) ](https://bintray.com/thomas-fritsch/eclipse/psdt/_latestVersion)

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

#### Prerequisites

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
* [Xtend](http://marketplace.eclipse.org/content/eclipse-xtend)
* [EGit](http://marketplace.eclipse.org/content/egit-git-integration-eclipse)
* [m2e](http://marketplace.eclipse.org/content/maven-integration-eclipse-luna)

## Release History

* 1.0.0
  - First public release
