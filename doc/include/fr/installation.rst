Installation
=============

Pour commencer
***************

Dans le but d'installer les extensions spatiales dans Talend OS, vous avez 
d'abord besoin de Talend OS. Vous pouvez le télécharger à partir du 
`site web de Talend <http://www.talend.com>`_, décompressez le fichier d'archive.

.. warning::
    Il est conseillé de lancer une première fois Talend OS pour qu'il créé 
    et configure les fichiers nécessaires.

Les extensions spatiales
*************************

Après avoir téléchargé l'archive contenant les extensions spatiales à 
partir du `dépôt public <http://sourceforge.net/projects/sdispatialetl/files/sdispatialetl/>`_ 
et l'avoir décompressé, copiez-collez le contenu du répertoire *plugins/* 
dans celui de l'application Talend OS.

Lancez tout simplement Talend et maintenant vous pouvez utiliser les extensions 
spatiales.

.. note::
    Il est conseillé d'utiliser les versions correspondantes de Talend OS et 
    des extensions spatiales. Mélanger les versions peut être source de problème.

Installation de la gestion d'Oracle Spatial
********************************************

Afin que les connexions Oracle fonctionnent vous devez réaliser les actions 
suivantes :

* Installer un client Oracle correspondant au moins à la version de la base à 
  accéder. Exemple : un client Oracle 11 fonctionnera pour une base 10g mais un 
  client Oracle 10 ne fonctionnera pas pour une base 11g.
* copier les fichiers sdoapi.jar et sdoutil.jar dans ``plugins/org.talend.sdi.designer.components_5.2.1/components/sGeoInput/`` 
  et dans ``plugins/org.talend.libraries.sdi_5.2.1/lib/``.
 
Les components Oracle se trouvent dans le dossier Database/Oracle.

Si TOS est déjà ouvert, il faut rafraîchir la liste des composants : Ctrl + 
Shift + F3

Installation de GDAL/OGR
*************************

L'utilisation des components sOGR* et sGDAL* nécessite l'installation de GDAL 
en Java et la définition de variables d'environnement.

Installation de GDAL-Java
--------------------------

* Sous Windows :

  Le site `GIS Internals <http://www.gisinternals.com/sdk/>`_ propose plusieurs 
  versions de GDAL/MapServer à installer. La version `MSVC2010 (Win32) <http://www.gisinternals.com/sdk/PackageList.aspx?file=release-1600-gdal-1-9-mapserver-6-2.zip>`_ 
  a été testée avec succès sur une machine 32b.

  Téléchargez et installez la version nommée "*Generic installer for the GDAL core components*" 
  (dans notre cas *gdal-19-1600-core.msi*). Les autres versions .msi sont optionnelles.

* Sous Linux :

  Il n'y a pas de packet pour Linux pour GDAL-Java actuellement. Vous devez 
  compiler à partir des sources.

Paramétrage du système
-----------------------

* Sous Windows :

  Vous devez rajouter les chemins vers GDAL. Sous Windows 7, ouvrez l'explorateur 
  cliquez droit sur 'Ordinateur' > Propriétés puis choisissez "Paramètres 
  système avancés".

  La fenêtre qui s'ouvre propose un bouton "Variables d'environnement ..." (en bas 
  de l'onglet *Paramètres systèmes avancés*). Ajoutez les variables suivantes :

  * **GDAL_DATA** avec la valeur C:\\Program Files\\GDAL\\gdal-data
  * **GDAL_DRIVER_PATH** avec la valeur C:\Program Files\\GDAL\\gdalplugins
  * **PROJ_LIB** avec la valeur *C:\\Program Files\\GDAL\\projlib*

  Enfin ajoutez ces deux chemins à la variable *path* :

  * C:\\Program Files\\GDAL\\java
  * C:\\Program Files\\GDAL

  Comme ceci : *PATH=%SystemRoot%\\system32;%SystemRoot%;%SystemRoot%\\System32\\Wbem;*
  *%SYSTEMROOT%\\System32\\WindowsPowerShell\\v1.0\\;C:\\Program Files\\GDAL\\java;C:\\Program Files\\GDAL*

  Si votre installation de GDAL est différente vous devrez adapter les chemins 
  dans les variables d'environnement.

* Sous Linux :

  Pour utiliser GDAL/OGR dans un job vous devez pointer la variable *java.library.path* 
  vers la bibliothèque GDAL. Pour définir cette propriété, allez sur "Éxécutez" > 
  "Paramétrages avancés" > "Utilisez les Arguments JVM spécifiques" et ajoutez un 
  argument supplémentaire :
  ::
	
    	-Djava.library.path=/path/to/gdal-1.9.1/swig/java

  .. image:: _static/ogr_gdal_config.png

  Si l'argument n'est pas définie, Talend renverra probablement le message d'erreur 
  suivant :
  ::
	
  	  Native library load failed.
	  java.lang.UnsatisfiedLinkError: no ogrjni in java.library.path
	  Exception in thread "main" java.lang.Error: java.lang.UnsatisfiedLinkError: org.gdal.ogr.ogrJNI.RegisterAll()V


