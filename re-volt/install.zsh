# This script installs the Re-Volt game launcher and its dependencies.
# It is designed to work on both Linux and macOS systems.

REVOLTDIR=$HOME/Games/Re-Volt
GAMESDIR=$HOME/Games
if [ ! -d $GAMESDIR ]; then
  mkdir $GAMESDIR
fi

if [ ! -d $REVOLTDIR ]; then
  mkdir $REVOLTDIR
fi

# Get operating system
revolt_launcher_link="unknown"

case "$(uname -s)" in
  Darwin*)
    revolt_launcher_link="https://rvgl.org/downloads/rvgl_launcher_macos.zip"
    revolt_zip="$REVOLTDIR/rvgl_launcher_macos.zip"
    revolt_launcher_file="$REVOLTDIR/RVGL Launcher.app"
    ;;
  Linux*)
    revolt_launcher_link="https://rvgl.org/downloads/rvgl_launcher_linux.zip"
    revolt_zip="$REVOLTDIR/rvgl_launcher_linux.zip"
    revolt_launcher_file="$REVOLTDIR/rvgl_launcher.py"
    ;;
  *)
    echo "❌ Unsupported OS: $(uname)"
    echo "❗ Please check if you are running this on a supported OS (Linux or macOS)."
    exit 1
    ;;
esac

if [ ! -f $revolt_zip ]; then
  echo "Downloading the installation zip file..."
  wget -P $REVOLTDIR $revolt_launcher_link
  unzip $REVOLTDIR/rvgl*.zip -d $REVOLTDIR
fi

case "$(uname -s)" in
  Darwin*)
    if [ ! -d "$revolt_launcher_file" ]; then
      if [ -f $revolt_zip ]; then
        unzip $REVOLTDIR/rvgl*.zip -d $REVOLTDIR
      else
        echo "Something went wrong!"
      fi
    fi

    mv $HOME/Games/Re-Volt/RVGL\ Launcher.app /Applications/RVGL\ Launcher.app
    rm -r $HOME/Games/Re-Volt
    ;;
  Linux*)
    if [ ! -f $revolt_launcher_file ]; then
      if [ -f $revolt_zip]; then
        unzip $REVOLTDIR/rvgl*.zip -d $REVOLTDIR
      else
        echo "Something went wrong!"
      fi
    fi

    if [ ! -d $REVOLTDIR/.env ]; then
      python3 -m venv $REVOLTDIR/.env
      . $REVOLTDIR/.env/bin/activate
    elif [ -d $REVOLTDIR/.env ]; then
      . $REVOLTDIR/.env/bin/activate
    fi

    #required packages
    echo "Installing required system packages"
    sudo apt install python3-wxgtk4.0 python3-requests python3-packaging p7zip-full xdg-utils
    pip install requests
    pip install packaging wx
    python3 -m pip install -U -f https://extras.wxpython.org/wxPython4/extras/linux/gtk3/ubuntu-20.04 wxPython
    sudo apt-get install libgtk-3-dev libgl1-mesa-dev libglu1-mesa-dev libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev
    sudo apt-get install libsdl2-image-2.0-0

    python $revolt_launcher_file
    ;;
  *)
    echo "❌ Unsupported OS: $(uname)"
    echo "❗ Please check if you are running this on a supported OS (Linux or macOS)."
    exit 1
    ;;
esac
