# $1: release number
# target: folder containing plugins (exported from Eclipse)

# Create packaging folder
mkdir target/TOS-Spatial-$1

# Copy installation instruction
cp INSTALL target/TOS-Spatial-$1/.
cp README.md target/TOS-Spatial-$1/.

# Unzip plugins
mkdir target/TOS-Spatial-$1/plugins
cp main/plugins/org.talend.libraries.sdi/target/org.talend.libraries.sdi-6.0.1.jar target/TOS-Spatial-$1/plugins/.
cp main/plugins/org.talend.sdi.designer.components/target/org.talend.sdi.designer.components-6.0.1.jar target/TOS-Spatial-$1/plugins/.
cp main/plugins/org.talend.sdi.designer.routines/target/org.talend.sdi.designer.routines-6.0.1.jar target/TOS-Spatial-$1/plugins/.
cp main/plugins/org.talend.sdi.repository.ui.actions.metadata/target/org.talend.sdi.repository.ui.actions.metadata-6.0.1.jar target/TOS-Spatial-$1/plugins/.
cp main/plugins/org.talend.sdi.repository.ui.actions.metadata.ogr/target/org.talend.sdi.repository.ui.actions.metadata.ogr-6.0.1.jar target/TOS-Spatial-$1/plugins/.
cp main/plugins/org.talend.sdi.workspace.spatial/target/org.talend.sdi.workspace.spatial-6.0.1.jar target/TOS-Spatial-$1/plugins/.

cd target/TOS-Spatial-$1/plugins/
for f in `find . -name "org.talend*jar"`; do
   unzip $f -d `basename $f .jar`
   rm $f
done

cd ../..

# Pack
zip -r TOS-Spatial-$1.zip TOS-Spatial-$1
