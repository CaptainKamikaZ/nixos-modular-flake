{ config, pkgs, device, ... }:

let
  terminalCmd = if device == "thinkpad" then "foot" else "kitty";
  rawConfig = builtins.readFile ./config/niri.kdl;
  finalConfig = builtins.replaceStrings [ "@TERMINAL@" ] [ terminalCmd ] rawConfig;
in
{
  xdg.configFile."niri/config.kdl".text = ''

    // Desktop monitor layout
    ${if device == "desktop" then ''
      output "DP-3" {
        mode "1920x1080@60.000"
        scale 1
        transform "normal"
        position x=0 y=1080
        focus-at-startup
      }
      output "DP-2" {
        mode "1600x900@59.978"
        scale 1
        transform "270"
        position x=1920 y=700
      }
      output "HDMI-A-1" {
        mode "1920x1080@60.000"
        scale 1
        transform "normal"
        position x=0 y=0
      }
    '' else ''}

    // Laptop monitor layout
    ${if device == "thinkpad" then ''
      output "eDP-1" {
        mode "1337x768@60"
        scale 1.0
      }
    '' else ''}

    ${finalConfig}
  '';
}
