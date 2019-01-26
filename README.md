### Install NVIDIA driver.
1. Download driver from https://www.geforce.com/drivers
2. Install Prerequisites:
```
sudo dpkg --add-architecture i386 && sudo apt update && sudo apt install build-essential libc6:i386
```
3. Disable Wayland:
```
sed -i -e 's/#WaylandEnable/WaylandEnable/g'  /etc/gdm3/custom.conf
```
4. Disable Nouveau driver:
```
sudo bash -c "echo blacklist nouveau > /etc/modprobe.d/blacklist-nvidia-nouveau.conf"
sudo bash -c "echo options nouveau modeset=0 >> /etc/modprobe.d/blacklist-nvidia-nouveau.conf"
sudo update-initramfs -u
sudo reboot
```
5. Install downloaded NVIDIA driver:
```
sudo telinit 3
cd /folder/with/downloaded/driver
sudo bash NVIDIA-*.run
# Accept License
# The distribution-provided pre-install script failed! Are you sure you want to continue? -> CONTINUE INSTALLATION
# Would you like to run the nvidia-xconfig utility? -> YES
sudo reboot
```
### Fix for the realtek audio chip heat (disable onboard audio).
Add this lines to the end of the file **/etc/modprobe.d/blacklist.conf**:
```
# Disable onboard audio
blacklist snd_hda_codec_generic
blacklist snd_hda_codec_realtek
blacklist snd_hda_intel
blacklist snd_hda_codec
blacklist snd_hda_core
```
Or just run this command in terminal:

```
echo -e "\n# Disable onboard audio \nblacklist snd_hda_codec_generic \nblacklist snd_hda_codec_realtek \nblacklist snd_hda_intel \nblacklist snd_hda_codec \nblacklist snd_hda_core" | sudo tee --append /etc/modprobe.d/blacklist.conf
```
### Fix for broken brightness level change.
1. Add backlight handler to GRUB cmdline. Open file **/etc/default/grub** with sudo and replace your default **GRUB_CMDLINE_LINUX_DEFAULT** with:
```
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash nvidia.NVreg_EnableBacklightHandler=1"
```
2. Update grub by executing **sudo update-grub** in terminal.
### Set brightness level at boot.
After each boot brightness level will reset to 100%. We can create service that will apply desired brightness level in 1 minute after system boot. You can change this level in **brightness.sh** file. By default it's set to 60%.
1. Copy files **brightness.service** and **brightness.timer** to /etc/systemd/system/ folder.
2. Copy file **brightness.sh** to /opt/bin/ folder and make it executable:
```
sudo chmod u+x /opt/bin/brightness.sh
```
3. Enable and start **brightness.timer** service:
```
sudo systemctl enable brightness.timer && sudo systemctl start brightness.timer
```
### Fix for not working touchpad (and also fix for broken touchpad after Hibernation in Windows).
We have some bugs in our touchpad firmware and can fix it with new firmware version.
1. Boot in Windows.
2. Extract **WinIAP_Fix Touchpad.zip**.
3. Start **WinIAP_X64.exe**.
4. Select "Load Bin File" and select the file **SB463D-1407_Fv0x06.bin**.
5. After the .bin file is loaded click "Update Rom" (do nothing before the update process is finished).
6. When the update is finished, close the program and reboot your computer.
