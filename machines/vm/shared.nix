{ config, lib, pkgs, user, ... }:

{
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # No fancy networking setup on VM.
  networking.hostName = "dev";
  networking.useDHCP = false;

  # Halo Dunia!
  time.timeZone = "Asia/Jakarta";

  # Run VM on HiDPI machines.
  hardware.video.hidpi.enable = true;

  # Nix settings.
  nix.extraOptions = ''
    experimental-features = nix-command flakes
    keep-outputs = true
    keep-derivations = true
  '';

  # Nixpkgs settings.
  nixpkgs.config.allowUnfree = true;

  # Composite manager.
  services.picom.enable = true;

  # SSH and GPG.
  programs.ssh.startAgent = true;
  #programs.gnupg.agent.enable = true;

  # System packages.
  environment.systemPackages = with pkgs; [
    bat
    editorconfig-checker
    firefox
    gnumake
    htop
    killall
    neofetch
    xclip
  ];

  # Enable configured set of pkgs.
  conf = {
    alacritty.enable = true;
    backgrounds.enable = true;
    direnv.enable = true;
    fonts.enable = true;
    git.enable = true;
    kitty.enable = true;
    nvim.enable = true;
    rofi.enable = true;
    syncthing = {
      enable = true;
      inherit user;
    };
    systemd-boot = {
      enable = true;
      silent = true;
    };
    xserver = {
      enable = true;
      autoLoginUser = user;
      windowManager.bspwm.enable = true;
    };
  };
}