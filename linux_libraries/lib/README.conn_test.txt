Windows:

To run the conn_test help binary
) Extract the API zip file
) Open explorer
) Browse to the top level that contains "lib" and "apidocs" subdirectories
) Shift + Right-Click "lib"
) Select "Open command window here"
) Turn on the requested environment variable
    set SW_TRACE_FILE=conn_test.log
) Execute the program to test the connection to a selected server.
    e.g. conn_test https://mw.uat.api.markit.com
) Check to see if the output contains
	CONCLUSION: SUCCESSFUL CONNECTION

*) If there is an error, add the "-v" flag
    e.g. conn_test -v https://mw.uat.api.markit.com

*) If you cannot progress, contact your internal support team, providing
   them with the output and the log file (conn_test.log)


UNIX:

To run the conn_test help binary
) Extract the API tar.gz file
) cd to the top level that contains "lib" and "apidocs" subdirectories
) cd lib
) Turn on the requested environment variable
    export SW_TRACE_FILE=conn_test.log
) Use the local libraries
    export LD_LIBRARY_PATH=.
) Execute the program to test the connection to a selected server.
    e.g. ./conn_test https://mw.uat.api.markit.com
) Check to see if the output contains
	CONCLUSION: SUCCESSFUL CONNECTION

*) If there is an error, add the "-v" flag
    e.g. conn_test -v https://mw.uat.api.markit.com

*) If you cannot progress, contact your internal support team, providing
   them with the output and the log file (conn_test.log)
