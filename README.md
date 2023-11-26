# ggxrd_linux_toolkit
Toolset to decrypt and extract from Guilty Gear XRD on Linux -- Probably works for any other UE3 game

*This is still very rough around the edges*

TODO:
* Add arugments to entrypoints, specify the following:
  * Game to use (default is guilty for xrd)
  * Use wine-baed extract.exe (Get rid of stupid branch on filename)
  * Output format for models and textures (umodel passthroughs)
  * Source directory
  * Target directory for decrypted upks
  * Target directory for extracted upk contents
  * Provide AES key and feed that to umodel/extract.exe/etc instead of quickbms decrypt 
    * Needed for other game support, but bypasses decrypted upk step?  Just add decryption if key specified?
* Find or write a native to linux extract.exe
* Convert umodel to a submodule and build from source (?) 
* Convert quickbms to a submodule and build from source
* Add MIT 3-clause or other copyleft, the only actual output of mine here are the damn scripts anyway.

Requirements:
* wine (If you wish to use extract.exe or start UPKExplorer and DDSToPNG)
  * This will create an empty/new wineprefix and install dotnet for you.
* reqs for umodel (libpng12 32-bit so far, I am working on getting this all setup.  On arch I just installed `steam-runtime-native` and it covered the right libs)
  * Alternatively, build statically linked. 

Usage:
* Place upks you want to decrypt and extract into the `game_files_here` directory, then from a termianl run your choice of scripts:
  *  `extract_from_xrd.sh` will take any upk files in the `game_files_here` directory and then use quickbms to decrypt them.  The decrypted upk will go to `workdor/decrypted_upk`.  It will then use umodel (and in some cases also extract.exe) to extract the contents of the files. 
  *  extract_and_run_upkexplorer.sh will first run `extract_from_xrd.sh` and then will launch `UPKExplorer.exe` and `DDSToPNG.exe` 

* If you want to have your terminal pre setup for the wineprefix and add the `bin/` to your path (for example so you can run umodel) you can `source <scriptname>` which will take exports into your existing shell.  Otherwise just run the scripts and they will do what they say on the tin
