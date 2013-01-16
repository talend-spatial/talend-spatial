# -*- coding: utf-8 -*-
#/bin/python

import os, shutil
# langage to use one of : '_fr', '',
lang = 'fr'
# cheatsheet (true) or full documentation (false):
short = False
#short = True

ignore = ['.svn', 'sGeoBasicOperation', 'sGeoInput', 'sGeoOutput', 'sAggGeomOut', 'sGeoNames', 'sFlowForwarder', 'sSimplePolygonizer']
# TODO:
# 1. prendre en param un répertoire pour placer les fichiers rst et images et où lire le répertoire des components
# 2. prendre en compte la langue en paramètre (default: en) + traduction du texte.
# 3. lire le fichier xml pour définir l'arborescence


if short == True:
    header ='===================================\n'
    header +='Talend Open Studio: spatial plugin\n'
    header +='===================================\n\n'
    header +='\n\n'
    header +='.. image:: _static/logo_c2c_full_carre.png\n'
    header +='   :align: center\n'
    header +='   :width: 200px\n\n'
    
    header +='.. header::\n'
    header +='    Documentation des extensions spatiales de Talend OS.\n\n'
    
    header +='.. footer::\n'
    header +='    mars 2011\n'
    
if short == False:
    header =".. include:: include/"+lang+"/introduction.rst\n\n"
    header +=".. contents::\n\n"
    header +=".. include:: include/"+lang+"/installation.rst\n\n"
    header +="Components\n"
    header +="==========\n\n"

def getInfoFromComponent(componentsDir):
	content = ""
	sDir = os.listdir(componentsDir)
	for sComponentName in sDir:
	    if (sComponentName in ignore):
		continue
	    content +=  "\n|"+sComponentName+"_icone| "+sComponentName+"\n"
	    length = len(sComponentName)
	    content +=  "-" * length * 2 +"----------\n\n"
	    content +=  ".. |"+sComponentName+"_icone| image:: _static/icone/"+sComponentName+'_icon32.png\n'
	    content +=  "  :width: 64px\n\n"
	    #content +=  "  :align: left\n\n"
	    if (lang == 'en'):
		sContent = open(componentsDir+'/'+sComponentName+'/'+sComponentName+'_messages.properties', 'r')
	    else:
		sContent = open(componentsDir+'/'+sComponentName+'/'+sComponentName+'_messages_'+lang+'.properties', 'r')
	    sFinal={}
	    for line in sContent:
		sParam=line.partition('=')
		if sParam[0] != 'HELP' and sParam[1] == '=':
		    sFinal[sParam[0]]=sParam[2].strip().replace('\n','')
		
	    if(sFinal.has_key('LONG_NAME') == False or sFinal.has_key('NAME') == False):
		raise IOError('Entree manquante dans le fichier : '+componentsDir+'/'+sComponentName+'/'+sComponentName+'_messages_'+lang+'.properties')
		    
	    if(len(sFinal['LONG_NAME']) > len(sFinal['NAME'])):
		max = len(sFinal['LONG_NAME'])
		min = len(sFinal['NAME'])
	    else:
		max = len(sFinal['NAME'])
		min = len(sFinal['LONG_NAME'])
	    
	    lineSeparator = '+-------------+'+'-' * max +'--+\n'
	    content += lineSeparator
	    content +=  "+ Nom         + "+ sFinal['NAME'] + " " * ( max - len(sFinal['NAME'])) +" +\n"
	    content += lineSeparator
	    test =  "+ Description + "+ sFinal['LONG_NAME'] + " " * ( max - len(sFinal['LONG_NAME'])) + " +\n"
	    content += test
	    content += lineSeparator+"\n"
	    if short == False:
		if os.path.exists('components/'+lang+'/'+sComponentName+'.rst'):
		    content += ".. include:: components/"+lang+"/"+sComponentName+".rst\n\n"
		
		if os.path.exists('components/_static/'+sComponentName+'_exemple.png'):
		    content += "Exemples\n"
		    content += "~~~~~~~~~~\n\n"
		    content += ".. image:: components/_static/"+sComponentName+"_exemple.png\n"
		    content += "    :align: center\n"
		    #content += "    :width: 1000px\n\n"
	    shutil.copy(componentsDir+'/'+sComponentName+'/'+sComponentName+'_icon32.png', './_static/icone/'+sComponentName+'_icon32.png')

	return content


content = "Components principaux\n"
content += "*********************\n\n"
componentsDir = '../org.talend.sdi.designer.components/components'
content += getInfoFromComponent(componentsDir)

content += "\nAutres components\n"
content += "*********************\n\n"
componentsDir = '../org.talend.sdi.designer.components.sandbox/components'
content += getInfoFromComponent(componentsDir)

if short == True:
    filename = 'talendos_spatial_components.rst'
else:
    filename = 'talendos_spatial_doc.rst'
    
f = open(filename, 'w')
f.write(header+content)


