#/usr/bin/bash
#FMOD STUDIO SHIT
# ------------------------------------------------------------------------------
# Get fmod package details.
executableName="fmodstudioapi20107win-installer.exe"
executableVersion=$(echo $executableName | sed -e "s/fmodstudioapi//"g | sed -e "s/win-installer.exe//"g)
executablePrettyVersion="${executableVersion:0:1}"."${executableVersion:1:2}"."${executableVersion:3:4}"

# Clone firestorm fmod libraries and place fmod package into directory.
fmodStudioLibraries="https://vcs.firestormviewer.org/3p-libraries/3p-fmodstudio"
git clone $fmodStudioLibraries "./3p-fmodstudio"
cp $executableName "./3p-fmodstudio/"$executableName
cd 3p-fmodstudio
echo Old: $(cat build-cmd.sh | grep "FMOD_VERSION=")
echo Old: $(cat build-cmd.sh | grep "FMOD_VERSION_PRETTY=")
sed -i '5s/.*/'FMOD_VERSION='"'$executableVersion'"''/' build-cmd.sh
sed -i '6s/.*/'FMOD_VERSION_PRETTY='"'$executablePrettyVersion'"''/' build-cmd.sh
echo New: $(cat build-cmd.sh | grep "FMOD_VERSION=")
echo New: $(cat build-cmd.sh | grep "FMOD_VERSION_PRETTY=")
# # ------------------------------------------------------------------------------
#
#
#
#Create package for 32bit.
echo "Starting 32bit build and packaging."
autobuild build -A 32
output32=$(autobuild package -A 32 | tail -2)
echo "$output32"
# add dumpt to text here
# autobuild installables edit fmodstudio platform=windows hash=$hash32 url=file:///$directory32
hash32=$(echo "$output32" | awk '/md5/ { print $2 }')
directory32=$(echo "$output32" | awk '/wrote/ { print $2 }')
echo "32 bit packaging complete."
echo "32bit hash:" $hash32 "32bit directory:" $directory32


#
#
# # ------------------------------------------------------------------------------
# Create package for 64bit.
echo "Starting 64bit build and packaging."
autobuild build -A 64
output64=$(autobuild package -A 64 | tail -2)
echo "$output64"
# add dumpt to text here
# autobuild installables edit fmodstudio platform=windows64 hash=$hash64 url=file:///$directory64
hash64=$(echo "$output64" | awk '/md5/ { print $2 }')
directory64=$(echo "$output64" | awk '/wrote/ { print $2 }')
echo "64 bit packaging complete."
echo "64bit hash: " $hash64 "64bit directory: " $directory64
echo "Exiting the fmod folder."
cd ..
# # # # ------------------------------------------------------------------------------
# # Build Variables for Viewer
buildVariables="fs-build-variables"
git clone https://vcs.firestormviewer.org/$buildVariables

# # #VIEWER PULL SHIT
# # # ------------------------------------------------------------------------------
viewerGit="https://vcs.firestormviewer.org/phoenix-firestorm"
git clone $viewerGit "./viewer"
cd red
# #Edit autobuild stuff to include the local files.
echo Copying autobuild.xml into my_autobuild.xml.
cp autobuild.xml my_autobuild.xml
set AUTOBUILD_CONFIG_FILE=my_autobuild.xml
autobuild installables edit fmodstudio platform=windows hash=$hash32 url=file:///$directory32
autobuild installables edit fmodstudio platform=windows64 hash=$hash64 url=file:///$directory64
set AUTOBUILD_CONFIG_FILE=my_autobuild.xml

# #













