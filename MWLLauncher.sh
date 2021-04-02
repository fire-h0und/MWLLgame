#! /bin/bash


killall Crysis.exe
killall -9 Crysis.exe

cd "/home/cest/.wine.mwll/drive_c/Program Files (x86)/Electronic Arts/Crytek/Crysis Wars/Mods/MWLL"
pwd

WINEPREFIX="/home/cest/.wine.mwll" wine64 "C:\Program Files (x86)\Electronic Arts\Crytek\Crysis Wars\Mods\MWLL\MWLLLauncher.exe"

