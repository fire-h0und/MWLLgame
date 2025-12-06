#! /bin/bash

v="0.11-beta"
#executable=Crysis.exe
executable=Editor.exe
executable=EditorLauncher.exe

export WINEARCH=win64
#export WINEDEBUG=-fixme-all,-warn-all,-err-all,-all,-info-all
export WINEDEBUG=-all
export WINEPREFIX="${HOME}/.wine"

winegamepath='/drive_c/Program Files (x86)/Electronic Arts/Crytek/Crysis Wars/Bin64'
windowsgamepath='C:\Program Files (x86)\Electronic Arts\Crytek\Crysis Wars\Bin64\'

#here we do "magic" to run DX9 (only supported so far)
#and tell Crysis we want the MWLL mod not the OEM game :^)
OPT="-mod MWLL -dx9"
#OPT="-mod MWLL"
#OPT="-dx9"

WINEFSYNC=1
WINEESYNC=1
DXVK_HUD=1
#DXVK_FILTER_DEVICE_NAME="NVIDIA GeForce GTX 1060 3GB"

# we the humans check here what renders our stuff
# if not "Gallium" then it's software = too slow
REND=$(glxinfo | grep "OpenGL renderer" | awk -F: '{print $2}' | awk -F"(" '{print $1}')
echo "Renderer:"$REND
echo "if the above is llvm and not an actual card the game will not work"

#cleaning leftovers from late dinner ;)
killall $executable
killall -9 $executable

cd "${WINEPREFIX}${winegamepath}/${binpath}"
pwd
ls

wine64 "${windowsgamepath}${executable}" $OPT #2>/dev/null # &> MWLL_debug.log

