#!/usr/bin/env perl

=for comment

    item:      add an item inside the menu               {item => ["command", "label", "icon"]},
    cat:       add a category inside the menu             {cat => ["name", "label", "icon"]},
    sep:       horizontal line separator                  {sep => undef}, {sep => "label"},
    pipe:      a pipe menu entry                         {pipe => ["command", "label", "icon"]},
    file:      include the content of an XML file        {file => "/path/to/file.xml"},
    raw:       any XML data supported by Openbox          {raw => q(...)},
    beg:       begin of a category                        {beg => ["name", "icon"]},
    end:       end of a category                          {end => undef},
    obgenmenu: generic menu settings                {obgenmenu => ["label", "icon"]},
    exit:      default "Exit" action                     {exit => ["label", "icon"]},

=cut

# NOTE:
#    * Keys and values are case sensitive. Keep all keys lowercase.
#    * ICON can be a either a direct path to an icon or a valid icon name
#    * Category names are case insensitive. (X-XFCE and x_xfce are equivalent)

require "$ENV{HOME}/.config/obmenu-generator/config.pl";

# Text editor
my $editor = $CONFIG->{editor};

our $SCHEMA = [
    {sep       => "MENU"},
    #              COMMAND                                                              LABEL                          ICON
    {beg       => [                                                                     "Applications",                 "$ENV{HOME}/.icons/Gladient/find.png"]},
    {cat       => ["utility",                                                           "Accessories",                  "applications-utilities"]},
    {cat       => ["development",                                                       "Development",                  "applications-development"]},
    {cat       => ["education",                                                         "Education",                    "applications-science"]},
    {cat       => ["game",                                                              "Games",                        "applications-games"]},
    {cat       => ["graphics",                                                          "Graphics",                     "applications-graphics"]},
    {cat       => ["audiovideo",                                                        "Multimedia",                   "applications-multimedia"]},
    {cat       => ["network",                                                           "Network",                      "applications-internet"]},
    {cat       => ["office",                                                            "Office",                       "applications-office"]},
    {cat       => ["other",                                                             "Other",                        "applications-other"]},
    {cat       => ["settings",                                                          "Settings",                     "applications-accessories"]},
    {cat       => ["system",                                                            "System",                       "applications-system"]},
    {end       => undef},
    {item      => ["$ENV{HOME}/.scripts/launch-apps.sh terminal",                       "Terminal",                     "$ENV{HOME}/.icons/Gladient/terminal.png"]},
    {item      => ["$ENV{HOME}/.scripts/launch-apps.sh file_manager",                   "File Manager",                 "$ENV{HOME}/.icons/Gladient/file-manager.png"]},
    {item      => ["arandr",                                                            "Multi Monitor Settings",       "$ENV{HOME}/.icons/Gladient/monitor-settings.png"]},
    {sep       =>                                                                       "SESSIONS"},
    {item      => ["$ENV{HOME}/.config/openbox/joyful-desktop/restart_ui.sh",           "Restart UI",                   "$ENV{HOME}/.icons/Gladient/restart-ui.png"]},
    {item      => ["$ENV{HOME}/.config/openbox/joyful-desktop/ob-button-set.sh",        "Change Window Button-Style",   "$ENV{HOME}/.icons/Gladient/ob-button-change.png"]},
    {item      => ["betterlockscreen -l blur",                                          "Lock",                         "$ENV{HOME}/.icons/Gladient/lock.png"]},
    {exit      => [                                                                     "Exit Openbox",                 "$ENV{HOME}/.icons/Gladient/logout.png"]},
]
