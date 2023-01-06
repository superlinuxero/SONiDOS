# SONiDOS: Spotify On Newest i386 DistrOS

A script to install Spotify 32 bits in modern i386 distros.

My primary laptop, a 2005 IBM ThinkPad, runs only i386 code. After installing LMDE 5 and realizing that there is no more support in Flathub and AppImage for 32-bit software, knowing that the official deb file for installing Spotify using their repository will fail on dependecies, I decided to create a script to download Spotify, extract its contents, download extra libraries and put all files in a convenient directory into your home directory.

This script will not modify your Linux system since all files are placed inside your home directory. In fact, the script will complain if you run it as root.

 **WHAT THIS SCRIPT DOES:**
 
 1.- Creates a temporary directory (which will be deleted after install)
 
 2.- Downloads and extracts the latest deb release of Spotify for i386.
 
 3.- Downloads, extracts, and places in its directory numerous libraries
     needed for Spotify to run
 
 4.- Creates a wrapper named spotify.sh which will load the program and links
     all shared libraries placed before in there. Also, a symlink to your
     $HOME/.local/bin directory, if exists, will be created
 
 5.- Creates a new .desktop file and places it in $HOME/.local/share/applications/
 
 6.- Installs the program and all libraries to $HOME/.local/share/spotify

 The script is pretty simple, you just need pressing a key sometimes to continue.

 In some casses, a log-out and log-in may be necessary to see the entry in
 the Applications menu.
 
 **HOW TO RUN IT:**
 
 You can either download the script from this page and run it, or from your terminal window, using these commands:
 
     wget -q https://raw.githubusercontent.com/superlinuxero/SONiDOS/main/SONiDOS.sh
 
     bash SONiDOS.sh
 
 **HOW TO UNINSTALL Spotify after running this script:**
 
 If you don't like it after installing you can remove it running this command:
 
     rm -Rf $HOME/.local/bin/spotify $HOME/.local/share/applications/spotify.desktop $HOME/.local/share/spotify/
