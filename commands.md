# ffmpeg

## Record screen with audio (Linux)

Requires `xorg-xdpyinfo` to be installed.

```bash
ffmpeg -f x11grab -video_size $(xdpyinfo | grep 'dimensions:' | awk '{print $2;}') -i :0.0 -f alsa -i default -c:v libx264 -preset ultrafast -c:a aac -b:a 128k recorded_at-"`date +'%Y-%m-%d %H:%M:%S'`".mp4`
```

## Record screen with audio (Windows)

