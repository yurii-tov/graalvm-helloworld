###############################
# Building graalvm executable #
###############################


jar=graalvm-1.0-SNAPSHOT-jar-with-dependencies.jar


export PATH="/c/tools/graalvm-jdk-17.0.8+9.1/bin:$PATH"


# Building jar
mvn -q clean assembly:assembly -DdescriptorId=jar-with-dependencies
cd target/


# Creating info for complier
mkdir -p META-INF/native-image
echo -e 'Manifest-Version: 1.0\nMain-Class: example.App' > META-INF/MANIFEST.MF
java -agentlib:native-image-agent=config-output-dir=META-INF/native-image -jar $jar
java -agentlib:native-image-agent=config-merge-dir=META-INF/native-image -jar $jar
zip -r $jar META-INF/


# Compilation
native-image.cmd -H:+AllowIncompleteClasspath --no-fallback --verbose -jar $jar out
