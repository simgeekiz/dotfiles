printerror () {
    echo "======================== ERROR ========================" >&2
    echo "$1" >&2
    echo "=======================================================" >&2
}

printlog () {
    echo
    echo "---------------------------------------------------------------------------" >&2
    echo "$1"
    echo "---------------------------------------------------------------------------" >&2
}

BASEDIR="$(pwd)"
REVOLTDIR=$HOME/Games/Re-Volt

if [ ! -d $REVOLTDIR ]; then
  mkdir $REVOLTDIR
fi

# Get operating system
revolt_launcher_link="unknown"
unamestr=$(uname)

if [[ $unamestr == "Linux" ]]; then
  revolt_launcher_link="https://rvgl.org/downloads/rvgl_launcher_linux.zip"
elif [[ $unamestr == "Darwin" ]]; then
  revolt_launcher_link="https://rvgl.org/downloads/rvgl_launcher_macos.zip"
fi

echo $revolt_launcher_link

printlog "Downloading the installation script"
if [ ! -f $REVOLTDIR/rvgl_launcher_linux.zip ]; then
  wget -P $REVOLTDIR $revolt_launcher_link
  unzip $REVOLTDIR/rvgl*.zip -d $REVOLTDIR
fi

if [ ! -f $REVOLTDIR/rvgl_launcher.py ]; then
  if [ -f $REVOLTDIR/rvgl_launcher_linux.zip ]; then
    unzip $REVOLTDIR/rvgl*.zip -d $REVOLTDIR
  else
    printerror "Unable to download the script!"
  fi
fi

if [ ! -d $REVOLTDIR/.env ]; then
  python3 -m venv $REVOLTDIR/.env
  . $REVOLTDIR/.env/bin/activate
elif [ -d $REVOLTDIR/.env ]; then
  . $REVOLTDIR/.env/bin/activate
fi

#required packages
if [[ $unamestr == "Linux" ]]; then
  printlog "Installing required system packages"
  sudo apt install python3-wxgtk4.0 python3-requests python3-packaging p7zip-full xdg-utils
  pip install requests
  pip install packaging wx
  python3 -m pip install -U -f https://extras.wxpython.org/wxPython4/extras/linux/gtk3/ubuntu-20.04 wxPython
  sudo apt-get install libgtk-3-dev libgl1-mesa-dev libglu1-mesa-dev libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev
  sudo apt-get install libsdl2-image-2.0-0
elif [[ $unamestr == "Darwin" ]]; then
  pip install requests
  pip install packaging wx
  # ...
fi

printlog "Initiating installation script"
python $REVOLTDIR/rvgl_launcher.py