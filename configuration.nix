# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];
  # networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.wireless.userControlled.enable = true;

  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "America/Toronto";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  # networking.wireless.network = {
  #   tennis = {
  #     ssid = "Tennis";
  #     psk = "granola1";
  #     key_mgmt = "WPA-PSK";
  #   };
  # };
  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    # earlySetup = true;
    font = "Lat2-Terminus32";
    # keyMap = "us";
    useXkbConfig = true; # use xkbOptions in tty.
    packages = with pkgs; [ terminus_font ];
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  # services.xserver.desktopManager.lxqt.enable = true;
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;
  # services.xserver.windowManager.xmonad.enable = true;
  # services.xserver.desktopManager.xfce.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.gnome.games.enable = true;
  services.gnome.core-developer-tools.enable = true;
  services.xserver.displayManager.defaultSession = "gnome";
  
  # Configure keymap in X11
  services.xserver.layout = "us";
  # services.xserver.xkbOptions = {
  #   "eurosign:e";
  #   "caps:escape" # map caps to escape.
  # };
  services.xserver.videoDrivers = [ "modesetting" ];
  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = with pkgs; [gutenprint hplip];
  services.avahi.enable = true;
  services.avahi.nssmdns = true;
  # for WiFi printers
  services.avahi.openFirewall = true;
  
  # Enable sound.
  sound.enable = true;

  hardware.pulseaudio.enable = true;
  hardware.bluetooth.enable = true;
  
  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;
  # services.xserver.libinput.touchpad.tapping = false;
  services.xserver.libinput.touchpad.disableWhileTyping = true;
  # users.mutableUsers = false; # Interesting idea, but weird stuff happens when we enable this

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    users = {
      root = {
        isSystemUser = true;
        initialHashedPassword = "$y$j9T$zNa/iB3pfmWAPNvSkOp3f/$z8G0guj.21vQMCn3SnpZEoU8B4iBTCW6nj6S48Q/E79";
      };
      thomas = {
        # home = "/home/thomas"; # attributes createHome and home are already set for normal user
        isNormalUser = true;
        initialHashedPassword = "$y$j9T$zlZr.Kway2ROzyVnJt3DQ.$Qp.DiBD8XAorPVwMu/V/krjY2RiW.5JioBIHdDhSot3";
        extraGroups = [ "wheel" "networkmanager" "network" ]; # Enable ‘sudo’ for the user.
        packages = with pkgs; [
          gimp
          firefox
          transmission
          thunderbird
          discord
          inkscape
          chromium
          hexgui
          rtorrent
          # minecraft
          # dwarf-fortress
          zoom-us
          mcomix
          texmacs
          xournalpp
          libreoffice
          skypeforlinux
          calibre
        ];
      };
    };
  };
  programs.java.enable = true;
  # https://nixos.wiki/wiki/Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  nixpkgs.config.allowUnfree = true;
  # List packages installed in system profile. To search, run:
  # $ nix search wget

  environment.systemPackages = (with pkgs; [
    (import ./emacs.nix { inherit pkgs; }) # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    (python3.withPackages(ps: with ps; [ pandas requests]))
    mpv
    git
    gcc
    boost
    db
    clang
    purescript
    ocaml
    ghc
    feh
    zip
    unzip
    rar
    unrar
    haxe
    erlang
    rtorrent
    mpv
    racket
    ffmpeg_5-full
    xclip
    intel-ocl
    evince
    libtensorflow
    gnumake
    # Graphics drive stuffstuff
    intel-gpu-tools   
    vaapiIntel
    intel-media-driver
    opencl-info
    mesa
    vulkan-tools
    pciutils
    lshw
    glxinfo
  ]) ++ (with unstable; [
    texlive.combined.scheme-full
  ]) ++ (with pkgs.elmPackages; [
    elm
    elm-format
  ]);
  #++ (with pkgs.libsForQt5; [
  #   qtstyleplugin-kvantum
  #   qtstyleplugins
  #   kfind
  # ]);

  
  fonts.fonts = with pkgs; [
    cm_unicode
    dina-font
    dejavu_fonts
    eb-garamond
    fira
    fira-code
    fira-code-symbols
    fira-go
    fira-mono
    liberation_ttf
    libertinus
    lmmath
    lmodern
    mplus-outline-fonts.githubRelease
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    proggyfonts
    stix-two
    victor-mono
    xits-math
  ];
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html ).
  system.stateVersion = "23.05"; # Did you read the comment?

  hardware.opengl.extraPackages = with pkgs; [
    intel-compute-runtime
  ];
}

