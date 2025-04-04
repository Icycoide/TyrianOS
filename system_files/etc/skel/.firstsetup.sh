#!/bin/bash

read -rp "What kind of GPU do you have? (intel/amd/nvidia): " gpu_type

gpu_type=$(echo "$gpu_type" | tr '[:upper:]' '[:lower:]')

case "$gpu_type" in
  intel)
    echo "Installing Intel GPU drivers..."
    sudo rpm-ostree install intel-media-driver
    ;;
  amd)
    echo "Installing AMD GPU drivers..."
    sudo rpm-ostree override remove mesa-va-drivers --install mesa-va-drivers-freeworld
    sudo rpm-ostree override remove mesa-vdpau-drivers --install mesa-vdpau-drivers-freeworld
    ;;
  nvidia)
    echo "Installing NVIDIA GPU drivers..."
    sudo rpm-ostree install libva-nvidia-driver
    ;;
  *)
    echo "Unknown GPU type. Skipping GPU driver installation."
    ;;
esac

echo "Installing codecs and multimedia plugins..."
sudo rpm-ostree install gstreamer1-plugin-libav gstreamer1-plugins-bad-free-extras gstreamer1-plugins-bad-freeworld gstreamer1-plugins-ugly gstreamer1-vaapi
sudo rpm-ostree override remove libavcodec-free libavfilter-free libavformat-free libavutil-free libpostproc-free libswresample-free libswscale-free --install ffmpeg

echo "All done!"
