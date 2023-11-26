#!/bin/bash +x

function start_windows_tools {
    echo "Starting UPK Explorer and the PNGtoDDS Converter"
    pushd $(pwd)/bin/UPKExplorer &> /dev/null
    wine UPK\ Explorer.exe &>/dev/null &
    popd &> /dev/null
    pushd $(pwd)/bin/PNGtoDSS &>/dev/null
    wine DDSConverter.exe &>/dev/null &
    popd &>/dev/null
}

source $(pwd)/extract_from_xrd.sh
res=$?
if [[ $res -ne 0  ]] ; then
    return $res
fi
start_windows_tools

