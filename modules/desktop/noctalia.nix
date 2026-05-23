{ config, pkgs, inputs, ... }:

{
  environment.systemPackages = [
    pkgs.quickshell
    inputs.noctalia-shell.packages.${pkgs.system}.default
  ];
}
