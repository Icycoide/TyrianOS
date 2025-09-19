#!/bin/bash

set -ouex pipefail

function scriptcolors() {
    # Reset
    export Color_Off='\033[0m'       # Text Reset

    # Regular Colors
    export Black='\033[0;30m'        # Black
    export Red='\033[0;31m'          # Red
    export Green='\033[0;32m'        # Green
    export Yellow='\033[0;33m'       # Yellow
    export Blue='\033[0;34m'         # Blue
    export Purple='\033[0;35m'       # Purple
    export Cyan='\033[0;36m'         # Cyan
    export White='\033[0;37m'        # White
 
    # Bold
    export BBlack='\033[1;30m'       # Black
    export BRed='\033[1;31m'         # Red
    export BGreen='\033[1;32m'       # Green
    export BYellow='\033[1;33m'      # Yellow
    export BBlue='\033[1;34m'        # Blue
    export BPurple='\033[1;35m'      # Purple
    export BCyan='\033[1;36m'        # Cyan
    export BWhite='\033[1;37m'       # White
 
    # Underline
    export UBlack='\033[4;30m'       # Black
    export URed='\033[4;31m'         # Red
    export UGreen='\033[4;32m'       # Green
    export UYellow='\033[4;33m'      # Yellow
    export UBlue='\033[4;34m'        # Blue
    export UPurple='\033[4;35m'      # Purple
    export UCyan='\033[4;36m'        # Cyan
    export UWhite='\033[4;37m'       # White
 
    # Background
    export On_Black='\033[40m'       # Black
    export On_Red='\033[41m'         # Red
    export On_Green='\033[42m'       # Green
    export On_Yellow='\033[43m'      # Yellow
    export On_Blue='\033[44m'        # Blue
    export On_Purple='\033[45m'      # Purple
    export On_Cyan='\033[46m'        # Cyan
    export On_White='\033[47m'       # White

    # High Intensity
    export IBlack='\033[0;90m'       # Black
    export IRed='\033[0;91m'         # Red
    export IGreen='\033[0;92m'       # Green
    export IYellow='\033[0;93m'      # Yellow
    export IBlue='\033[0;94m'        # Blue
    export IPurple='\033[0;95m'      # Purple
    export ICyan='\033[0;96m'        # Cyan
    export IWhite='\033[0;97m'       # White

    # Bold High Intensity
    export BIBlack='\033[1;90m'      # Black
    export BIRed='\033[1;91m'        # Red
    export BIGreen='\033[1;92m'      # Green
    export BIYellow='\033[1;93m'     # Yellow
    export BIBlue='\033[1;94m'       # Blue
    export BIPurple='\033[1;95m'     # Purple
    export BICyan='\033[1;96m'       # Cyan
    export BIWhite='\033[1;97m'      # White

    # High Intensity backgrounds
    export On_IBlack='\033[0;100m'   # Black
    export On_IRed='\033[0;101m'     # Red
    export On_IGreen='\033[0;102m'   # Green
    export On_IYellow='\033[0;103m'  # Yellow
    export On_IBlue='\033[0;104m'    # Blue
    export On_IPurple='\033[0;105m'  # Purple
    export On_ICyan='\033[0;106m'    # Cyan
    export On_IWhite='\033[0;107m'   # White
    echo -e "${Purple}[i] The colour variables have been set.${Color_Off}"
}

limsg() {
    case $1 in
        s)
            lmsg_one="STAGE"
        ;;

    esac
    lmsg_two=$2
    case $3 in
        i)
            lmsg_three="${BBlue}INFO"
        ;;
        w)
            lmsg_three="${BYellow}WARN"
        ;;
        e)            
            lmsg_three="${BRed}ERRR"
        ;;
        *)
            lmsg_three=$3
        ;;
    esac
    echo -e "[TyrianOS Builder(LiMSG)/${BCyan}${lmsg_one} ${lmsg_two}${Color_Off}/${lmsg_three}${Color_Off}]: $4"
}

scriptcolors
### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

## Note from TyrianOS developer: Instructions unclear, only the free repos were enabled.
## Note from TyrianOS developer: ...None of the RPMfusion repositories were enabled...

#dnf5 install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y

# this installs a package from fedora repos


limsg s 1 i "Installing repositories: RPMFusion"
dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y

#### Add Fyra Labs Terra repository
limsg s 1 w "Installing repositories: Terra (No GPG Check)"
dnf5 install --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release -y

#### Install charmbracelet Gum
limsg s 1 i "Installing repositories: Charm (for Gum)"
echo '[charm]
name=Charm
baseurl=https://repo.charm.sh/yum/
enabled=1
gpgcheck=1
gpgkey=https://repo.charm.sh/yum/gpg.key' | tee /etc/yum.repos.d/charm.repo
rpm --import https://repo.charm.sh/yum/gpg.key

#### Install packages
limsg s 2 i "Installing packages: Tmux, Git"
dnf5 install -y tmux git

limsg s 2 i "Installing packages: Just"
dnf5 install -y just

limsg s 2 i "Installing packages: KDE Plasma Desktop, KDialog"
dnf5 install -y @kde-desktop kdialog

limsg s 2 i "Installing packages: Gum"
dnf install gum -y

limsg s 2 i "Installing packages: Yad"
dnf install yad -y

#### Install initial setup
limsg s 2 i "Installing packages: initial-setup-gui-wayland-plasma"
dnf5 install initial-setup-gui-wayland-plasma -y

#### Install KDE Plasma - Minimal
   # When forking, uncomment this line and comment the one above to install the minimal KDE suite instead
# dnf5 install -y NetworkManager-config-connectivity-fedora bluedevil breeze-gtk breeze-icon-theme cagibi colord-kde cups-pk-helper dolphin glibc-all-langpacks gnome-keyring-pam kcm_systemd kde-gtk-config kde-partitionmanager kde-print-manager kde-settings-pulseaudio kde-style-breeze kdegraphics-thumbnailers kdeplasma-addons kdialog kdnssd kf5-akonadi-server kf5-akonadi-server-mysql kf5-baloo-file kf5-kipi-plugins khotkeys kmenuedit konsole5 kscreen kscreenlocker ksshaskpass ksysguard kwalletmanager5 kwebkitpart kwin pam-kwallet phonon-qt5-backend-gstreamer pinentry-qt plasma-breeze plasma-desktop plasma-desktop-doc plasma-drkonqi plasma-nm plasma-nm-l2tp plasma-nm-openconnect plasma-nm-openswan plasma-nm-openvpn plasma-nm-pptp plasma-nm-vpnc plasma-pa plasma-user-manager plasma-workspace plasma-workspace-geolocation polkit-kde qt5-qtbase-gui qt5-qtdeclarative sddm sddm-breeze sddm-kcm sni-qt xorg-x11-drv-libinput setroubleshoot @"Hardware Support" @base-x @Fonts @"Common NetworkManager Submodules"
#### Install Firefox
#dnf5 install -y firefox
## Handled by first setup instead
#### Install fish(no)

#### (Re)install kernel
#dnf5 install -y kernel
#### Install Papirus
limsg s 3 i "Installing icon pack: Papirus"
dnf5 install papirus-icon-theme -y
# dnf5 install lightly-qt6  --nogpgcheck -y
#### Install Inter
limsg s 3 i "Installing font: Inter"
dnf5 install rsms-inter-fonts rsms-inter-vf-fonts -y
#### Install Monochrome-KDE
limsg s 3 i "Installing Monochrome-KDE: Cloning repository"
git clone https://github.com/pwyde/monochrome-kde
pushd monochrome-kde/ || false
	git checkout 20240410
	limsg s 3 i "Installing Monochrome-KDE: Copying SDDM theme"
	cp sddm/* -Rv /usr/share/sddm/
	limsg s 3 i "Installing Monochrome-KDE: Copying colour schemes"
	cp color-schemes/* -Rv /usr/share/color-schemes/
	limsg s 3 i "Installing Monochrome-KDE: Copying Plasma theme"
	cp plasma/* -Rv /usr/share/plasma/
	limsg s 3 i "Installing Monochrome-KDE: Copying GTK themes"
	cp gtk/* -Rv /usr/share/themes/
	limsg s 3 i "Installing Monochrome-KDE: Copying Aurorae themes"
	cp aurorae/* -Rv /usr/share/aurorae/
popd || false


#### Initialise skeleton
##Does not work
#cp -Rvf /etc/skel/*  /var/home/*/ || true
#cp -Rvf /etc/skel/.* /var/home/*/
####

#### Become compliant with Fedora guidelines, https://fedoraproject.org/wiki/Marketing/Branding
limsg s 4 i "Complying with Fedora guidelines: Removing branding as much as possible"
dnf -y remove fedora-bookmarks fedora-backgrounds-kde fedora-chromium-config fedora-chromium-config-kde

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File

#systemctl disable gdm
limsg s 5 i "Enabling SDDM"
systemctl enable sddm
