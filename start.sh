#!/bin/bash
## current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if [ -z "$OPIHOME" ]; then
    export OPIHOME=$DIR
fi
if [ -z "$OPIDATA" ]; then
    export OPIDATA=$DIR
fi
## test if phoebus executable is found in path
if ! command -v phoebus &> /dev/null
then
    echo "phoebus executable not found in PATH"
    exit
fi
if [ ! -f "$OPIHOME/.setting_applied" ]; then
    if [ -n "$EPICS_CA_ADDR_LIST" ]; then
        # Apply the modification
        echo "org.phoebus.pv.ca/addr_list=$EPICS_CA_ADDR_LIST" >> "$OPIHOME/settings.ini"

        # Create a marker file to indicate that the modification has been applied
        touch "$OPIHOME/.setting_applied"
    fi
    if [ -n "$EPICS_ARCHIVER" ]; then
        echo "org.csstudio.trends.databrowser3/urls=pbraw://$EPICS_ARCHIVER/retrieval" >> $OPIHOME/settings.ini
        echo "org.csstudio.trends.databrowser3/archives=pbraw://$EPICS_ARCHIVER/retrieval" >> $OPIHOME/settings.ini

        touch "$OPIHOME/.setting_applied"

    fi

    if [ -n "$CHANNEL_FINDER_URL" ]; then
        echo "org.phoebus.channelfinder/channelfinder.serviceURL=$CHANNEL_FINDER_URL/ChannelFinder" >> $OPIHOME/settings.ini
        touch "$OPIHOME/.setting_applied"

    fi
    
fi

phoebus -settings $OPIHOME/settings.ini -resource $OPIHOME/Launcher.bob
