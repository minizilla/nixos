{ config, lib, pkgs, ... }@args:

{
  # Using the latest kernel, especially useful for arm64.
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernel.sysctl = {
    "net.core.rmem_max" = 2500000;
    "net.core.wmem_max" = 2500000;
  };

  # Hostname.
  networking.hostName = args.hostname;

  # Timezone.
  time.timeZone = "Asia/Jakarta";

  # Allow unfree packages.
  nixpkgs.config.allowUnfree = true;

  # Auto garbage collector.
  nix.gc = {
    automatic = true;
    options = "--delete-older-than 14d";
  };

  # Enable new nix cli and flakes.
  nix.extraOptions = ''
    experimental-features = nix-command flakes
    warn-dirty = false
    keep-outputs = true
    keep-derivations = true
  '';

  # Restrict user modification.
  users.mutableUsers = false;

  # No password for sudo.
  security.sudo.wheelNeedsPassword = false;

  # Single user.
  users.users.${args.user} = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    inherit (args) hashedPassword;
  };

  # A must have home-manager config.
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  # Single user home-manager.
  home-manager.users.${args.user} = {
    xdg.enable = true;
    gtk.enable = true;
    xsession.enable = true;
    home.stateVersion = args.stateVersion;
  };

  # Extra /etc/hosts.
  networking.hostFiles = [
    ../../etc/hosts/reddit
  ];

  # Default programs.
  programs.ssh.startAgent = true;
  programs.gnupg.agent.enable = true;
  programs.dconf.enable = true;

  # Enable Docker.
  virtualisation.docker.enable = true;
  users.extraGroups.docker.members = [ args.user ];

  # Default system packages.
  environment.systemPackages = with pkgs; [
    alacritty
    bat
    chromium
    camunda-modeler
    dbeaver
    direnv
    elasticsearch
    git
    htop
    killall
    kitty
    neofetch
    nix-direnv
    nordzy-cursor-theme # TODO: https://github.com/nix-community/home-manager/blob/948703f3e71f1332a0cb535ebaf5cb14946e3724/modules/config/home-cursor.nix#L167-L168
    pass
    rofi
    rofi-pass
    xclip
  ];

  environment.pathsToLink = [ "/share/nix-direnv" ];

  # Manage dotfiles using Homini.
  homini = {
    enable = true;
    dir = ../../dotfiles;
  };

  # Default shell for /bin/sh.
  environment.binsh = "${pkgs.dash}/bin/dash";

  hardware.opengl.enable = true;

  services.xserver = {
    enable = true;
    excludePackages = with pkgs; [ xterm ];
    desktopManager.xterm.enable = false;
    desktopManager.wallpaper.mode = "fill";
    displayManager.autoLogin.user = args.user;
    windowManager.bspwm.enable = true;
  };

  services.redis.servers."".enable = true;

  # Enable configured sets of packages.
  conf = {
    conky.enable = true;
    firefox.enable = true;
    fish.enable = true;
    fonts.enable = true;
    nvim.enable = true;
    picom.enable = true;
    syncthing = {
      enable = true;
      inherit (args) user;
    };
    systemd-boot = {
      enable = true;
      silent = true;
    };
  };

  # Do not modify this.
  system.stateVersion = args.stateVersion;
}
