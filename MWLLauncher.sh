#! /bin/bash
v="0.10-beta"

killall Crysis.exe
killall -9 Crysis.exe

export WINEARCH=win64
export WINEDEBUG=-all
export WINEESYNC=1 #old tweak
export WINEFSYNC=1 #new tweak

# Vulkan support:
DXVK_CONFIG_FILE=$HOME/.config/dxvk.conf

export DXVK_HUD=scale=version,devinfo,fps,0.75  # ,gpuload,memory,frametimes

cd "${HOME}/.wine/drive_c/Program Files (x86)/Electronic Arts/Crytek/Crysis Wars/Mods/MWLL"
pwd

WINEPREFIX="${HOME}/.wine" wine64 "C:\Program Files (x86)\Electronic Arts\Crytek\Crysis Wars\Mods\MWLL\MWLLLauncher.exe"
