# ffmpeg

## Record screen with input audio (Linux)

Requires `xorg-xdpyinfo` to be installed.

```bash
ffmpeg -f x11grab -video_size $(xdpyinfo | grep 'dimensions:' | awk '{print $2;}') -i :0.0 -f alsa -i default -c:v libx264 -preset ultrafast -c:a aac -b:a 128k recorded_at-"`date +'%Y-%m-%d %H:%M:%S'`".mp4`
```

## Record screen with audio (Windows)


## Connect to wifi

```Bash
nmcli dev wifi list
nmcli dev wifi connect <SSID> password <password>
nmcli connection delete "NameOfWifi"
```

## Mirrors in Arch Linux

If, for some reason, `pacman` cannot download packages, go to `https://archlinux.org/mirrorlist/` and generate a mirrorlist
for your country. Copy the generated text into `/etc/pacman.d/mirrorlist`, save and exit. Then run `sudo pacman -Syu`.
It should be solved.

# Pandoc

- [Header Attributes](https://pandoc.org/MANUAL.html#extension-header_attributes)

# Misc Linux

If you want to execute something on login, put it in `.bash_profile`.

## Mounting an android device

The following one liner will extract the full `mtp` path(s) of the device(s),
```Bash

gio mount -l | grep -o 'mtp://[^ ]*'
```

If there are multiple devices connected, following will pick only the first one,

```Bash
gio mount -l | grep -o 'mtp://[^ ]*' | head -n 1
```

The following one-liner will mount the device,

```Bash
gio mount mtp://<device_mtp_location>/ && cd /run/user/$(id -u)/gvfs/
```

After typing `mtp`, press tab to autocomplete.

So, the following bash script will (untested) mount the android device, and open the folder,

```Bash
$DEV_MTP_NAME=$(gio mount -l | grep -o 'mtp://[^ ]*' | head -n 1)

if [ -n "$DEV_MTP_NAME" ]; then
    gio mount "$DEV_MTP_NAME"
    cd /run/user/$(id -u)/gvfs/$DEV_MTP_NAME
else
    echo "No MTP device found."
    exit 1
fi
```
