Modified and expanded from github.com/elifouts/Dotfiles.

## Audio controls

The default Waybar layout includes output volume, a draggable volume slider,
and microphone level. Click **Vol** or **Mic** to open the corresponding tab in
the graphical audio mixer (pavucontrol). Scroll over a label to adjust its level,
or right-click it to toggle mute.

Dedicated volume and microphone buttons work through PipeWire's `wpctl`, with
notification feedback. These controls do not require swayosd or an Fn key.

| Shortcut | Action |
| --- | --- |
| Super+A | Open audio settings |
| Super+= | Raise volume by 5%, up to 100% |
| Super+− | Lower volume by 5% |
| Super+Shift+M | Toggle microphone mute |

The Lua Hyprland configuration also opens the mixer as a centered, opaque,
floating window. The legacy configuration includes the same audio shortcuts.
The full and Waybar installers include `pavucontrol`, `wireplumber` (provides
`wpctl`), and `libnotify` (provides `notify-send`). PipeWire with
`pipewire-pulse` must be running for the bar and mixer.

If no microphone appears, open the mixer's **Configuration** tab and select an
input-capable profile such as **Analog Stereo Duplex**. Then select the correct
port and default input under **Input Devices**. Hardware-specific device names
and microphone ports are configured on each machine rather than hardcoded here.
