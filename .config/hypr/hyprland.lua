-- Hyprland 0.55+ Lua configuration.
-- The old hyprland.conf is kept beside this file as a migration fallback.

local home = os.getenv("HOME")

-- Read pywal's legacy output so border colors continue to follow the wallpaper.
local wal = {}
local wal_file = io.open(home .. "/.cache/wal/colors-hyprland", "r")
if wal_file then
    for line in wal_file:lines() do
        local name, argb = line:match("%$([%w_]+)%s*=%s*(0x%x+)")
        if name and argb then
            wal[name] = "rgb(" .. argb:sub(-6) .. ")"
        end
    end
    wal_file:close()
end

local active_border = wal.color9 or "rgb(543FB8)"
local inactive_border = wal.color5 or "rgb(852191)"

-- Safe fallback for machines whose output names differ from this desktop.
hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = "auto",
})

hl.monitor({
    output = "DP-1",
    mode = "1920x1080@60.00",
    position = "1920x100",
    scale = 1.0,
})

hl.monitor({
    output = "DP-3",
    mode = "1920x1080@75.00",
    position = "0x0",
    scale = 1.0,
})

local terminal = "kitty"
local file_manager = "thunar"
local menu = "wofi -n"
local browser = "firefox"

hl.on("hyprland.start", function()
    hl.exec_cmd("hypridle")
    hl.exec_cmd("waybar")
    hl.exec_cmd("awww-daemon")
    hl.exec_cmd("sleep .5 && awww restore")
    hl.exec_cmd("swaync")
    hl.exec_cmd("pypr")
    hl.exec_cmd("swaync-client -df")
    hl.exec_cmd("pactl set-sink-mute @DEFAULT_SINK@ 0")
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE")
    hl.exec_cmd("ksecretd")
    hl.exec_cmd("swayosd-server -s " .. home .. "/.config/swayosd/style.css")
end)

hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")
hl.env("XCURSOR_THEME", "Bibata-Modern-Classic")
hl.env("XCURSOR_SIZE", "12")
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")

hl.config({
    general = {
        gaps_in = 2,
        gaps_out = 10,
        border_size = 0,
        col = {
            active_border = active_border,
            inactive_border = inactive_border,
        },
        resize_on_border = true,
        allow_tearing = false,
        layout = "dwindle",
    },
    decoration = {
        rounding = 10,
        active_opacity = 0.78,
        inactive_opacity = 0.7,
        fullscreen_opacity = 1,
        blur = {
            enabled = true,
            size = 3,
            passes = 5,
            ignore_opacity = true,
            xray = false,
            popups = true,
        },
        shadow = {
            enabled = true,
            range = 15,
            render_power = 5,
            color = "rgba(00000080)",
        },
    },
    xwayland = {
        force_zero_scaling = true,
    },
    animations = {
        enabled = true,
    },
    dwindle = {
        preserve_split = true,
    },
    misc = {
        force_default_wallpaper = -1,
        disable_hyprland_logo = true,
        focus_on_activate = true,
    },
    input = {
        kb_layout = "us",
        follow_mouse = 1,
        sensitivity = 0.35,
        touchpad = {
            natural_scroll = false,
            scroll_factor = 0.75,
        },
    },
    gestures = {
        workspace_swipe_distance = 700,
        workspace_swipe_min_speed_to_force = 20,
        workspace_swipe_use_r = true,
    },
})

hl.curve("fluid", {
    type = "bezier",
    points = { { 0.15, 0.85 }, { 0.25, 1 } },
})

hl.curve("snappy", {
    type = "bezier",
    points = { { 0.3, 1 }, { 0.4, 1 } },
})

hl.animation({ leaf = "windows", enabled = true, speed = 3, bezier = "fluid", style = "popin 5%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 2.5, bezier = "snappy" })
hl.animation({ leaf = "fade", enabled = true, speed = 4, bezier = "snappy" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 3, bezier = "snappy", style = "slide" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 5, bezier = "fluid", style = "slidefadevert -35%" })
hl.animation({ leaf = "layers", enabled = true, speed = 2, bezier = "snappy", style = "popin 70%" })

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 3, direction = "vertical", action = "special", workspace_name = "magic" })

hl.device({
    name = "epic-mouse-v1",
    sensitivity = 0,
})

local main_mod = "SUPER"

hl.bind(main_mod .. " + Q", hl.dsp.exec_cmd(terminal))
hl.bind(main_mod .. " + C", hl.dsp.window.close())
hl.bind(main_mod .. " + E", hl.dsp.exec_cmd(file_manager))
hl.bind(main_mod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(main_mod .. " + R", hl.dsp.exec_cmd(menu))
hl.bind(main_mod .. " + P", hl.dsp.window.pseudo())
hl.bind(main_mod .. " + J", hl.dsp.layout("togglesplit"))
hl.bind(main_mod .. " + F", hl.dsp.window.fullscreen_state({ internal = 2, client = 0 }))
hl.bind(main_mod .. " + B", hl.dsp.exec_cmd(browser))

hl.bind(main_mod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(main_mod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(main_mod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(main_mod .. " + down", hl.dsp.focus({ direction = "down" }))

for i = 1, 10 do
    local key = i % 10
    local monitor = i % 2 == 0 and "DP-1" or "DP-3"
    hl.workspace_rule({ workspace = tostring(i), monitor = monitor })
    hl.bind(main_mod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(main_mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

local osd = [[swayosd-client --monitor "$(hyprctl monitors -j | jq -r '.[] | select(.focused == true).name')"]]

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(osd .. " --output-volume raise"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(osd .. " --output-volume lower"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(osd .. " --output-volume mute-toggle"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd(osd .. " --input-volume mute-toggle"), { locked = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(osd .. " --brightness +10"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(osd .. " --brightness -10"), { locked = true, repeating = true })

hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

hl.bind("ALT + left", hl.dsp.window.move({ direction = "left" }))
hl.bind("ALT + right", hl.dsp.window.move({ direction = "right" }))
hl.bind("ALT + up", hl.dsp.window.move({ direction = "up" }))
hl.bind("ALT + down", hl.dsp.window.move({ direction = "down" }))

hl.bind("CTRL + Print", hl.dsp.exec_cmd("hyprshot -m region -o " .. home .. "/Screenshots/"))
hl.bind("Print", hl.dsp.exec_cmd("hyprshot -m window -o " .. home .. "/Screenshots/"))
hl.bind("ALT + Print", hl.dsp.exec_cmd("hyprshot -m active -m output -o " .. home .. "/Screenshots/"))

hl.bind(main_mod .. " + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind(main_mod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(main_mod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))
hl.bind(main_mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(main_mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind("ALT + TAB", hl.dsp.focus({ workspace = "previous" }))

hl.bind("ALT + W", hl.dsp.exec_cmd(home .. "/.config/hypr/wallpaper.sh"))
hl.bind("ALT + A", hl.dsp.exec_cmd(home .. "/.config/waybar/scripts/refresh.sh"))
hl.bind("ALT + B", hl.dsp.exec_cmd(home .. "/.config/waybar/scripts/select.sh"))
hl.bind("ALT + R", hl.dsp.exec_cmd(home .. "/.config/swaync/refresh.sh"))
hl.bind(main_mod .. " + M", hl.dsp.exit())
hl.bind(main_mod .. " + SPACE", hl.dsp.exec_cmd("pypr toggle term"))
hl.bind(main_mod .. " + G", hl.dsp.exec_cmd("pypr toggle music"))
hl.bind(main_mod .. " + T", hl.dsp.exec_cmd("pypr toggle taskbar"))

local function layer_rules(namespace, ignore_alpha)
    hl.layer_rule({
        name = "blur-" .. namespace,
        match = { namespace = namespace },
        blur = true,
    })
    hl.layer_rule({
        name = "ignore-alpha-" .. namespace,
        match = { namespace = namespace },
        ignore_alpha = ignore_alpha,
    })
end

layer_rules("waybar", 0.5)
layer_rules("swaync-control-center", 0.3)
layer_rules("swaync-notification-window", 0.3)
layer_rules("swayosd", 0.5)

hl.layer_rule({
    name = "no-animation-selection",
    match = { namespace = "selection" },
    no_anim = true,
})

hl.window_rule({
    name = "picture-in-picture",
    match = { title = "^(Picture-in-Picture)$" },
    float = true,
    pin = true,
    move = { 1232, 51 },
})
