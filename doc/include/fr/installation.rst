Installation
=============

Pour commencer
***************

Dans le but d'installer les extensions spatiales dans Talend OS, vous avez 
d'abord besoin de Talend OS. Vous pouvez le t�l�charger � partir du 
`site web de Talend <http://www.talend.com>`_, d�compressez le fichier d'archive.

.. warning::
    Il est conseill� de lancer une premi�re fois Talend OS pour qu'il cr�� 
    et configure les fichiers n�cessaires.

Les extensions spatiales
*************************

Apr�s avoir t�l�charg� l'archive contenant les extensions spatiales � 
partir du `d�p�t public <http://sourceforge.net/projects/sdispatialetl/files/sdispatialetl/>`_ 
et l'avoir d�compress�, copiez-collez le contenu du r�pertoire *plugins/* 
dans celui de l'application Talend OS.

Lancez tout simplement Talend et maintenant vous pouvez utiliser les extensions 
spatiales.

.. note::
    Il est conseill� d'utiliser les versions correspondantes de Talend OS et 
    des extensions spatiales. M�langer les versions peut �tre source de probl�me.

Installation de la gestion d'Oracle Spatial
********************************************

Afin que les connexions Oracle fonctionnent vous devez r�aliser les actions 
suivantes :

* Installer un client Oracle correspondant au moins � la version de la base � 
  acc�der. Exemple : un client Oracle 11 fonctionnera pour une base 10g mais un 
  client Oracle 10 ne fonctionnera pas pour une base 11g.
* copier les fichiers sdoapi.jar et sdoutil.jar dans ``plugins/org.talend.sdi.designer.components_5.2.1/components/sGeoInput/`` 
  et dans ``plugins/org.talend.libraries.sdi_5.2.1/lib/``.
 
Les components Oracle se trouvent dans le dossier Database/Oracle.

Si TOS est d�j� ouvert, il faut rafra�chir la liste des composants : Ctrl + 
Shift + F3

Installation de GDAL/OGR
*************************

L'utilisation des components sOGR* et sGDAL* n�cessite l'installation de GDAL 
en Java et la d�finition de variables d'environnement.

Installation de GDAL-Java
--------------------------

* Sous Windows :

  Le site `GIS Internals <http://www.gisinternals.com/sdk/>`_ propose plusieurs 
  versions de GDAL/MapServer � installer. La version `MSVC2010 (Win32) <http://www.gisinternals.com/sdk/PackageList.aspx?file=release-1600-gdal-1-9-mapserver-6-2.zip>`_ 
  a �t� test�e avec succ�s sur une machine 32b.

  T�l�chargez et installez la version nomm�e "*Generic installer for the GDAL core components*" 
  (dans notre cas *gdal-19-1600-core.msi*). Les autres versions .msi sont optionnelles.

* Sous Linux :

  Il n'y a pas de packet pour Linux pour GDAL-Java actuellement. Vous devez 
  compiler � partir des sources.

Param�trage du syst�me
-----------------------

* Sous Windows :

  Vous devez rajouter les chemins vers GDAL. Sous Windows 7, ouvrez l'explorateur 
  cliquez droit sur 'Ordinateur' > Propri�t�s puis choisissez "Param�tres 
  syst�me avanc�s".

  La fen�tre qui s'ouvre propose un bouton "Variables d'environnement ..." (en bas 
  de l'onglet *Param�tres syst�mes avanc�s*). Ajoutez les variables suivantes :

  * **GDAL_DATA** avec la valeur C:\\Program Files\\GDAL\\gdal-data
  * **GDAL_DRIVER_PATH** avec la valeur C:\Program Files\\GDAL\\gdalplugins
  * **PROJ_LIB** avec la valeur *C:\\Program Files\\GDAL\\projlib*

  Enfin ajoutez ces deux chemins � la variable *path* :

  * C:\\Program Files\\GDAL\\java
  * C:\\Program Files\\GDAL

  Comme ceci : *PATH=%SystemRoot%\\system32;%SystemRoot%;%SystemRoot%\\System32\\Wbem;*
  *%SYSTEMROOT%\\System32\\WindowsPowerShell\\v1.0\\;C:\\Program Files\\GDAL\\java;C:\\Program Files\\GDAL*

  Si votre installation de GDAL est diff�rente vous devrez adapter les chemins 
  dans les variables d'environnement.

* Sous Linux :

  Pour utiliser GDAL/OGR dans un job vous devez pointer la variable *java.library.path* 
  vers la biblioth�que GDAL. Pour d�finir cette propri�t�, allez sur "�x�cutez" > 
  "Param�trages avanc�s" > "Utilisez les Arguments JVM sp�cifiques" et ajoutez un 
  argument suppl�mentaire :
  ::
	
    	-Djava.library.path=/path/to/gdal-1.9.1/swig/java

  .. image:: _static/ogr_gdal_config.png

  Si l'argument n'est pas d�finie, Talend renverra probablement le message d'erreur 
  suivant :
  ::
	
  	  Native library load failed.
	  java.lang.UnsatisfiedLinkError: no ogrjni in java.library.path
	  Exception in thread "main" java.lang.Error: java.lang.UnsatisfiedLinkError: org.gdal.ogr.ogrJNI.RegisterAll()V


