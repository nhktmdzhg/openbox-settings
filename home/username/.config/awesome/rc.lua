local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")

local wibox = require("wibox")

local beautiful = require("beautiful")

local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")

require("awful.hotkeys_popup.keys")

local super = "Mod4"
local alt = "Mod1"
local ctrl = "Control"
local shift = "Shift"

if awesome.startup_errors then
    naughty.notify({
        preset = naughty.config.presets.critical,
        title = "Oops, there were errors during startup!",
        text = awesome.startup_errors
    })
end

do
    local in_error = false
    awesome.connect_signal("debug::error", function(err)
        if in_error then return end
        in_error = true

        naughty.notify({
            preset = naughty.config.presets.critical,
            title = "Oops, an error happened!",
            text = tostring(err)
        })
        in_error = false
    end)
end

beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")

terminal = "alacritty"
editor = "nvim"
editor_cmd = terminal .. " -e " .. editor

awful.layout.layouts = {
    awful.layout.suit.floating
}

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock()

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
    awful.button({}, 1, function(t) t:view_only() end),
    awful.button({ super }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button({ super }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end),
    awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons = gears.table.join(
    awful.button({}, 1, function(c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal(
                "request::activate",
                "tasklist",
                { raise = true }
            )
        end
    end),
    awful.button({}, 4, function()
        awful.client.focus.byidx(1)
    end),
    awful.button({}, 5, function()
        awful.client.focus.byidx(-1)
    end))

local function set_wallpaper(s)
    local wallpaper_path = "/home/iamnanoka/wallpaper/march 7th 4k.jpg"
    gears.wallpaper.maximized(wallpaper_path, s, true)
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag({ "1" }, s, awful.layout.layouts[1])

    -- Create the wibox
    s.mywibox = awful.wibar({
        position = "top",
        screen = s,
        width = s.geometry.width - 10,
        height = 30,
        x = 5,
        y = 5,
        bg = "#00000000",
        fg = "#ffffff",
        shape = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, 10)
        end
    })

    s.mytasklist = awful.widget.tasklist {
        screen   = s,
        filter   = awful.widget.tasklist.filter.currenttags,
        buttons  = tasklist_buttons,
        style    = {
            shape_border_width = 1,
            shape_border_color = '#777777',
            shape  = gears.shape.rounded_rect,
        },
        layout   = {
            spacing = 4,
            layout  = wibox.layout.fixed.horizontal
        },
        widget_template = {
            {
                {
                    id     = "icon_role",
                    widget = wibox.widget.imagebox,
                    forced_width = 28,
                },
                margins = 2,
                widget  = wibox.container.margin,
            },
            id     = 'background_role',
            widget = wibox.container.background,
        },
    }

    local constrained_tasklist = wibox.container.constraint(s.mytasklist, "exact", nil, 32)

    -- Custom widgets
    local sep_left = wibox.widget {
        markup = "",
        align  = "center",
        valign = "center",
        widget = wibox.widget.textbox,
        font   = "Iosevka 14",

    }

    local arch_logo = wibox.widget {
        {
            {
                markup = "",
                align  = "center",
                valign = "center",
                widget = wibox.widget.textbox,
                font   = "Iosevka 14",
            },
            margins = 5,
            widget = wibox.container.margin,
        },
        widget = wibox.container.background,
        bg = "#f9f9f9ee",
        fg = "#434c5eff",
    }
    awful.tooltip {
        objects = { arch_logo },
        text = "[L] Main Menu [R] Extensions Menu"
    }

    arch_logo:connect_signal("button::press", function(_, _, _, button)
        if button == 1 then
            awful.spawn.with_shell("~/.config/rofi/scripts/rofi-main.sh")
        elseif button == 3 then
            awful.spawn.with_shell("~/.config/rofi/scripts/rofi-exts.sh")
        end
    end)

    arch_logo:connect_signal("mouse::enter", function()
        arch_logo.bg = "#f9f9f9cc"
    end)

    arch_logo:connect_signal("mouse::leave", function()
        arch_logo.bg = "#f9f9f9ee"
    end)

    local sep_right = wibox.widget {
        markup = '',
        align  = "center",
        valign = "center",
        widget = wibox.widget.textbox,
        font   = "Iosevka 14",
    }

    local mysystray = wibox.widget {
        wibox.widget.systray(),
        margins = 2,
        widget = wibox.container.margin
    }

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            sep_left,
            arch_logo,
            sep_right,
            mysystray,
        },
        {
            constrained_tasklist,
            halign = "center",
            valign = "center",
            widget = wibox.container.place,
        },
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            mytextclock
        },
    }
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({}, 4, awful.tag.viewnext),
    awful.button({}, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
local function toggle_show_desktop()
    local current_tag = awful.screen.focused().selected_tag
    local client_on_tag = current_tag:clients()
    if #client_on_tag > 0 then
        local is_show = false
        for _, c in ipairs(client_on_tag) do
            if c:isvisible() then
                is_show = true
                break
            end
        end
        if is_show then
            for _, c in ipairs(client_on_tag) do
                if c:isvisible() then
                    c.minimized = true
                end
            end
        else
            for _, c in ipairs(client_on_tag) do
                if not c:isvisible() then
                    c.minimized = false
                end
            end
        end
    end
end

switcher = require("awesome-switcher")

globalkeys = gears.table.join(
-- Brightness controls --
    awful.key({}, "XF86MonBrightnessUp", function()
        awful.spawn.with_shell("~/.scripts/change-brightness.sh +")
    end),
    awful.key({}, "XF86MonBrightnessDown", function()
        awful.spawn.with_shell("~/.scripts/change-brightness.sh -")
    end),
    -- Audio-volume controls --
    awful.key({}, "XF86AudioRaiseVolume", function()
        awful.spawn.with_shell("~/.scripts/change-volume.sh +")
    end),
    awful.key({}, "XF86AudioLowerVolume", function()
        awful.spawn.with_shell("~/.scripts/change-volume.sh -")
    end),
    awful.key({}, "XF86AudioMute", function()
        awful.spawn.with_shell("~/.scripts/change-volume.sh 0")
    end),
    awful.key({}, "XF86AudioPlay", function()
        awful.spawn.with_shell("playerctl play-pause")
    end),
    awful.key({}, "XF86AudioNext", function()
        awful.spawn.with_shell("playerctl next")
    end),
    awful.key({}, "XF86AudioPrev", function()
        awful.spawn.with_shell("playerctl previous")
    end),
    awful.key({}, "XF86AudioStop", function()
        awful.spawn.with_shell("playerctl play-pause")
    end),
    awful.key({}, "XF86AudioPause", function()
        awful.spawn.with_shell("playerctl play-pause")
    end),
    -- Window controls --
    awful.key({ alt }, "Tab", function()
        switcher.switch(1, alt, "Alt_L", shift, "Tab")
    end),
    awful.key({ alt, shift }, "Tab", function()
        switcher.switch(-1, alt, "Alt_L", shift, "Tab")
    end),
    -- Rofi controls --
    awful.key({ super }, "Escape", function()
        awful.spawn.with_shell("~/.config/rofi/scripts/rofi-exts.sh session")
    end),
    awful.key({ alt }, "F1", function()
        awful.spawn.with_shell("~/.config/rofi/scripts/rofi-main.sh")
    end),
    -- Screenshot controls --
    awful.key({}, "Print", function()
        awful.spawn("flameshot")
    end),
    awful.key({ ctrl }, "Print", function()
        awful.spawn("flameshot gui")
    end),
    -- Applications --
    awful.key({ super }, "e", function()
        awful.spawn("thunar")
    end),
    awful.key({ super }, "l", function()
        awful.spawn("betterlockscreen -l blur")
    end),
    awful.key({ ctrl, alt }, "t", function()
        awful.spawn.with_shell("XMODIFIERS= alacritty")
    end),
    awful.key({ ctrl, shift }, "Escape", function()
        awful.spawn.with_shell("XMODIFIERS= alacritty -e btop")
    end),
    -- Awesome --
    awful.key({ super, ctrl }, "r", awesome.restart),
    awful.key({ super, ctrl }, "q", awesome.quit),
    awful.key({ super }, "d", toggle_show_desktop)
)

root.keys(globalkeys)

clientkeys = gears.table.join(
    awful.key({ super, shift }, "Up", function(c)
        if c and c.floating then
            c:relative_move(0, -10, 0, 0)
        end
    end),
    awful.key({ super, shift }, "Down", function(c)
        if c and c.floating then
            c:relative_move(0, 10, 0, 0)
        end
    end),
    awful.key({ super, shift }, "Left", function(c)
        if c and c.floating then
            c:relative_move(-10, 0, 0, 0)
        end
    end),
    awful.key({ super, shift }, "Right", function(c)
        if c and c.floating then
            c:relative_move(10, 0, 0, 0)
        end
    end),

    awful.key({ super, ctrl }, "Up", function(c)
        if c and c.floating then
            c:relative_move(0, 0, 0, -10)
        end
    end),
    awful.key({ super, ctrl }, "Down", function(c)
        if c and c.floating then
            c:relative_move(0, 0, 0, 10)
        end
    end),
    awful.key({ super, ctrl }, "Left", function(c)
        if c and c.floating then
            c:relative_move(0, 0, -10, 0)
        end
    end),
    awful.key({ super, ctrl }, "Right", function(c)
        if c and c.floating then
            c:relative_move(0, 0, 10, 0)
        end
    end),
    -- Window controls --
    awful.key({ alt }, "F4", function(c)
        c:kill()
    end),
    awful.key({ super }, "f", function(c)
        c.fullscreen = not c.fullscreen
        c:raise()
    end),
    awful.key({ super }, "x", function(c)
        c.maximized = not c.maximized
        c:raise()
    end),
    awful.key({ super }, "z", function(c)
        c.minimized = not c.minimized
        if c.minimized then
            c:raise()
        end
    end)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
-- for i = 1, 1 do
--     globalkeys = gears.table.join(globalkeys,
--         -- View tag only.
--         awful.key({ super }, "#" .. i + 9,
--                   function ()
--                         local screen = awful.screen.focused()
--                         local tag = screen.tags[i]
--                         if tag then
--                            tag:view_only()
--                         end
--                   end,
--                   {description = "view tag #"..i, group = "tag"}),
--         -- Toggle tag display.
--         awful.key({ super, ctrl }, "#" .. i + 9,
--                   function ()
--                       local screen = awful.screen.focused()
--                       local tag = screen.tags[i]
--                       if tag then
--                          awful.tag.viewtoggle(tag)
--                       end
--                   end,
--                   {description = "toggle tag #" .. i, group = "tag"}),
--         -- Move client to tag.
--         awful.key({ super, shift }, "#" .. i + 9,
--                   function ()
--                       if client.focus then
--                           local tag = client.focus.screen.tags[i]
--                           if tag then
--                               client.focus:move_to_tag(tag)
--                           end
--                      end
--                   end,
--                   {description = "move focused client to tag #"..i, group = "tag"}),
--         -- Toggle tag on focused client.
--         awful.key({ super, ctrl, shift }, "#" .. i + 9,
--                   function ()
--                       if client.focus then
--                           local tag = client.focus.screen.tags[i]
--                           if tag then
--                               client.focus:toggle_tag(tag)
--                           end
--                       end
--                   end,
--                   {description = "toggle focused client on tag #" .. i, group = "tag"})
--     )
-- end

clientbuttons = gears.table.join(
    awful.button({}, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
    end),
    awful.button({ super }, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.move(c)
    end),
    awful.button({ super }, 3, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    {
        rule = {},
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap + awful.placement.no_offscreen,
        }
    }
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
    if awesome.startup
        and not c.size_hints.user_position
        and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({}, 1, function()
            c:emit_signal("request::activate", "titlebar", { raise = true })
            awful.mouse.client.move(c)
        end),
        awful.button({}, 3, function()
            c:emit_signal("request::activate", "titlebar", { raise = true })
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c):setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        {     -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton(c),
            awful.titlebar.widget.ontopbutton(c),
            awful.titlebar.widget.closebutton(c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

beautiful.focus_follows_mouse = false
beautiful.bg_systray = "#434c5eee"

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

awful.spawn("wmname 'iamnanokaWM'")

client.connect_signal("request::geometry", function(c)
    local screen = c.screen
    local wa = screen.workarea

    local margin_top    = 10
    local margin_bottom = 10
    local margin_left   = 10
    local margin_right  = 10

    if c.fullscreen then
        c.shape = gears.shape.rectangle
        return
    elseif c.maximized then
        -- Maximized nhưng vẫn có margin
        c:geometry {
            x = wa.x + margin_left,
            y = wa.y + margin_top,
            width  = wa.width - margin_left - margin_right,
            height = wa.height - margin_top - margin_bottom
        }
        c.shape = function(cr, w, h)
            gears.shape.rounded_rect(cr, w, h, 10)
        end
    else
        -- Cửa sổ bình thường
        c:geometry {
            x = wa.x + margin_left,
            y = wa.y + margin_top,
            width  = c.width,
            height = c.height
        }
        c.shape = function(cr, w, h)
            gears.shape.rounded_rect(cr, w, h, 6)
        end
    end
end)