# My peak Openbox dotfiles
This is my personal Openbox configuration. It is a work in progress and will be updated as I continue to tweak it.  
Before you use this configuration, please make sure you have the following packages installed (for example in Arch-based distributions):
```bash
sudo pacman -S openbox betterlockscreen btop dunst fastfetch kvantum-qt5 obmenu-generator qt5ct rofi thunar tint2 xfce4-power-manager flameshot nitrogen rxvt-unicode-truecolor-wide-glyphs nm-applet picom perl-gtk3 alsa-utils brightnessctl wireless_tools xclip xsettingsd xss-lock thunar-archive-plugin thunar-volman gsimplecal pavucontrol polkit-gnome nvim neovide power-profiles-daemon upower
```
You should use my neovim configuration for the best experience.  
You can find it [here](https://github.com/nhktmdzhg/nvim).  
In my config, I also use the Kurinto font in many places. This is a very good font, covering many languages and has a lot of glyphs. You can download it [here](https://www.kurinto.com/download.htm).  
Maybe in this repo I forgot to add some neccessary files, so if you find any missing files, please put it on the issues tab, I will push the new commit as soon as possible.
## Screenshots
![Screenshot 1](meo/screenshot.png)
## Keyboard Shortcut
- Super + Shift + Left: Move window to the left
- Super + Shift + Right: Move window to the right
- Super + Shift + Up: Move window to the top
- Super + Shift + Down: Move window to the bottom
- Super + (1-9): Move to desktop (1-9) (I configured only 1 desktop, if you want more, you can edit the configuration in `rc.xml`)
- Super + Shift + (1-9): Move window to desktop (1-9) (Same as above)
- Alt + Space: Open Context Menu
- Alt + F4: Close window
- Super + D: Show desktop
- Super + F: Fullscreen
- Super + T: Show/Hide titlebar
- Super + X: Toggle maximize
- Super + Z: Iconify
- Alt + Tab: Switch window
- Alt + Shift + Tab: Switch window in reverse
- Super + Esc: Session menu
- Super + R: Open rofi menu
- PrtSc: Open flameshot
- Ctrl + PrtSc: Select area to screenshot
- Super + E: Open File Manager (Default: Thunar)
- Super + L: Lock screen (Default: betterlockscreen)
- Ctrl + Alt + T: Open terminal (Default: urxvt)
- Ctrl + Shift + Esc: Open btop

