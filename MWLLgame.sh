#! /bin/bash

v="0.11-beta"
executable=Crysis.exe
shaderspath=~/Documents/My\ Games/Crysis\ Wars/Shaders

#we controll which directory we want be runned by the script 
  winegamepath='/drive_c/Program Files (x86)/Electronic Arts/Crytek/Crysis Wars/Bin64'
  windowsgamepath='C:\Program Files (x86)\Electronic Arts\Crytek\Crysis Wars\Bin64\'

#here we do "magic" to run DX9
#and tell Crysis we want the MWLL mod not the OEM game :^)
OPT="-dx9 -mod MWLL"
#non DX9 setups (aka DX10) should uncomment this:
#OPT="-mod MWLL"

# reducing what wine spews at us
export WINEDEBUG=-all
export WINEESYNC=1 #old tweak
export WINEFSYNC=1 #new tweak
#set this according to your setup:
export WINEPREFIX="${HOME}/.wine" 

# Vulkacn support:
DXVK_CONFIG_FILE=$HOME/.config/dxvk.conf

export DXVK_HUD=scale=version,devinfo,fps,0.75  # ,gpuload,memory,frametimes

# set this accordingly
# export DXVK_FILTER_DEVICE_NAME="NVIDIA GeForce GTX 1060 3GB"

#this can really beak things if enabled but try it?
#  export MESA_DEBUG=1

# we the humans check here what renders our stuff
# if not "Gallium" then it's software = too slow
REND=$(glxinfo | grep "OpenGL renderer" | awk -F: '{print $2}' | awk -F"(" '{print $1}')
echo "Renderer:"$REND
echo "if the above is llvm and not an actual card the game may render too slow"

#cleaning leftovers from late dinner ;)
killall $executable
killall -9 $executable

#pro-tip: cleaning shader cache for better performance each time
rm -r "${shaderspath}/*"

cd "${WINEPREFIX}${winegamepath}/${binpath}"
pwd

wine64 "${windowsgamepath}${executable}" $OPT #2>/dev/null # &> MWLL_debug.log

# this should work for most single monitor setups, adjust accordingly
xrandr --output $(xrandr | grep " connected" | awk '{print $1}') -s 0
# alternative version
#xrandr --output $(xrandr | grep " connected" | awk '{print $1}') --mode 1680x1050

