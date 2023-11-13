#!/bin/bash +x
#TODOs if I make this public:
# 1 - Arguments for input/output upk/output extracted files paths
# 2 - Make the launch of tools optional
# 3 - Allow override/specified WINEPREFIX
# 4 - Be VERY explicit about the $PATH manipulation or drop it entirely and suggest in the output
# 5 - Option to enable/disable stdin/stdout
# 6 - Cleanup intermediary files option
# 7 - Remove friend specific instructions
#

INDIR=$(pwd)/game_files_here
OUTDIR=$(pwd)/workdir/decrypted_upk
EXTDIR=$(pwd)/extracted_files
export PATH=$(pwd)/bin:$PATH
export WINEPREFIX=~/.XRD_TEX_DN6
export DOTNET_ROOT=${WINEPREFIX}/drive_c/Program\ Files/dotnet

if [[ "$0" == "$BASH_SOURCE" ]] ; then
    echo "#################################################"
    echo "Run this with \`source $0\` to setup wine prefix"
    echo "You can also run the following two commands: "
    echo "export WINEPREFIX=${WINEPREFIX}"
    echo "export DOTNET_ROOT=${DOTNET_ROOT}"
    echo "To add the tools to your shell you can run:"
    echo "export PATH=$(pwd)/bin:\$PATH"
    echo "#################################################"
fi

if [[ ! -d ${INDIR} ]] ; then
    echo "${INDIR} does not exist.  Making it and exiting, please put the files from xrd in there."
fi

if [[ ! -d ${OUTDIR} ]] ; then
    mkdir -p ${OUTDIR}
fi

if [[ ! -d ${EXTDIR} ]] ; then
    mkdir -p ${EXTDIR}
fi

if [[ ! -d ${DOTNET_ROOT} ]] ; then
    echo "Dotnet 6 is not in ${WINEPREFIX} installing..."
    wine dist/windowsdesktop-runtime-6.0.23-win-x64.exe /quiet &>/dev/null || true
    wine dist/dotnet-hosting-6.0.24-win.exe /quiet &>/dev/null || true
fi

# First we will decrpyt the files that are located in indir and put them in outdir

for i in ${INDIR}/*
do
    echo "Processing $i"
    quickbms -Y $(pwd)/scripts/ggxrd.bms $i ${OUTDIR} &>/dev/null
done

echo "Decryption complete."

echo "Extracting files"

for i in ${OUTDIR}/*
do
    echo "processing $i"
    umodel -export $i -out=${EXTDIR} &>/dev/null
done

echo "Extraction complete"

echo "Your origianl upk are in ${INDIR}"
echo "Your decrypted upk are in ${OUTDIR}"
echo "The extracted files are in ${EXTDIR}"
echo "***********************************"
echo "Starting UPK Explorer and the PNGtoDDS Converter"
pushd $(pwd)/bin/UPKExplorer
wine UPK\ Explorer.exe &>/dev/null &
popd
pushd $(pwd)/bin/PNGtoDSS
wine DDSConverter.exe &>/dev/null &
popd

