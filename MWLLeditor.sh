#! /bin/bash

v=0.10-beta
#executable=Crysis.exe
executable=Editor.exe
shaderspath=~/Documents/My\ Games/Crysis\ Wars/Shaders

# switch comment whats appropriate
#  export WINEARCH=win32
#  winegamepath='/drive_c/Program Files (x86)/Electronic Arts/Crytek/Crysis Wars/Bin32'
#  windowsgamepath='C:\Program Files (x86)\Electronic Arts\Crytek\Crysis Wars\Bin32\'

  export WINEARCH=win64
  winegamepath='/drive_c/Program Files (x86)/Electronic Arts/Crytek/Crysis Wars/Bin64'
  windowsgamepath='C:\Program Files (x86)\Electronic Arts\Crytek\Crysis Wars\Bin64\'

#here we do "magic" to run DX9 (only supported so far)
#and tell Crysis we want the MWLL mod not the OEM game :^)
OPT="-dx9 -mod MWLL"
#OPT="-mod MWLL"
#OPT="-dx9"

# reducing what wine spews at us
export WINEDEBUG=fixme-all


# we controll which directory we want be runned by the script 
  export WINEPREFIX=~/.wine

#this can really beak things if enabled but try it?
#  export MESA_DEBUG=1

# winecfg

# we the humans check here what renders our stuff
# if not "Gallium" then it's software = too slow
REND=$(glxinfo | grep "OpenGL renderer" | awk -F: '{print $2}' | awk -F"(" '{print $1}')
echo "Renderer:"$REND
echo "if the above is llvm and not an actual card the game will not work"

#cleaning leftovers from late dinner ;)
killall $executable
killall -9 $executable

#cleaning shader cache for better performance each time
#rm -r "${shaderspath}/*"

#here I cleverly avoid calling the path with my user name :)
cd "${WINEPREFIX}${winegamepath}/${binpath}"
#here i cleverly ask to show the path so we see what WINEPREFIX was called
pwd

case $WINEARCH in
win64)
     echo 64bit
     wine64 "${windowsgamepath}${executable}" $OPT # &> MWLL_debug.log
     #if uncommented, the last line's comment dumps a log file to the game folder - might prove usefull or a vaste of disk space
     ;;
win32)
     echo 32bit
     #here (hopefully) no shit hits the fan, and we land in game menu
     wine ${windowsgamepath}${executable} $OPT # &> MWLL_debug.log
     #if uncommented, the last line's comment dumps a log file to the game folder - might prove usefull or a vaste of disk space
     ;;
esac
# to restore resolution put here what's appropriate or leave as is and just uncomment
xrandr -s 0 # last good resolution

