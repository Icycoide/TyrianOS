# Switch between Stable and EDGE (staging/testing) channels. Intended for developers only.
switch-channel BRANCH="":
        #!/usr/bin/bash
        BRANCH={{ BRANCH }}
        echo "TyrianOS Developer Tools: Changing release channel"
        case $BRANCH in
        	main)
        		gum confirm "You are about to switch to the main branch. Are you sure you want to proceed? Save all your work and shut down your applications before proceeding." || exit 1
        		rpm-ostree rebase ostree-unverified-registry:ghcr.io/icycoide/tyrianos:latest
				read -p "Press [ENTER] to reboot.";pkexec systemctl reboot -i
			;;
			edge|EDGE|staging|testing)
        		gum confirm "You are about to switch to the edge branch. This is an experimental branch and should not be used. Are you sure you want to proceed? Save all your work and shut down your applications before proceeding." || exit 1
        		rpm-ostree rebase ostree-unverified-registry:ghcr.io/icycoide/tyrianos-edge:latest
				read -p "Press [ENTER] to reboot.";pkexec systemctl reboot -i
			;;
			*)
				echo "Specify one of the release channels as argument: main, edge"
				exit 1
			;;
		esac
		exit 0
