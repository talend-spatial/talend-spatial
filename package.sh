# $1: release number
# $2: folder containing plugins (exported from Eclipse)

# Create packaging folder
mkdir $2/TOS-Spatial-$1

# Copy installation instruction
cp INSTALL $2/TOS-Spatial-$1/.

# Unzip plugins
cd $2/plugins

for f in `find . -name "org.talend*jar"`; do
   unzip $f -d `basename $f .jar`
   rm $f
done

cd ..

mv plugins $2/TOS-Spatial-$1/.

# Pack
zip -r TOS-Spatial-$1.zip TOS-Spatial-$1



