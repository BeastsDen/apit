SwapsWire API Java Support
==========================

Overview
--------

This directory contains a sample SWIG (http://www.swig.org) wrapper for the
SwapsWire API to enable use of the API from Java. It also includes two sample
Java applications demonstrating dealer and dealsink functionality, and an
automatically generated Java wrapper for the API which is more consistent
with modern Java usage.

The wrapper and samples are provided pre-built; however the incuded makefile
allows you to rebuild and/or customise the code as desired.

NOTE: The API is now released as a platform specific download. Please see the
platform instructions below for details on setting up your environment correctly
for running and/or rebuilding the sample code.

Layout
------

The code is structured as follows:

com/swapswire/sw_api           : SWIG sources for the SWAPILink wrapper library.
com/swapswire/util             : Auto-generated session classes making API usage more idiomatic.
com/swapswire/dealsinkexample  : Java sample showing dealsink functionality.
com/swapswire/dealerexample    : Java sample showing dealer functionality.                
java_dealer_example.jar        : Precompiled Java dealer example.
java_dealsink_example.jar      : Precompiled Java dealsink example.
makefile                       : Makefile for rebuilding the wrapper/samples.

Running the Samples
-------------------

You can run the sample applications as follows:

  # java -jar java_dealer_example.jar <host:port> <username> <password> <command> [<command params>...]

For the sample dealer application, or:

  # java -jar java_dealsink_example.jar <host:port> <username> <password> <command> [<command params>...]

For the sample dealsink application.

For example:

  # java -jar java_dealer_example.jar training.swapswire.com:9009 MYUSER MYPASSWORD InfiniteLoopCmd

Will run the dealer sample, waiting indefinitely to receive notification events.

Running either sample without any command line arguments will will print a list
of available commands and their options.

NOTE: Please see the platform specific instructions below for details on
setting up your environment correctly. 

Building
--------

Windows
~~~~~~~

Copy the makefile from this directory to the directory containing the 'sw_api_swig.i'
file and then move to that directory.

Then typing

  # nmake all

Should rebuild the SWIG wrapper and the examples.

To completely remove the results of the build, use

  # nmake clean

NOTE: You will need the included 'sw_api.dll' to be in your PATH in order to run the
samples.

Solaris
~~~~~~~

Check the file 'makefile' to ensure that the paths to the Java compiler,
SWIG etc match your installation.

The makefile has 4 targets:

- 'wrapper' builds the SWIG generated JNI wrapper library 'libSWAPILink.so'
   into the directory '../lib'.
- 'samples' builds the java sample programs into .jar files in the
  current directory.
- 'all' (the default) builds both 'wrapper' and 'samples'.
- 'clean' removes the wrapper library and all generated files
  (including the wrapper shared library).

Typing:

  # make <target>

Will build the target given. To completely rebuild everything, use: 

  # make clean all

NOTE: You will need to include '../lib' in your LD_LIBRARY_PATH when running
      the samples in order to allow the api library 'libsw_api.so' and the
      wrapper 'libSWAPILink.so' to be found.

Linux
~~~~~

Linux works exactly as Solaris does, please follow the Solaris instructions
to rebuild the wrapper and/or samples.

