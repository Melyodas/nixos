# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Set your time zone.
  time.timeZone = "Europe/Paris"; # NOTE: to change

  networking.hostName = "claptrap"; # Define your hostname. # NOTE: to change
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  # networking.useDHCP = true;
  networking.interfaces.enp2s0.useDHCP = true; # NOTE: to change

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "fr-bepo";
  };

  # file system
  # /tmp
  boot.cleanTmpDir = true;
  boot.tmpOnTmpfs = true;

  # Display
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" ]; # NOTE: to change
  services.xserver.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;
  };
  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Configure keymap in X11
  services.xserver.layout = "fr";
  services.xserver.xkbVariant = "bepo";
  # services.xserver.xkbOptions = "eurosign:e";
  # services.upower.enable = true; # enable org.freedesktop.UPower

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  # Bluetooth
  hardware.bluetooth.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.melyodas = {
    isNormalUser = true;
    home = "/home/melyodas";
    description = "Matthieu Moatti";
    extraGroups = [ "wheel" "networkmanager" "docker" "video" "libvirtd" ];
    shell = pkgs.zsh;
  };

  # zsh completion for system packages
  environment.pathsToLink = [ "/share/zsh" ];

  # Add docker
  virtualisation.docker.enable = true;

  # Add libvirt
  virtualisation.libvirtd = {
    enable = true;
    qemuOvmf = true; # enable UEFI boot in VM
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget vim
    git
    openssh
    notify-osd
    firefox
  ];

  programs.nm-applet.enable = true;
  programs.light.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?
}
