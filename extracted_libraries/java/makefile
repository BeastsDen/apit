WRAPDIR=com\swapswire\sw_api
DEXAMPLEDIR=com\swapswire\dealerexample
DSEXAMPLEDIR=com\swapswire\dealsinkexample
SWIGDIR="C:\Program Files\swigwin-2.0.1"
JAVAPATH="C:\Program Files\Java\jdk1.5.0_09"
VCPATH="C:\Program Files\Microsoft Visual Studio 8/VC"

java_dealer_example.jar: DealerExample.class
	$(JAVAPATH)\bin\jar cvfm java_dealer_example.jar $(DEXAMPLEDIR)\manifest.txt $(DEXAMPLEDIR)\*.class $(WRAPDIR)\*.class

DealerExample.class: $(DEXAMPLEDIR)\DealerExample.java SWAPILink.dll
	$(JAVAPATH)\bin\javac $(DEXAMPLEDIR)\DealerExample.java

java_dealsink_example.jar: DealSinkExample.class
	$(JAVAPATH)\bin\jar cvfm java_dealsink_example.jar $(DSEXAMPLEDIR)\manifest.txt $(DSEXAMPLEDIR)\*.class $(WRAPDIR)\*.class

DealSinkExample.class: $(DSEXAMPLEDIR)\DealSinkExample.java SWAPILink.dll
	$(JAVAPATH)\bin\javac $(DSEXAMPLEDIR)\DealSinkExample.java

SWAPILink.dll: sw_api_wrap.obj callbackHandlers.obj jnitools.obj
	link sw_api_wrap.obj callbackHandlers.obj jnitools.obj /LIBPATH:../../Common /LIBPATH:../windows /LIBPATH:$(VCPATH)/atlmfc/lib /LIBPATH:$(VCPATH)/lib /LIBPATH:../lib kernel32.lib sw_api.lib /nologo /dll /incremental:no /machine:I386 /out:"SWAPILink.dll" /implib:"SWAPILink.lib"

sw_api_wrap.obj: $(WRAPDIR)\sw_api_wrap.cpp
	cl -c $(WRAPDIR)\sw_api_wrap.cpp /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_MBCS" /D "_USRDLL" /D "SW_CLIENT_EXPORTS" -I$(JAVAPATH)\include -I$(JAVAPATH)\include\win32 -I. -I..\sw_api_inc /GF /MTd /Od /Gi /Yd /Zi /RTC1 /nologo /W3 /GR /EHSC /c /Zm800

jnitools.obj: $(WRAPDIR)\jnitools.cpp
	cl -c $(WRAPDIR)\jnitools.cpp /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_MBCS" /D "_USRDLL" /D "SW_CLIENT_EXPORTS" -I$(JAVAPATH)\include -I$(JAVAPATH)\include\win32 -I. -I..\sw_api_inc /GF /MTd /Od /Gi /Yd /Zi /RTC1 /nologo /W3 /GR /EHSC /c /Zm800


$(WRAPDIR)/sw_api_wrap.cpp: $(WRAPDIR)\sw_api_swig.i
	$(SWIGDIR)\swig -c++ -java -package com.swapswire.sw_api -I. -I.. -I../sw_api_inc -outdir $(WRAPDIR) -o $(WRAPDIR)\sw_api_wrap.cpp $(WRAPDIR)\sw_api_swig.i

all: java_dealer_example.jar java_dealsink_example.jar
  

clean:
	cd $(WRAPDIR)
	erase /Q /F *.*
	cd ..\..\..
	cd $(DEXAMPLEDIR)
	erase /Q /F *.class
	cd ..\..\..
	cd $(DSEXAMPLEDIR)
	erase /Q /F *.class
	cd ..\..\..
	erase /Q /F SWAPILink.dll SWAPILink.lib SWAPILink.exp vc80.pdb java_dealer_example.jar java_dealsink_example.jar sw_api_wrap.o sw_api_wrap.obj
