#!/bin/bash

echo "60" | sudo tee -a /sys/class/backlight/nvidia_0/brightness
