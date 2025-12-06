#! /bin/bash

#init
echo "############################"
echo "#"
echo "# MMWLL Server script init"
echo "#"
echo "############################"
v="0.4-beta"

# The PLAN (tm)
# This script should generate a viable server on it's first run and run it.
# For this to happen some prerequisites are to be met:
# There should be a running MWLL install in a known wine prefix
# The companion script has to be able to generate the levelrotation file
# While script does run extensive checks it still might wreak havoc so
# Be sure to have a running backup of everything of any significance!

  executable=CrysisWarsDedicatedServer.exe
  export WINEDEBUG=-all # consult wine documentation for this

#customization (put your preferred name below) of the server to be run
  servername='Pentagon'
  
#select one, don't make up - it has to be either 32 or 64:

  #SUFFIX=32
  SUFFIX=64

  export WINEPREFIX="${HOME}/.wine${SUFFIX}"
  export WINEARCH="win${SUFFIX}"
  gameBINdir="Bin${SUFFIX}"
  
  #select only one OPT line
  OPT="-mod MWLL -dx9"
  #OPT="-mod MWLL"

# This script depends on an already existing wine prefix with an already running game
# that has be setup for example for playing the game or making maps for instance.
# this script is to be pointed to that prefix and will source it for an independent
# new prefix that will be generated if no matching exsists yet.

#setup:
  wineSOURCEprefixBASE="${HOME}/.wine"
  wineSOURCEdriveC="${wineSOURCEprefixBASE}/drive_c"
  wineSOURCEwarsDIR="${wineSOURCEdriveC}/Program Files (x86)/Electronic Arts/Crytek/Crysis Wars"
  wineSOURCEmwllDIR="${wineSOURCEwarsDIR}/Mods/MWLL"
  wineSOURCEbaseDIR="${wineSOURCEdriveC}/Crysis Wars" # reroute the base dir to the root of basic drive
  wineSOURCEserverDIR="${wineSOURCEdriveC}/Servers/${servername}"



#config
  # reroute the base dir to the root of basic drive
  wineWARSlink=${WINEPREFIX}'/drive_c/Crysis Wars'
  winegamepath=${wineWARSlink}'/'${gameBINdir}
  # windows correct syntax
  windowsgamepath='C:\Crysis Wars\'${gameBINdir}'\'
  confdir='C:\Servers\'${servername}
  wineservers=${WINEPREFIX}/Servers
  wineSERVERconfigDIR=${wineservers}/${servername}

#this is actually a hack:
#
# To trick wine into serving a 32 bit server without 
# actually storing 2 independednt prefixes - 
# a generic 32bit prefix called ~/.wine32 is made
# then symnlinks from the 64 bit prefix are placed in there
# and the 32bit wine pointing right there gets run

# setup everything that is missing in the source prefix first:
if [[ -d ${wineSOURCEprefixBASE} ]]; then
  echo "Found wine install, good sign."
else
  echo "We can't continue without a 64 bit [${wineSOURCEprefixBASE}] prefix."
  echo "  After you setup the default wine prefix,"
  echo "  manually install the MWLL game"
  echo "  and rerun this script."
  exit 2
fi

if [[ -d ${wineSOURCEmwllDIR} ]]; then
    echo "Found WMLL install, good."
else
    echo "We can't continue without a manual MWLL install."
    echo "  Please install the MWLL game to the"
    echo "  default wine prefix and rerun this script."
    exit 2
fi

if [[ -d ${WINEPREFIX} ]]; then
  echo "found [${WINEPREFIX}] prefix dir, good."
else
  echo "no [${WINEPREFIX}] prefix found, we have to create one"
  unset DISPLAY
  export WINEDEBUG=-all
  wineboot
fi

#
# There should by now be a $WINEPREFIX dir
#

# Here we assume this script is run the first time and
# run thru series of checks and generate infrastructure along
# if anything is missing
# everything gets created in the already existing wineprefix first!
# only once all server infrastructure is in place in the original prefix,
# will this script link to the freshly generated
# server's wine prefix (See below)

if [[ -s ${wineSOURCEbaseDIR} ]]; then
  echo "Found Crysis Wars base dir symlink in source 64 bit prefix."
else
  echo "No base dir symlink in root directory found, creating:"
  cd ${wineSOURCEdriveC}
  ln -sv "${wineSOURCEwarsDIR}"
  ls -lah ${wineSOURCEbaseDIR}
fi

if [[ -d Servers && -d ${wineSOURCEserverDIR} ]]; then
  echo "Found the [${servername}] server dir, good."
  # carefully this nukes everything! #
  #use this to generate empty server dirs from scratch
  #rm -vrf Servers/${wineSOURCEserverDIR}
else
  echo "Creating the [Servers/${servername}] server dir, stand by..."
  cd ${wineSOURCEdriveC}
  mkdir -pv Servers/${servername}
  cd ${wineSOURCEdriveC}/Servers/${servername}
  echo "Generating inital configuration,"
  echo "please inspect and adjust accordingly..."
  touch banlist.xml # for players
  touch blacklist.txt # for maps

  #
  # A known good configuration file set
  # generated per on-need basis:
  #
  
  if ![[ -a common.cfg ]]; then cat <<EOF > common.cfg
-- This file is commonn among all the server instances --

g_useProfile=1
r_ShadersAsyncCompiling=1
net_pb_sv_enable false
sv_cheatprotection=0
sv_levelrotation="levelrotation.xml"
sv_voice_enable_groups=0
net_enable_voice_chat=0
g_preroundtime=0
sv_ranked=0

;; loaded common.cgf:
EOF
fi

  if ![[ -a servermessage.txt ]]; then cat <<EOF > servermessage.txt
Welcome to the Pentagon worlds
press [home] to immediately relief of stress
gametip: loner == goner
gametip: friendly fire - isn't
EOF
fi

  if ![[ -a server.cfg ]]; then cat <<EOF > server.cfg
-- This file might or might not be auto-generated
-- Any manual changes made might be lost when and if the file gets re - generated.

;; loading common.cgf:
exec common.cgf

#--------------------
# game related setup
#--------------------
sv_logKills=1
sv_logChat=1
#-----------------
# network tuning
#-----------------
sv_bandwidth = 90000
sv_PacketRate = 30
cl_PacketRate = 30
-- kick lagging players --
sv_antilag_enabled=1
-- if ping goes over this (msec) it\'s fishy ---
sv_antilag_pingLimit=500
-- every other is in seconds --
sv_antilag_sampleCount=15
sv_antilag_sampleInterval=5
sv_antilag_warnTime=20
#-------------
# admin stuff
#-------------
sv_servermessage_enabled=1
-- in seconds 5-3600 (def = 300) --
sv_servermessage_delay=120
-- in seconds 5-300 or above --
-- (whichever is less)  (def = 10) --
sv_servermessage_lineDelay=12


sv_servername="Pentagon Orbital Facility"
sv_port=64100
sv_password=""
sv_maxplayers=8
g_timelimit=60
g_minteamlimit=0
g_revivetime=2
g_autoteambalance=0
g_tk_punish=0
g_tk_punish_limit=50
ban_timeout=604800
log_Verbosity=15
log_FileVerbosity=15
-- good foor testing--
sv_starting_cbills=15000000
sv_leaguemode_enabled=1
sv_leaguemode_givecbills=1
sv_cbillmessage_broadcast=1
sv_servermessage_reload
g_nextlevel
-- EOF
EOF
fi
  #
  # In cases it is suspected any of the above files got corrupted, remove them
  # so this script will regenerate them.
  #

  # Punk Buster thingies twiddling up:
  if [[ -d "${wineSOURCEdriveC}/Servers/${servername}/pb" ]]; then
    echo "found additional files, good."
  else
    cp -R "${wineSOURCEwarsDIR}/PB" ${wineSOURCEdriveC}/Servers/${servername}
    mv "${wineSOURCEdriveC}/Servers/${servername}/PB" "${wineSOURCEdriveC}/Servers/${servername}/pb"
    rm -rf ${wineSOURCEdriveC}/Servers/${servername}/pb/htm
  fi
  if [[ -a "${wineSOURCEserverDIR}"/levelrotation.xml  ]]; then
    echo "found [${wineSOURCEserverDIR}/levelrotation.xml] map rotation fille, good."
  else
    #
    # external companion script that generates a locally valid maplist for us
    #
    echo "Checking [MWLLmaploadgen.sh] for inital map rotation list:"
    if [[ -x $(which MWLLmaploadgen.sh) ]]; then
      MWLLmaploadgen.sh
    else
      echo "[MWLLmaploadgen.sh] not found,"
      echo "  be sure to make this list later on!"
    fi
  fi
  ls -lah ${wineSOURCEdriveC}/Servers/${servername}
fi

# deja vu:
# only once all server infrastructure is in place in the original prefix,
# will this script link to the freshly generated
# server's wine prefix (See below)
echo "#### Actual server prefix setup:"

if [[ -s ${wineWARSlink} ]]; then
  echo "Found base dir symlink in server prefix."
else
  echo "No base dir symlink found, creating one:"
  cd ${wineSOURCEdriveC}
  ln -sv "${wineSOURCEwarsDIR}" "${wineWARSlink}"
fi
ls -lah "${wineWARSlink}"

if [[ -d ${wineservers} ]]; then
  echo "Found [${wineservers}], good."
else
  mkdir -vp ${wineservers}
fi

# Actual point where the running instance will be referenced from is here:
if [[ -s ${wineSERVERconfigDIR} ]]; then
  echo "Found [${wineSERVERconfigDIR}], good."
else
  echo "Creating [${wineSERVERconfigDIR}]-> [${wineSOURCEserverDIR}]:"
  ln -vs ${wineSOURCEserverDIR} ${wineservers}
fi


#ps ax | grep $executable
# just in case:
# cleaning leftovers from late dinner ;)
killall $executable
killall -9 $executable

# if any this is where logs should be found:
cd "${wineSERVERconfigDIR}"
pwd
ls

# this script is intended to actually launch the server, everything before was regular pre-flight checkup
case $WINEARCH in
win64)
     echo 64bit
     echo \
     "wine64 ${windowsgamepath}${executable} -root ${confdir}  $OPT -exec server.cfg"
     wine64 \
     "${windowsgamepath}${executable}" -root ${confdir}  -exec server.cfg $OPT #2> MWLL_debug.log
     ;;
win32)
     echo 32bit
     echo \
     "wine ${windowsgamepath}${executable} $OPT -root ${confdir} -exec server.cfg"
     wine \
     "${windowsgamepath}${executable}" ${OPT} -root ${confdir} -exec server.cfg #2> MWLL_debug.log
     ;;
esac

