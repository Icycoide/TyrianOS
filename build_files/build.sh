#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
dnf5 install -y tmux git
#### Add Fyra Labs Terra repository
dnf5 install --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release -y
#### Install KDE Plasma
dnf5 install -y @kde-desktop
#### Install KDE Plasma - Minimal
   # When forking, uncomment this line and comment the one above to install the minimal KDE suite instead
# dnf5 install -y NetworkManager-config-connectivity-fedora bluedevil breeze-gtk breeze-icon-theme cagibi colord-kde cups-pk-helper dolphin glibc-all-langpacks gnome-keyring-pam kcm_systemd kde-gtk-config kde-partitionmanager kde-print-manager kde-settings-pulseaudio kde-style-breeze kdegraphics-thumbnailers kdeplasma-addons kdialog kdnssd kf5-akonadi-server kf5-akonadi-server-mysql kf5-baloo-file kf5-kipi-plugins khotkeys kmenuedit konsole5 kscreen kscreenlocker ksshaskpass ksysguard kwalletmanager5 kwebkitpart kwin pam-kwallet phonon-qt5-backend-gstreamer pinentry-qt plasma-breeze plasma-desktop plasma-desktop-doc plasma-drkonqi plasma-nm plasma-nm-l2tp plasma-nm-openconnect plasma-nm-openswan plasma-nm-openvpn plasma-nm-pptp plasma-nm-vpnc plasma-pa plasma-user-manager plasma-workspace plasma-workspace-geolocation polkit-kde qt5-qtbase-gui qt5-qtdeclarative sddm sddm-breeze sddm-kcm sni-qt xorg-x11-drv-libinput setroubleshoot @"Hardware Support" @base-x @Fonts @"Common NetworkManager Submodules"
#### Install Firefox
dnf5 install -y firefox
#### Install fish
dnf5 install -y fish
#### (Re)install kernel
dnf5 install -y kernel
#### Install Papirus
dnf5 install papirus-icon-theme -y 
# dnf5 install lightly-qt6  --nogpgcheck -y
#### Install Inter
dnf5 install rsms-inter-fonts rsms-inter-vf-fonts -y
#### Install Monochrome-KDE
git clone https://github.com/pwyde/monochrome-kde
pushd monochrome-kde/ || false
	git checkout 20240410
	cp sddm/* -Rv /usr/share/sddm/
	cp color-schemes/* -Rv /usr/share/color-schemes/
	cp plasma/* -Rv /usr/share/plasma/
	cp gtk/* -Rv /usr/share/themes/
popd || false
#### 


# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File

systemctl disable gdm
systemctl enable sddm
