#!/bin/bash

v="0.4-beta"
#
# Generate a list with all locally present maps for MWLL server
#

# Per running instance setting:
winePREFIX=".wine"
# Per server setting:
Servername="Pentagon"

# Common to all crysis wars settings:
wineDRIVEc="${HOME}/${winePREFIX}/drive_c"
wineWARSdir="${wineDRIVEc}/Program Files (x86)/Electronic Arts/Crytek/Crysis Wars"

# Mod specific settings:
wineMWLLdir="${wineWARSdir}/Mods/MWLL"

# Implementation specific setting:
wineSERVERdir="${wineDRIVEc}/Servers/${Servername}"

# the actual work begins here
echo "Re-regenerating levelrotation.XML"

# gametypes: ToS - TestOfStrength
#            TSA - TeamSolarisArena
#            SA  - SolarisArena
#            TC  - TerrainControl

maptype="TC"
gametype="TerrainControl"

blacklist="${wineSERVERdir}"/blacklist.txt # filter out maps with a grep pattern
mappath="${wineMWLLdir}/Game/Levels/Multiplayer/${maptype}"
workfile="${wineSERVERdir}"/work-levelrotation.xml
destfile="${wineSERVERdir}"/levelrotation.xml
backfile="${wineSERVERdir}"/old-levelrotation.xml
# mapurl="http://mechlivinglegends.net/maps/"
mapurl="https://mwll.12vr.org/mechlivinglegends.net/maps/"

filetemplatepre='<?xml version="1.0" encoding="utf-8"?>\n<levelRotation randomize="0">\n'
filetemplatepost='</levelRotation>'
slottemplatepre='  <level name="'
slottemplatemid='" gameRules="'
slottemplatepost='">\n    <setting setting="g_timelimit 60" />\n    <setting setting="g_fraglimit 0" />\n    <setting setting="g_pp_scale_income 1" />\n    <setting setting="g_revivetime 2" />\n    <setting setting="g_roundlimit 0" />\n    <setting setting="g_preroundtime 0" />\n    <setting setting="sv_team_tickets 555" />\n    <setting setting="sv_player_tickets 0" />\n    <setting setting="sv_is_vs_clan 0" />\n    <setting setting="net_mapDownloadUrl '
slottemplatelast='" />\n  </level>\n'

count=0
skip=0

echo -ne $filetemplatepre > $workfile

for f in $(ls "$mappath"); do
  #echo "Processing ["$f"]"
  if grep -q $f $blacklist; then
    skip=$(( $skip +1 ))
  else
    count=$(( $count +1 ))
    url=$mapurl$f'.zip'
    echo -ne "${slottemplatepre}"   >> $workfile
    echo -ne $f                     >> $workfile
    echo -ne "${slottemplatemid}"   >> $workfile
    echo -ne $gametype              >> $workfile
    echo -ne "${slottemplatepost}"  >> $workfile
    echo -ne $url                   >> $workfile
    echo -ne "${slottemplatelast}"  >> $workfile
    echo -ne "progress: "$count", skipped: "$skip".\r"
  fi
done


echo $filetemplatepost >> $workfile

echo "progress: done                "

echo "backing up the old file (it's safe to ignore errors):"
rm -v $backfile
mv -v $destfile $backfile
mv -v $workfile $destfile
