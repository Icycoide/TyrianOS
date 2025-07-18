# Switch between Stable and EDGE (staging/testing) channels. Intended for developers only.
switch-channel BRANCH="":
    #!/usr/bin/bash

    bail() {
    	kdialog --error "$1."
    	exit 1;
    }

    BRANCH={{ BRANCH }}
    echo "TyrianOS Developer Tools: Changing release channel"
    case $BRANCH in
    	main)
    		kdialog --title "Change release channel" --warningcontinuecancel "You are about to switch to the main branch. Are you sure you want to proceed? Save all your work and shut down your applications before proceeding." || exit 1
    		rpm-ostree rebase ostree-unverified-registry:ghcr.io/icycoide/tyrianos:latest || bail "Failed to rebase to $BRANCH"
    		kdialog --msgbox "Click OK to reboot.";pkexec systemctl reboot -i || bail "Failed to call to reboot."
    	;;
    	edge|EDGE|staging|testing)
    		kdialog --title "Change release channel" --warningcontinuecancel "You are about to switch to the edge branch. This is an experimental branch and should not be used. Are you sure you want to proceed? Save all your work and shut down your applications before proceeding." || exit 1
    		rpm-ostree rebase ostree-unverified-registry:ghcr.io/icycoide/tyrianos-edge:latest || bail "Failed to rebase to $BRANCH"
    		kdialog --msgbox "Click OK to reboot.";pkexec systemctl reboot -i || bail "Failed to call to reboot."
    	;;
    	*)
    		echo "Specify one of the release channels as argument: main, edge"
    		exit 1
    	;;
    esac
    exit 0
