local awful = require("awful")
local gears = require("gears")

local scripts = {}

local function get_output_of_cmd(cmd)
    local handle = io.popen(cmd)
    local result = handle and handle:read("*a") or ""
    if handle then
        handle:close()
    end
    return result
end

function scripts.get_battery_icon()
    local output = get_output_of_cmd(
        "upower -i $(upower -e | grep BAT) 2>/dev/null | awk '/state|percentage/ {print $2}'")
    local lines = {}
    for line in output:gmatch("[^\r\n]+") do
        table.insert(lines, line)
    end

    if #lines < 2 then
        return nil
    end

    local status = lines[1]
    local percentage = tonumber(lines[2]:match("(%d+)"))

    local icons = {
        empty          = '',
        quarter        = '',
        half           = '',
        three_quarters = '',
        full           = '',
        charging       = ''
    }

    if status == "discharging" then
        if percentage <= 10 then
            return icons.empty
        elseif percentage <= 30 then
            return icons.quarter
        elseif percentage <= 50 then
            return icons.half
        elseif percentage <= 80 then
            return icons.three_quarters
        else
            return icons.full
        end
    else
        return icons.charging
    end
end

function scripts.get_battery_percent()
    local output = get_output_of_cmd(
        "upower -i $(upower -e | grep BAT) 2>/dev/null | awk '/state|percentage/ {print $2}'")
    local lines = {}
    for line in output:gmatch("[^\r\n]+") do
        table.insert(lines, line)
    end

    if #lines < 2 then
        return nil
    end

    local percentage = tonumber(lines[2]:match("(%d+)"))
    return percentage
end

function scripts.get_network_info(arg)
    local ethernet = get_output_of_cmd("ip addr show enp4s0")
    local ip_ethernet = ""
    for line in ethernet:gmatch("[^\r\n]+") do
        if line:find("inet ") then
            ip_ethernet = line:match("inet (%d+%.%d+%.%d+%.%d+)")
            break
        end
    end
    local essid = get_output_of_cmd("iwgetid -r")
    local icon, stat
    if ip_ethernet ~= "" then
        icon = ""
        stat = ip_ethernet
    elseif essid ~= "" then
        icon = ""
        stat = essid
    else
        icon = ""
        stat = "No Ethernet or Wi-Fi connected"
    end
    if arg == 0 then
        return icon
    elseif arg == 1 then
        return stat
    end
end

function scripts.get_volume_info(arg)
    if arg == 1 then
        awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%")
    elseif arg == -1 then
        awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%")
    elseif arg == 0 then
        awful.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle")
    end

    local vol_output = get_output_of_cmd("pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}' | tr -d '%'")
    local volume = tonumber(vol_output, 10)

    local mute_output = get_output_of_cmd("pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}'")
    local muted = mute_output:match("yes") ~= nil

    local icon, status

    if volume == 0 or muted then
        icon = ""
        status = "Muted"
    elseif volume < 30 then
        icon = ""
    elseif volume < 70 then
        icon = ""
    elseif volume <= 150 then
        icon = ""
    else
        awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ 150%")
        icon = ""
    end

    if arg == 2 then
        return icon
    elseif arg == 3 then
        return status or vol_output
    else
        return nil
    end
end

function scripts.change_brightness(arg)
    local brightness_val = tonumber(get_output_of_cmd("brightnessctl g"):match("(%d+)"))
    if arg == 1 then
        awful.spawn("brightnessctl set 5%+ -q")
    elseif arg == -1 then
        awful.spawn("brightnessctl set 5%- -q")
    end

    local max_brightness = tonumber(get_output_of_cmd("brightnessctl m"):match("(%d+)"))
    local brightness = math.floor((brightness_val / max_brightness) * 100)
    if arg == 1 then
        brightness = math.min(brightness + 5, 100)
    elseif arg == -1 then
        brightness = math.max(brightness - 5, 0)
    end
    local icon
    if brightness <= 10 then
        icon = 'display-brightness-low'
    elseif brightness <= 70 then
        icon = 'display-brightness-medium'
    else
        icon = 'display-brightness-high'
    end
    awful.spawn("dunstify \"" .. brightness .. "\" -h \"int:value:" .. brightness .. "\" -a joyful_desktop -h string:synchronous:display-brightness -i " .. icon .." -t 1000")
end

return scripts
