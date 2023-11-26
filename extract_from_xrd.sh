#!/bin/bash +x
#TODOs if I make this public:
# 1 - Arguments for input/output upk/output extracted files paths
# 2 - Make the launch of tools optional -- currently base on wine existing
# 3 - Allow override/specified WINEPREFIX
# 4 - Be VERY explicit about the $PATH manipulation or drop it entirely and suggest in the output
# 5 - Option to enable/disable stdin/stdout
# 6 - Cleanup intermediary files option
# 7 - Remove friend specific instructions

function init {
    INDIR=$(pwd)/game_files_here
    OUTDIR=$(pwd)/workdir/decrypted_upk
    EXTDIR=$(pwd)/extracted_files
    wine_bin=$(which wine)
    export PATH=$(pwd)/bin:$PATH
    export WINEPREFIX=~/.XRD_TEX_DN6
    export DOTNET_ROOT=${WINEPREFIX}/drive_c/Program\ Files/dotnet
}
function create_directories {
    if [[ ! -d ${INDIR}  ]] ; then
        echo "${INDIR} does not exist.  Creating it and then exiting.  Please put the upks you wish to decrypt and extract in there."
        return 2 #ENOENT
    fi

    if [[ ! -d ${OUTDIR}  ]] ; then
        mkdir -p ${OUTDIR}
    fi

    if [[ ! -d ${EXTDIR}  ]] ; then
        mkdir -p ${EXTDIR}
    fi
}

function check_for_dotnet_in_wineprefix {
    if [[ ! -d ${DOTNET_ROOT} ]] ; then
        echo "Dotnet 6 is not in ${WINEPREFIX} installing..."
        wine dist/windowsdesktop-runtime-6.0.23-win-x64.exe /quiet &>/dev/null || true
        wine dist/dotnet-hosting-6.0.24-win.exe /quiet &>/dev/null || true
    fi
}


function decrypt {
    for i in ${INDIR}/*.upk
    do
        if [[ ! -f ${OUTDIR}/$(basename $i) ]] ; then
            echo "Decrypting $i..."
            quickbms -Y $(pwd)/scripts/ggxrd.bms $i ${OUTDIR} &>/dev/null
        else
            echo "$(basename $i) present in ${OUTDIR}, skipping decryption..."
        fi
    done

    echo "Decryption complete."
}

function extract {
    echo "Extracting files"

    for i in ${OUTDIR}/*.upk
    do
        echo "Extracting data from $(basename $i) with umodel."
        umodel -game=guilty -export $i -out=${EXTDIR} &> /dev/null
        if [[ $i =~ .*MSH.* ]] || [[ $i =~ BGM.* ]]; then
            echo "Extracting raw data from $(basename $i) with extract.exe"
            # TODO: Find source or write a linux native of this
            wine bin/extract.exe -game=guilty $i  -out=${EXTDIR} &> /dev/null
        fi
    done

    echo "Extraction complete"
}

function start_windows_tools {
    echo "Starting UPK Explorer and the PNGtoDDS Converter"
    pushd $(pwd)/bin/UPKExplorer &> /dev/null
    wine UPK\ Explorer.exe &>/dev/null &
    popd &> /dev/null
    pushd $(pwd)/bin/PNGtoDSS &>/dev/null
    wine DDSConverter.exe &>/dev/null &
    popd &>/dev/null
}

init
if [[ "$0" == "$BASH_SOURCE" ]] ; then
    echo "#################################################"
    echo "Run this with \`source $(basename $0)\` to setup wine prefix and PATH envars"
    echo "You can also run the following two commands for your wineprefix: "
    echo "export WINEPREFIX=${WINEPREFIX}"
    echo "export DOTNET_ROOT=${DOTNET_ROOT}"
    echo "To add the ability to call tools from your path you can run:"
    echo "export PATH=$(pwd)/bin:\$PATH"
    echo "#################################################"
fi
create_directories
decrypt
extract
echo ${wine_bin}
if [[ -f ${wine_bin} ]] ; then
    check_for_dotnet_in_wineprefix
else
    echo "Wine is not installed.  Skipping dotnet6 check/install and wineprefix setup."
fi

echo "Your original upk are in ${INDIR}"
echo "Your decrypted upk are in ${OUTDIR}"
echo "The extracted files are in ${EXTDIR}"
echo "***********************************"

