%module(jniclassname = "SWAPILink") SWAPILinkModule
%warnfilter(451) SW_DealNotifyData;

%{
/*****************************************************************************

   Copyright 2002-2012 MarkitSERV. All Rights Reserved.

*****************************************************************************/

#include "mw_swig_funcs.h"

using namespace mw::JNI;
%}

%javaconst(1);

%include typemaps.i
%include swapiTypemaps.i
%include codeGenPragmas.i
%include sw_api.h
%include sw_api_types.h
%include sw_api_errorcodes.h
%include sw_api_constants.h
