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

## `suckless`

All the changes that is made in `config.def.h`, must also be made in `config.h`.
