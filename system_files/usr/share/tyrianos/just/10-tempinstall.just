# Install package temporarily until next boot
temp-install +PKGS:
    #!/usr/bin/bash
    PKGS="{{ PKGS }}"
    echo "TyrianOS Developer Tools: Installing package $PKGS until next reboot"
    sudo dnf4 install $PKGS --transient
