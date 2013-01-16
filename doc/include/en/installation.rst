Install
========

Getting started
*****************

In order to install spatial extension to Talend OS, you need first a working 
Talend OS. You can download it from `Talend website <http://www.talend.com>`_, 
uncompress the archive file.

.. warning::
   You can run Talend OS first without any spatial component in order to create 
   et configure all necessary files.

Spatial extensions
********************

After downloading spatial extension from the 
`public repository <http://sourceforge.net/projects/sdispatialetl/files/sdispatialetl/>`_ 
and uncompress it, copy past the contents of the *plugins/* directory inside 
the one in the Talend OS application.

Just run Talend now to use the spatial extensions.

.. note::
   Use corresponding release of Talend OS and Spatial extension. Mix release 
   number could make some error.

Oracle Spatial support
************************

In order to support Oracle spatial working in Talend OS you should do the 
following tasks:

* Install an Oracle Client with at least the same release number as your Oracle 
  Spatial DataBase. For instance an Oracle 11 client will work with Oracle data 
  base 10g.
* Copy jar file from C:\\ETL\\TOS-Win32-r63143-V4.2.2\\plugins\\org.talend.sdi.designer.components_4.2.0
  to C:\\ETL\\TOS-Win32-r63143-V4.2.2\\lib\\java if it doesn't work.

Oracle Spatial components are located in Database/Oracle (same as standard 
Oracle component).

If TOS is already open, refresh components lists with Ctrl + Shift + F3.

GDAL/OGR support
*****************

Use of sOGR* or sGDAL* components in a job needs GDAL-Java installation and setup 
some variable.

GDAL-Java  installation
-------------------------

* For Windows:
  The `GIS Internals website <http://www.gisinternals.com/sdk/>`_ allow several release 
  of GDAL to install. `MSVC2010 (Win32) <http://www.gisinternals.com/sdk/PackageList.aspx?file=release-1600-gdal-1-9-mapserver-6-2.zip>`_ 
  release has been successfully tested.

  Download and install the file called "*Generic installer for the GDAL core components*" 
  (in our test case  *gdal-19-1600-core.msi*). Other msi files are not mandatory.

* For Linux:

  Actually there is no GDAL-java package available on Linux. You should build 
  your from source.

System setup
-------------

* Windows system setup :

  You should now add pathes to GDAL. On Windows 7, open the files navigator, 
  right clic on 'computer' and choose 'Properties' then choose "advanced 
  settings".

  In the windows you have a button called "Environments variables ..." (bottom). 
  Add the following pathes:

  * **GDAL_DATA** with value C:\Program Files\GDAL\gdal-data
  * **GDAL_DRIVER_PATH** with value C:\Program Files\GDAL\gdalplugins
  * **PROJ_LIB** with value *C:\Program Files\GDAL\projlib*

  Finally add this two pathes to *path* variable:

  * C:\Program Files\GDAL\java
  * C:\Program Files\GDAL

  You should have something like this: *PATH=%SystemRoot%\system32;%SystemRoot%;%SystemRoot%\System32\Wbem;%SYSTEMROOT%\System32\WindowsPowerShell\v1.0\;C:\Program Files\GDAL\java;C:\Program Files\GDAL*

* Linux system setup

  In order to use GDAL/OGR in Talend, the *java.library.path* variable should 
  point to GDAL library. To set this property, go to the Run view > Advanced 
  settings > Use specific JVM Arguments and add a new argument::

    -Djava.library.path=/path/to/gdal-1.9.1/swig/java

  .. image:: _static/ogr_gdal_config.png

  If this argument is not defined, Talend will probably report the following error message::

    Native library load failed.
    java.lang.UnsatisfiedLinkError: no ogrjni in java.library.path
    Exception in thread "main" java.lang.Error: java.lang.UnsatisfiedLinkError: org.gdal.ogr.ogrJNI.RegisterAll()V

