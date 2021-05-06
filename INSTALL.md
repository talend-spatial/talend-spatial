## How-to install Talend Open Studio Spatial module ?

 * Download TOS DI from http://www.talend.com
 * Download Spatial module http://sourceforge.net/projects/sdispatialetl/files/sdispatialetl/
 * Unzip TOS DI
 * Unzip Spatial module
 * Copy the content of the plugin directory in the plugins directory of TOS
 * Start TOS

## No spatial component in the palette ?

In configuration/config.ini for osgi.bundles=... property add:

```
,org.talend.libraries.sdi-7.4.1@4,org.talend.sdi.designer.components-7.4.1@4,
org.talend.sdi.designer.routines-7.4.1@4,org.talend.sdi.repository.ui.actions.metadata-7.4.1@4,
org.talend.sdi.repository.ui.actions.metadata.ogr-7.4.1@4,
org.talend.sdi.workspace.spatial-7.4.1@4 
```


## How-to set-up GDAL/OGR ?

GDAL/OGR library is used to create generic schema from all OGR supported format
(eg. SHP, MIF, GML, KML, DXF, WFS, ...). For this, GDAL/OGR should be installed 
on the system (http://www.gdal.org/). 

Once installed, GDAL/OGR and Talend should be configured.

On Windows, configure the following system variables:
 * GDAL_DATA C:\Program Files\GDAL\gdal-data
 * GDAL_DRIVER_PATH C:\Program Files\GDAL\gdalplugins
 * PROJ_LIB C:\Program Files\GDAL\projlib


On Linux, install package libgdal-java.



## More information

 * Home page: http://talend-spatial.github.com/
 * Wiki: http://github.com/talend-spatial/talend-spatial/wiki
 * Forum: http://www.talendforge.org/forum/viewforum.php?id=9


## List of changes

* Talend spatial module version 7.4.1:
  * Test installation with TOS 7.4.1M8
  
* Talend spatial module version 7.3.1:
  * Fix installation with TOS => 7.3.1 #78
  * Update to GDAL 3.0.x #80
  * sProj / Handle null geometry

* Talend spatial module version 7.1.1:
  * Fix installation with TOS => 7.1.1 #78
  
* Talend spatial module version 7.0.1:
  * Fix installation with TOS => 6.3.2 #74

* Talend spatial module version 5.4.1:
  * Projection issue on MN03 #62
  
* Talend spatial module version 5.4.0:
  * sOgrInfo / Do not skip layer when latlon bbox is empty
  * OGR / Generic schema / Missing geometry column (#50)
  * sShapefileOutput / Add option to set DBF charset (#49)

* Talend spatial module version 5.3.1:
  * Create generic schema from any OGR supported format.
  * Demo workspace / Use Natural Earth data to easily run sample jobs
  * Metadata crawler demo workspace / Populate your metadata catalog by scanning folders, services and databases for GIS data
  * sGDALInfo / Do not stop flow on error enhancement components
  * sCSWRequest / Add URL parameter enhancement components
  * sOSM* / Add parameter to fail on error or not enhancement components
  * sOGRInfo / Loop on all layers available enhancement components
  * sOGRInfoInput / fail creating extent enhancement components
  * sCatalogPublisher / Basic auth support
  * sMetadataCreator / Missing jar
  * sGeo* / MIF and GPX support / Clean unused code enhancement components
  * Missing library using sSimpleGeomToMulti components
  * sOgrInput / List datasource layers when not set 

* Talend spatial module version 5.3.0:
  * Add support for TDI 5.3.x series
  * sWfsInput / error 401

* Talend spatial module version 5.2.1:
  * GeoTools 8.5 upgrade - MIF/MID, EDIGEO and GPX format is now supported by OGR component
  * sProj / Add custom transform for projection (#10) - IGN Ntv2 grid transformation supported
  * sOGRInput-sOGROutput / Read and write all OGR formats (#14, #12) - Vector format supported http://www.gdal.org/ogr/ogr_formats.html
  * Add NetCDF, OPeNDAP and THREDDS Iterator components developed by IMOS - Thanks to Craig Jones
  * New components documentation - Thanks Yves Jacolin

* Talend spatial module version 5.2.0:
  * OGRInfo and GDALInfo input components does not set geometry CRS (#9)
  * Add i18n files (#6)
  * sCSWRequest component retrieves CSW response (#5)
  * NullPointerException in sOgrInput with NULL geometries (#3). Thanks etdube for reporting and patch.
  * sCSWRequest component for sending CSW request (#2).
  * GeoNetwork support / catalog component does not follow redirects (#4).
  * Fix wrong log4j dependency version (#1).
  * Update for TOS DI 5.2.x

* Talend spatial module version 5.1.1 :
  * sGdalInfoInput component
  * sOgrInfoInput component
  * Tested on TOS DI 5.1.1 and 5.2.0M3




## Build from source


```shell script
mkdir talend
cd talend
git clone git@github.com:Talend/studio-se-master.git 
cd studio-se-master
# Remove private repository from .gitslave
# by removing "../toem-studio-se.git" "../toem-studio-se" ifpresent
gits populate --with-ifpresent
gits checkout -b 7.3 origin/maintenance/7.3

export MAVEN_OPTS='-Xmx8000m -XX:MaxPermSize=512m -XX:-UseConcMarkSweepGC'
mvn clean install


cd ..
git clone git@github.com:talend-spatial/talend-spatial.git
cd talend-spatial
mvn clean install
./package.sh 7.4.1
```



## F.A.Q

How-to solve GDAL/OGR exception ?

```
Exception like java.lang.UnsatisfiedLinkError: org.gdal.gdal.gdalJNI.Dataset_SWIGUpcast(J)J
	at org.gdal.gdal.gdalJNI.Dataset_SWIGUpcast(Native Method)
	at org.gdal.gdal.Dataset.<init>(Dataset.java:15)
	at org.gdal.gdal.gdal.Open(gdal.java:583)
```
may occur if the GDAL/OGR library installed is a different version of the one provided
in Talend Spatial.

Copy your copy of gdal.jar to Talend in:
 * ./workspace/.Java/lib/gdal.jar
 * ./lib/java/gdal.jar
 * ./plugins/org.talend.sdi.repository.ui.actions.metadata.ogr_5.3.1/lib/gdal.jar
 * ./plugins/org.talend.sdi.designer.components_5.3.1/components/sGdalInfoInput/gdal.jar







