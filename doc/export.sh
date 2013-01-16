#!/bin/bash
RST2HTML=rst2html.py
RST2PDF=rst2pdf
EXPORT=_build/

echo "Creating HTML file ..."
rm -Rf $EXPORT/html && mkdir -p $EXPORT/html
$RST2HTML talendos_spatial_doc.rst $EXPORT/html/talendos_spatial_doc.html
mkdir -p $EXPORT/html/components/ && cp -Rf components/_static $EXPORT/html/components/
cp -Rf _static $EXPORT/html

echo "Creating PDF file ..."
rm -Rf $EXPORT/pdf && mkdir -p $EXPORT/pdf
$RST2PDF talendos_spatial_doc.rst -o $EXPORT/pdf/talendos_spatial_doc.pdf

#$RST2PDF talendos_spatial_components.rst -o $EXPORT/pdf/talendos_spatial_component.pdf
