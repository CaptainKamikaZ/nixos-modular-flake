{ config, pkgs, device, ... }:

let
  # Choose terminal based on device
  terminalCmd =
    if device == "thinkpad" then "foot"
    else if device == "hp-laptop" then "foot"
    else "kitty";

  # Load your base KDL config
  rawConfig = builtins.readFile ./config/niri.kdl;

  # Replace @TERMINAL@ placeholder
  finalConfig = builtins.replaceStrings
    [ "@TERMINAL@" ]
    [ terminalCmd ]
    rawConfig;

  # Desktop monitor layout
  desktopOutputs = ''
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
  '';

  # ThinkPad monitor layout (example — adjust if needed)
  thinkpadOutputs = ''
    output "eDP-1" {
      mode "1920x1080@60"
      scale 1.25
      transform "normal"
    }
  '';

  # HP laptop monitor layout (your actual hardware)
  hpLaptopOutputs = ''
    output "eDP-1" {
      mode "1920x1080@60.01"
      scale 1.5
      transform "normal"
    }
  '';

  # Choose output config based on device
  outputConfig =
    if device == "desktop" then desktopOutputs
    else if device == "thinkpad" then thinkpadOutputs
    else if device == "hp-laptop" then hpLaptopOutputs
    else "";
in
{
  # Install final config into ~/.config/niri/config.kdl
  xdg.configFile."niri/config.kdl".text =
    ''
      // Output configuration injected by Home Manager
      ${outputConfig}
    ''
    + finalConfig;
}
