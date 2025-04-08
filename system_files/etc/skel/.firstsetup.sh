#!/bin/bash


source /etc/os-release
export Color_Off='\033[0m'       # Text Reset
export BRed='\033[1;31m'         # Red
export White='\033[0;37m'        # White
export BIWhite='\033[1;97m'      # White


# read -rp "What kind of GPU do you have? (intel/amd/nvidia): " gpu_type

# gpu_type=$(echo "$gpu_type" | tr '[:upper:]' '[:lower:]')

function tus.start {
  kquitapp6 plasmashell
  echo -e "${BIWhite}Welcome${Color_Off}"
  echo -e "${White}${NAME} ${VERSION_ID}"
  echo -e "Website: ${HOME_URL}"
  read -rp "[ENTER]" >/dev/null
}

function tus.networking {
  option=$(gum choose --header="Would you like to set up Networking?" "Yes" "Skip")
  case "$option" in
    Yes)
      kcmshell6 kcm_networkmanagement
      ;;
    Skip)
      echo "Skipped networking setup."
      ;;
  esac
}

function tus.account {
  option=$(gum choose --header="Would you like to customise your account further?" "Yes" "Skip")
  case "$option" in
    Yes)
      kcmshell6 kcm_users
      ;;
    Skip)
      echo "Skipped account setup."
      ;;
  esac
}

function tus.drivers {
  gpu_type=$(gum choose --header="What kind of GPU do you have?" "Intel" "AMD" "Nvidia")
  case "$gpu_type" in
    intel|Intel)
      gum spin --title="Installing Intel GPU drivers..." -- pkexec rpm-ostree install intel-media-driver -y || bail "GPU driver installation failed"
      ;;
    amd|AMD)
      gum spin --title="Installing AMD GPU drivers..." -- pkexec rpm-ostree override remove mesa-va-drivers --install mesa-va-drivers-freeworld -y || bail "GPU driver installation failed"
      gum spin --title="Hold on a bit more..." -- pkexec rpm-ostree override remove mesa-vdpau-drivers --install mesa-vdpau-drivers-freeworld -y || bail "GPU driver installation failed"
      ;;
    nvidia|Nvidia)
      gum spin --title="Installing NVIDIA GPU drivers..." -- pkexec rpm-ostree install libva-nvidia-driver -y || bail "GPU driver installation failed"
      ;;
    *)
      echo "Unknown GPU type. Skipping GPU driver installation."
      ;;
  esac
}

function tus.end {
  gum spin --title="Installing codecs and multimedia plugins..." -- pkexec rpm-ostree install -y gstreamer1-plugin-libav gstreamer1-plugins-bad-free-extras gstreamer1-plugins-bad-freeworld gstreamer1-plugins-ugly gstreamer1-vaapi -y
  gum spin --title="Still installing codecs and multimedia plugins..." -- pkexec rpm-ostree override remove libavcodec-free libavfilter-free libavformat-free libavutil-free libpostproc-free libswresample-free libswscale-free --install ffmpeg -y

  pkexec rm /etc/.tuspending
  kstart plasmashell &
  echo "All done!"
  option=$(gum choose --header="What do you want to do next?" "Open Settings" "Install apps" "Quit")
  case "$option" in
    "Open Settings")
      systemsettings
      ;;
    "Install apps")
      plasma-discover
      ;;
    Quit)
      exit
      ;;
    *)
      echo "?."
      ;;
  esac
  option=$(gum choose --header="To finish the installation of GPU drivers, a reboot is pending. Do you want to reboot now or later?" "Restart now" "Later")
  case "$option" in
    "Restart now")
      systemctl reboot -i
      ;;
    "Later")
      echo "OK"
      ;;
  esac
  read -rp "Thank you for installing TyrianOS! [ENTER]" >/dev/null
}

main() {
  tus.start
  tus.networking
  tus.account
  tus.drivers
  tus.end
}

bail() { echo -e "${BRed}ERROR: First time setup failed with the following message:${Color_Off} $1"; read; exit 1; }

if [ -f "/etc/.tuspending" ]; then
    main
fi

exit
