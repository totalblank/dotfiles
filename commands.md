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

## Screen on for the current session

```Bash
xset s off         # disable screen saver
xset -dpms         # disable DPMS (Energy Star) features
xset s noblank     # disable screen blanking
```

## `suckless`

All the changes that is made in `config.def.h`, must also be made in `config.h`.

## Dual boot

When microsoft messes with the grub installation,

1. List all available drives and partitions with `ls`
2. Find the partition where grub is installed by repeatedly running `ls (hd1,gp1)`, until no option is left.
3. When the right partition is found and it has `/boot/grub` in it,
   ```Bash
   set root=(hd1,gpt4)
   set prefix=(hd1,gpt4)/boot/grub
   insmod normal
   normal
   ```
4. Grub should function normally now. Mount the `efi` directory to `/boot/efi` and run,
   ```Bash
   sudo grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
   sudo grub-mkconfig -o /boot/grub/grub.cfg
   ```
5. (Optional but recommended) nuke the windows installation.

# Download YouTube Videos

## Download a playlist

```Bash
yt-dlp -f "bv*[vcodec^=avc1]+ba[ext=m4a]/b[ext=mp4]" -S "vcodec:h264,res,acodec:m4a" --merge-output-format mp4 -o "%(playlist_index)03d - %(title)s.%(ext)s" 'https://www.youtube.com/playlist?list=PLoROMvodv4rMJqxxviPa4AmDClvcbHi6h'
```

# Neovim

## Save startup error message to a file

```Bash
nvim --cmd "redir! > nvim_error.txt" your_file.lua +q
```
