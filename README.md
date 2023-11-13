# ggxrd_linux_toolkit
Toolset to decrypt and extract from Guilty Gear XRD on Linux -- Probably works for any other UE3 game

*This is still very rough around the edges*

TODO:
* Basically everything

Requirements:
* wine
* reqs for umodel (libpng12 32-bit so far, I am working on getting this all setup.  On arch I just installed `steam-runtime-native` and it covered the right libs)
* I will be working back through a cleanroom build of umodel to nail this down more precisely and provide a list.

Usage:
* Place upks you want to decrypt and extract into the `game_files_here` directory, then from a termianl run `source run.sh`
* 
