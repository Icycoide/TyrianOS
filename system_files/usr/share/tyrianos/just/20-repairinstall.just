repair-options ACTION="" ADDITIONAL_OPTIONS="":
	#!/bin/bash
	ACTION={{ ACTION }}
	ADDITIONAL_OPTIONS={{ ADDITIONAL_OPTIONS }}
	case "$ACTION" in
		repair)
			mkdir $HOME/.var/log/tyrianos/ -pv || true
			read -pr "Save all work and close all applications, then press [ENTER]"
			echo "Repair log will be saved in $HOME/.var/log/tyrianos/"
			sleep 1
			full_repair | tee $HOME/.var/log/tyrianos/OS_Repair-$(date +%F-%H-%M-%S)
			reboot
		;;
		reset)
			echo "not implemented yet"
		;;
		*)
			echo "
		repair-options repair - Tries to repair the TyrianOS installation"
		;;
	esac

	full_repair() {
		sudo flatpak upgrade -y
		rpm-ostree rebase $(rpm-ostree status --booted --json | jq -r '.deployments[] | select(.booted) | ."container-image-reference"')
		rpm-ostree update
		distrobox upgrade -a -v
		sudo flatpak repair -y
		flatpak repair --user -y
	}
