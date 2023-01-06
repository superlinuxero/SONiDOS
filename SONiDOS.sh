#!/bin/bash

#
# Spotify On Newest i386 DistrOS (SONiDOS)
#


#
# Release 0.0.1
# This script is governed by the GPL Version 3 License
# This script is made by Ignacio Garcia <yo@ignasi.com>
# This script is originally located at:
#
#
# This is a script that will allow you to install the latest release
# published of Spotify 32-bits, on your modern and shiny i386 Linux Distro.
#
# Spotify chose long ago not to upgrade their i386 deb releases, leaving 
# many dependencies unmet in modern distributions, thus preveting its
# installation. This script will install it along with all dependencies
# in a quick way, no root access needed, and create an entry in your 
# Applications menu.
#
# IMPORTANT:
# This script uses wget, tar, and ar. Check that you have those programs
# in your system before running this script. And of course, you must have
# access to the Internet.
#
# ar, in debian, is included in the binutils package.
#
# WHAT THIS SCRIPT DOES:
# 1.- Creates a temporary directory (which will be deleted after install)
# 1.- Downloads and extracts the latest deb release of Spotify for i386.
# 2.- Downloads, extracts, and places in its directory numerous libraries
#     needed for Spotify to run
# 3.- Creates a wrapper named spotify.sh which will load the program and links
#     all shared libraries placed before in there. Also, a symlink to your
#     $HOME/.local/bin directory, if exists, will be created
# 4.- Creates a new .desktop file and places it in $HOME/.local/share/applications/
# 5.- Installs the program and all libraries to $HOME/.local/share/spotify
#
# The script is pretty simple, you just need pressing a key sometimes to continue.
#
# In some casses, a log-out and log-in may be necessary to see the entry in
# the Applications menu.


TEMP_DIR="/tmp/$USER-$RANDOM"
DESKTOP_FILE="$HOME/.local/share/applications/spotify.desktop"
INSTALL_DIR="$HOME/.local/share/spotify"



clear
echo
echo Spotify On Newest i386 DistrOS \(SONiDOS\)
echo ----------------------------------------
echo
echo WHAT THIS SCRIPT DOES:
echo
echo 1.- Creates a temporary directory $TEMP_DIR \(deleted after install\)
echo 1.- Downloads and extracts the latest deb release of Spotify for i386.
echo 2.- Downloads, extracts, and places in its directory numerous libraries
echo      needed for Spotify to run
echo 3.- Creates a wrapper named spotify.sh which will load the program and links
echo      all shared libraries placed before in there. Also, a symlink to your
echo      $HOME/.local/bin directory, if exists, will be created
echo 4.- Creates a new .desktop file $DESKTOP_FILE
echo 5.- Installs the the program and all libraries to $INSTALL_DIR
echo
echo The script is pretty simple, you just need pressing a key sometimes to continue.
echo In some casses, a log-out and a log-in may be necessary to see the entry in
echo the Applications menu.
echo
read -p "Press any key to continue or Ctrl-C to cancel"
clear

#
# Before running check for dependencies in our script and some potential drawbacks
#

# Don't run as root

if [ $EUID -eq 0 ] ; then echo "This script should not be run as root. Aborting."; exit 1; fi

# Check that external programs needed are installed

command -v wget >/dev/null 2>&1 || { echo -e "command wget not found. Aborting.\n"; exit 1; }
command -v tar >/dev/null 2>&1 || { echo -e "command tar not found. Aborting.\n"; exit 1; }
command -v ar >/dev/null 2>&1 || { echo -e "command ar not found (Please install binutils). Aborting.\n "; exit 1; }


# Don't mess with previous installations

[ -d "$INSTALL_DIR" ] && { echo -e "It seems you already have Spotify installed in $INSTALL_DIR\nAborting.\n"; exit 1; }
[ -d "$TEMP_DIR" ] && { echo -e "Temporary Working Directory $TEMP_DIR exists. Aborting.\n"; exit 1; }
[ -f "$DESKTOP_FILE" ] && { echo -e "Looks like you already have a Spotify entry in your\nPersonal Applicattions Menu. Aborting.\n"; exit 1; }



# 1.- Creating a temporary working directory

echo Creating a temporary working directory in $TEMP_DIR
echo

mkdir $TEMP_DIR
cd $TEMP_DIR

# 2.- Downloading Spotify and extracting contents

echo Downloading Spotify and extracting contents. Please be patient.
echo 

wget -q https://repository-origin.spotify.com/pool/non-free/s/spotify-client/spotify-client_1.0.72.117.g6bd7cc73-35_i386.deb
[ $? -eq 0 ]  || { echo "There was an error downloading Spotify. Aborting." ; rm -Rf $TEMP_DIR ; exit 1; }
mkdir spotifydebextract
ar x --output spotifydebextract/ spotify-client_1.0.72.117.g6bd7cc73-35_i386.deb
cd spotifydebextract
tar -zxf data.tar.gz
cd ..


# 2bis.- Downloading and extracting needed libraries

echo Downloading dependencies and extracting contents in temporary folders
echo 

wget -q http://security.debian.org/debian-security/pool/updates/main/o/openssl1.0/libssl1.0.2_1.0.2u-1~deb9u7_i386.deb
[ $? -eq 0 ]  || { echo "There was an error downloading libssl. Aborting." ; rm -Rf $TEMP_DIR ; exit 1; }
mkdir libssldebextract
ar x --output libssldebextract/ libssl1.0.2_1.0.2u-1~deb9u7_i386.deb 
cd libssldebextract
tar -xf data.tar.xz
cd ..

wget -q http://security.debian.org/debian-security/pool/updates/main/c/curl/libcurl3_7.52.1-5+deb9u16_i386.deb
[ $? -eq 0 ]  || { echo "There was an error downloading libcurl. Aborting." ; rm -Rf $TEMP_DIR ; exit 1; }
mkdir libcurl3debextract
ar x --output libcurl3debextract/ libcurl3_7.52.1-5+deb9u16_i386.deb
cd libcurl3debextract
tar -xf data.tar.xz
cd ..


wget -q http://http.us.debian.org/debian/pool/main/g/gconf/libgconf-2-4_3.2.6-7+b1_i386.deb
[ $? -eq 0 ]  || { echo "There was an error downloading libgconf. Aborting." ; rm -Rf $TEMP_DIR ; exit 1; }
mkdir libgconfdebextract
ar x --output libgconfdebextract/ libgconf-2-4_3.2.6-7+b1_i386.deb
cd libgconfdebextract
tar -xf data.tar.xz
cd ..


wget -q http://http.us.debian.org/debian/pool/main/a/alsa-lib/libasound2_1.2.4-1.1_i386.deb
[ $? -eq 0 ]  || { echo "There was an error downloading libasound. Aborting." ; rm -Rf $TEMP_DIR ; exit 1; }
mkdir libasound2debextract
ar x --output libasound2debextract/ libasound2_1.2.4-1.1_i386.deb
cd libasound2debextract
tar -xf data.tar.xz
cd .. 

wget -q http://http.us.debian.org/debian/pool/main/g/gcc-10/libatomic1_10.2.1-6_i386.deb
[ $? -eq 0 ]  || { echo "There was an error downloading libatomic. Aborting." ; rm -Rf $TEMP_DIR ; exit 1; }
mkdir libatomic1debextract
ar x --output libatomic1debextract/ libatomic1_10.2.1-6_i386.deb
cd libatomic1debextract
tar -xf data.tar.xz
cd ..

wget -q http://http.us.debian.org/debian/pool/main/g/glib2.0/libglib2.0-0_2.66.8-1_i386.deb
[ $? -eq 0 ]  || { echo "There was an error downloading libglib. Aborting." ; rm -Rf $TEMP_DIR ; exit 1; }
mkdir libglib2debextract
ar x --output libglib2debextract/ libglib2.0-0_2.66.8-1_i386.deb
cd libglib2debextract
tar -xf data.tar.xz
cd ..

wget -q http://http.us.debian.org/debian/pool/main/g/gtk+2.0/libgtk2.0-0_2.24.33-2_i386.deb
[ $? -eq 0 ]  || { echo "There was an error downloading libgtk. Aborting." ; rm -Rf $TEMP_DIR ; exit 1; }
mkdir libgtk2debextract
ar x --output libgtk2debextract/ libgtk2.0-0_2.24.33-2_i386.deb
cd libgtk2debextract
tar -xf data.tar.xz
cd ..


wget -q http://http.us.debian.org/debian/pool/main/g/gdk-pixbuf/libgdk-pixbuf-2.0-0_2.42.2+dfsg-1+deb11u1_i386.deb
[ $? -eq 0 ]  || { echo "There was an error downloading libgdk-pixbuf. Aborting." ; rm -Rf $TEMP_DIR ; exit 1; }
mkdir libgdkpixbufdebextract
ar x --output libgdkpixbufdebextract/ libgdk-pixbuf-2.0-0_2.42.2+dfsg-1+deb11u1_i386.deb
cd libgdkpixbufdebextract
tar -xf data.tar.xz
cd ..

wget -q http://http.us.debian.org/debian/pool/main/n/nss/libnss3_3.61-1+deb11u2_i386.deb
[ $? -eq 0 ]  || { echo "There was an error downloading libnss3. Aborting." ; rm -Rf $TEMP_DIR ; exit 1; }
mkdir libnss3debextract
ar x --output libnss3debextract/  libnss3_3.61-1+deb11u2_i386.deb
cd libnss3debextract
tar -xf data.tar.xz
cd ..

wget -q http://http.us.debian.org/debian/pool/main/libx/libxss/libxss1_1.2.3-1_i386.deb
[ $? -eq 0 ]  || { echo "There was an error downloading libxss1. Aborting." ; rm -Rf $TEMP_DIR ; exit 1; }
mkdir libxss1debextract
ar x --output libxss1debextract/ libxss1_1.2.3-1_i386.deb
cd libxss1debextract
tar -xf data.tar.xz
cd ..


wget -q http://http.us.debian.org/debian/pool/main/libx/libxtst/libxtst6_1.2.3-1_i386.deb
[ $? -eq 0 ]  || { echo "There was an error downloading libxtst6. Aborting." ; rm -Rf $TEMP_DIR ; exit 1; }
mkdir libxtst6debextract
ar x --output libxtst6debextract/ libxtst6_1.2.3-1_i386.deb
cd libxtst6debextract
tar -xf data.tar.xz
cd ..

wget -q http://http.us.debian.org/debian/pool/main/a/atk1.0/libatk1.0-0_2.36.0-2_i386.deb
[ $? -eq 0 ]  || { echo "There was an error downloading libatk. Aborting." ; rm -Rf $TEMP_DIR ; exit 1; }
mkdir libatkdebextract
ar x --output libatkdebextract/ libatk1.0-0_2.36.0-2_i386.deb
cd libatkdebextract
tar -xf data.tar.xz
cd ..

wget -q http://http.us.debian.org/debian/pool/main/libs/libssh2/libssh2-1_1.9.0-2_i386.deb
[ $? -eq 0 ]  || { echo "There was an error downloading libssh2. Aborting." ; rm -Rf $TEMP_DIR ; exit 1; }
mkdir libssh2debextract
ar x --output libssh2debextract/ libssh2-1_1.9.0-2_i386.deb
cd libssh2debextract
tar -xf data.tar.xz
cd ..

wget -q http://http.us.debian.org/debian/pool/main/o/openldap/libldap-2.4-2_2.4.47+dfsg-3+deb10u7_i386.deb
[ $? -eq 0 ]  || { echo "There was an error downloading libldap. Aborting." ; rm -Rf $TEMP_DIR ; exit 1; }
mkdir libldapdebextract
ar x --output libldapdebextract/ libldap-2.4-2_2.4.47+dfsg-3+deb10u7_i386.deb
cd libldapdebextract
tar -xf data.tar.xz
cd ..

wget -q http://http.us.debian.org/debian/pool/main/libx/libxdamage/libxdamage1_1.1.5-2_i386.deb
[ $? -eq 0 ]  || { echo "There was an error downloading libxdamage1. Aborting." ; rm -Rf $TEMP_DIR ; exit 1; }
mkdir libxdamage1debextract
ar x --output libxdamage1debextract/ libxdamage1_1.1.5-2_i386.deb
cd libxdamage1debextract
tar -xf data.tar.xz
cd ..

wget -q http://http.us.debian.org/debian/pool/main/libf/libffi/libffi7_3.3-6_i386.deb
[ $? -eq 0 ]  || { echo "There was an error downloading libffi7. Aborting." ; rm -Rf $TEMP_DIR ; exit 1; }
mkdir libffi7debextract
ar x --output libffi7debextract/ libffi7_3.3-6_i386.deb
cd libffi7debextract
tar -xf data.tar.xz
cd ..

wget -q http://http.us.debian.org/debian/pool/main/d/dbus-glib/libdbus-glib-1-2_0.110-6_i386.deb
[ $? -eq 0 ]  || { echo "There was an error downloading libdbus-glib. Aborting." ; rm -Rf $TEMP_DIR ; exit 1; }
mkdir libdbusglibdebextract
ar x --output libdbusglibdebextract/ libdbus-glib-1-2_0.110-6_i386.deb 
cd libdbusglibdebextract
tar -xf data.tar.xz
cd ..

wget -q http://http.us.debian.org/debian/pool/main/p/pango1.0/libpango-1.0-0_1.46.2-3_i386.deb
[ $? -eq 0 ]  || { echo "There was an error downloading libpango. Aborting." ; rm -Rf $TEMP_DIR ; exit 1; }
mkdir libpangodebextract
ar x --output libpangodebextract/ libpango-1.0-0_1.46.2-3_i386.deb
cd libpangodebextract
tar -xf data.tar.xz
cd ..

wget -q http://http.us.debian.org/debian/pool/main/p/pango1.0/libpangoft2-1.0-0_1.46.2-3_i386.deb
[ $? -eq 0 ]  || { echo "There was an error downloading libpangoft2. Aborting." ; rm -Rf $TEMP_DIR ; exit 1; }
mkdir libpangoft2debextract
ar x --output libpangoft2debextract/ libpangoft2-1.0-0_1.46.2-3_i386.deb
cd libpangoft2debextract
tar -xf data.tar.xz
cd ..

wget -q http://http.us.debian.org/debian/pool/main/libg/libglvnd/libgl1_1.3.2-1_i386.deb
[ $? -eq 0 ]  || { echo "There was an error downloading libgl1. Aborting." ; rm -Rf $TEMP_DIR ; exit 1; }
mkdir libgl1debextract
ar x --output libgl1debextract/ libgl1_1.3.2-1_i386.deb
cd libgl1debextract
tar -xf data.tar.xz
cd ..

wget -q http://http.us.debian.org/debian/pool/main/libg/libglvnd/libglx0_1.3.2-1_i386.deb
[ $? -eq 0 ]  || { echo "There was an error downloading libglx0. Aborting." ; rm -Rf $TEMP_DIR ; exit 1; }
mkdir libglx0debextract
ar x --output libglx0debextract/ libglx0_1.3.2-1_i386.deb
cd libglx0debextract
tar -xf data.tar.xz
cd ..


wget -q http://http.us.debian.org/debian/pool/main/libg/libglvnd/libgles2_1.3.2-1_i386.deb
[ $? -eq 0 ]  || { echo "There was an error downloading libgles2. Aborting." ; rm -Rf $TEMP_DIR ; exit 1; }
mkdir libglesdebextract
ar x --output libglesdebextract/ libgles2_1.3.2-1_i386.deb
cd libglesdebextract
tar -xf data.tar.xz
cd ..


wget -q http://http.us.debian.org/debian/pool/main/n/nspr/libnspr4_4.12-6_i386.deb
[ $? -eq 0 ]  || { echo "There was an error downloading libnspr4. Aborting." ; rm -Rf $TEMP_DIR ; exit 1; }
mkdir libnspr4debextract
ar x --output libnspr4debextract/ libnspr4_4.12-6_i386.deb
cd libnspr4debextract
tar -xf data.tar.xz
cd ..


echo Placing dependency libs in Spotify folder 
echo

mv spotifydebextract/usr/share/spotify .
cd spotify
mv ../libcurl3debextract/usr/lib/i386-linux-gnu/libcurl.so* .
mv ../libssldebextract/usr/lib/i386-linux-gnu/* .
mv ../libgconfdebextract/usr/lib/i386-linux-gnu/libgconf-2.so.* .
mv ../libasound2debextract/usr/lib/i386-linux-gnu/libasound.so* .
mv ../libatomic1debextract/usr/lib/i386-linux-gnu/libatomic.so* .
mv ../libglib2debextract/usr/lib/i386-linux-gnu/libgio-2* .
mv ../libglib2debextract/usr/lib/i386-linux-gnu/libglib-2* .
mv ../libglib2debextract/usr/lib/i386-linux-gnu/libgmodule-2* .
mv ../libglib2debextract/usr/lib/i386-linux-gnu/libgobject-2* .
mv ../libgtk2debextract/usr/lib/i386-linux-gnu/libg*k-x11-2.0.so* .
mv ../libgdkpixbufdebextract//usr/lib/i386-linux-gnu/libgdk_pixbuf-2.0.so* .
mv ../libnss3debextract/usr/lib/i386-linux-gnu/libnss* .
mv ../libnss3debextract/usr/lib/i386-linux-gnu/libssl3* .
mv ../libnss3debextract/usr/lib/i386-linux-gnu/nss .
mv ../libnss3debextract/usr/lib/i386-linux-gnu/libsmime3* .
mv ../libxss1debextract/usr/lib/i386-linux-gnu/libXss.so.* .
mv ../libxtst6debextract/usr/lib/i386-linux-gnu/libXtst.so.* . 
mv ../libatkdebextract//usr/lib/i386-linux-gnu/libatk-1.0.so* .
mv ../libssh2debextract/usr/lib/i386-linux-gnu/libssh2.so* .
mv ../libldapdebextract/usr/lib/i386-linux-gnu/libl*so.* .
mv ../libxdamage1debextract/usr/lib/i386-linux-gnu/libXdamage.so.* .
mv ../libffi7debextract/usr/lib/i386-linux-gnu/libffi.so* .
mv ../libdbusglibdebextract/usr/lib/i386-linux-gnu/libdbus-glib-1.so.* .
mv ../libpangodebextract/usr/lib/i386-linux-gnu/libpango-1.0.so.* .
mv ../libpangoft2debextract/usr/lib/i386-linux-gnu/libpangoft2-1.0.so.* .
mv ../libgl1debextract/usr/lib/i386-linux-gnu/libGL.so.* .
mv ../libglx0debextract/usr/lib/i386-linux-gnu/libGLX.so.* .
mkdir swiftshader
mv ../libglesdebextract/usr/lib/i386-linux-gnu/libGLESv* swiftshader 
cd swiftshader
ln -s libGLESv2.so.2.1.0 libGLESv2.so
cd ..
mv ../libnspr4debextract/usr/lib/i386-linux-gnu/lib* .



# 3.- Creating a wrapper named spotify.sh 

echo Creating the wrapper
echo 

cat <<EOF > spotify.sh
#!/bin/bash
PROGRAM_DIR="\`dirname "\$0"\`"
export LD_LIBRARY_PATH="\$PROGRAM_DIR"
"\$PROGRAM_DIR/spotify" "\$@"
EOF

chmod a+x spotify.sh

mv spotify.desktop spotify.desktop.original


# 4.- Creating $DESKTOP_FILE

echo Creating $DESKTOP_FILE
echo 

cat <<EOF > spotify.desktop
[Desktop Entry]
Name=Spotify
GenericName=Music Player
Comment=Spotify streaming music client
Icon=spotify-client
Exec=$INSTALL_DIRspotify/spotify.sh %U
Terminal=false
Type=Application
Categories=Audio;Music;Player;AudioVideo;
MimeType=x-scheme-handler/spotify;
EOF



mv spotify.desktop $DESKTOP_FILE
cd ..


# 5.- Moving everything else to their location

echo Moving the new spotify folder to $INSTALL_DIR
echo 

mv spotify $INSTALL_DIR


# and cleaning up...


echo Cleaning up
echo 

rm -Rf $TEMP_DIR

read -p "Press any key to continue"
clear
echo This script has finished. Your Spotify installation is in
echo
echo $INSTALL_DIR
echo 
echo Also, $DESKTOP_FILE has been created
echo 

# If your have a .local/bin folder in your home directory
# this script will create a link to launch spotify from
# your command line

[ -d $HOME/.local/bin ] && { ln -sf $INSTALL_DIR/spotify.sh $HOME/.local/bin/spotify ; echo -e "Finally a symkink in $HOME/.local/bin has been created.\nType spotify to run it from a console window" ; }

echo
echo If there is no entry appearing in your Applications menu
echo logout and login and try again
echo
echo Bye now!
echo


