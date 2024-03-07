{ config, lib, pkgs, ... }:

{
  imports =
    [ # Modules
      ./hardware-configuration.nix
    ];

# SYSTEM SETTINGS
  
  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Network
  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Time Zone
  time.timeZone = "Asia/Yekaterinburg";

  # User options 
  users.users.bodja = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker"]; 
  };
  
# SOFT
  
  # Enable non free soft
  nixpkgs.config.allowUnfree = true;

  # System soft
  environment.systemPackages = with pkgs; [
   
   # core utils
   gnumake
   gnutar
   zip
   unzip
   wget
   curl
   
   # cli program for administration ... and fastfetch
   kitty
   neovim 
   zsh
   git
   htop
   tmux
   ranger
   fastfetch
   
   # DevOps tools
   docker
   docker-compose
    
   # languages 
   cargo
   rustc
   go
   python312Full
   jdk21
   jdk21_headless
   gcc
   python312
   python312Packages.pip
   python312Packages.wheel
   python312Packages.venvShellHook
   python312Packages.tkinter
   python312Packages.pydevtool
   
   # system libs
   opusTools
   xorg.libX11
   xorg.xev
   alsa-utils
   yt-dlp

   # GUI soft
   vlc
   chromium
   kdePackages.dolphin
   feh
   telegram-desktop
   lutris-unwrapped
   transmission_4-gtk
   evince
   tor-browser
   flameshot
 
   # fonts, icons, themes
   nerdfonts

   # Enviroment soft
   dunst
   dmenu
   cmus
   picom

   # annymize tools
   tor
   sshuttle
   v2ray
   v2ray-geoip
   qv2ray
   i2p
   i2pd

  ];
 
  # Discord
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
             "discord-0.0.43"
  ];

# ENVIREMENT SETTINGS
  
  # Xserver
  services.xserver.enable = true;
  
  # Driver settings
  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver.videoDrivers = [ "amdgpu" ];
  environment.variables = {
  ROC_ENABLE_PRE_VEGA = "1";
  };
  
  # OoenCL
  hardware.opengl.extraPackages = with pkgs; [
  rocmPackages.clr.icd
  ];
  
  # Vulkan
  hardware.opengl.driSupport = true; # This is already enabled by default
  hardware.opengl.driSupport32Bit = true; # For 32 bit applications
  
  # AMDVLK
  #hardware.opengl.extraPackages = with pkgs; [
  #  amdvlk
  #];
  # For 32 bit applications 
  #hardware.opengl.extraPackages32 = with pkgs; [
  #  driversi686Linux.amdvlk
  #];


  # Disable display manager
  services.xserver.autorun = false;
  services.xserver.displayManager.startx.enable = true;


  # Enable Dwm
  services.xserver.windowManager.dwm.enable = true;
  # Dwm config
  services.xserver.windowManager.dwm.package = pkgs.dwm.overrideAttrs {
  src = /home/bodja/Builds/dwm-6.4;
  };
  

  # Enable sound.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Key board layouts
  services.xserver = {
    layout = "us,ru";
    xkbVariant = "qwerty";
    xkbOptions = "grp:alt_shift_toggle";
  };
  
  # Enable touchpad
  services.xserver.libinput.enable = true;
 
	
  # Fonts
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = ["Terminus"];})
  ];



# DEVELOPING
  
  # Shell
  programs.zsh.enable = true;
  programs.zsh.ohMyZsh = {
    enable = true;
    theme = "cloud";
  };
  users.defaultUserShell = pkgs.zsh;
 
  # Docker virt enable
  virtualisation.docker.enable = true;


  # Postgresql 
  services.postgresql = {
  enable = true;
  #package = pkgs.postgresql_15;
  ensureDatabases = [ "mydatabase" ];
    authentication = pkgs.lib.mkOverride 10 ''
      #type database  DBuser  auth-method
      local all       all     trust
    '';
  };
  


  # Version of NixOS
  system.stateVersion = "23.11"; # Did you read the comment?

}

