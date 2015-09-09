JAR=c2c-geom.jar

JAVA=com/c2c/geometry/Geometry.java
CLASS=com/c2c/geometry/Geometry.class

LIB=../lib/jts-1.9.jar

.PHONY:	all
all: $(JAR)

$(JAR):	$(CLASS)
	jar cf $(JAR) $(CLASS)

$(CLASS): $(JAVA)
	javac -classpath $(LIB) $(JAVA)

.PHONY: clean
clean:
	@rm -f $(CLASS)
	@rm -f $(JAR)
	
