###############################
# Building graalvm executable #
###############################


# x86
# x86_amd64
# x86_x64
# x86_arm
# x86_arm64
# amd64
# x64
# amd64_x86
# x64_x86
# amd64_arm
# x64_arm
# amd64_arm64
# x64_arm64
arch=${1:-x86_x64}


jar=graalvm-1.0-SNAPSHOT-jar-with-dependencies.jar


export PATH="/c/tools/graalvm-jdk-17.0.8+9.1/bin:/c/Program Files (x86)/Microsoft Visual Studio/2022/BuildTools/VC/Auxiliary/Build:$PATH"


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
cmd /c 'vcvarsall.bat '$arch' && native-image.cmd -H:+AllowIncompleteClasspath --no-fallback --verbose -jar '$jar' out'
