# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nixpkgs.config.allowUnfree = true;

  # GRUB 2 boot loader
  # boot.loader.grub.enable = true;
  # boot.loader.grub.version = 2;
  # boot.loader.grub.device = "/dev/sda";

  # Gummiboot boot loader
  boot.loader.gummiboot.enable = true;

  # EFI configuration
  boot.loader.efi.canTouchEfiVariables = true;

  # LUKS decryption
  boot.initrd.luks.devices = [
    {
      device = "/dev/sda2";
      name = "enc_pv";
      preLVM = true;
    }
  ];

  networking.hostName = "chipt0p-nixos"; # Define your hostname.
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "sv-latin1";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Europe/Stockholm";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment = {
    systemPackages = with pkgs; [
      wget
      vim
      dmenu
      dzen2
      conky
      git
      acpi
      ctags
      chromium
      compton
      glxinfo
      trayer
      rxvt_unicode
      xfontsel
      oxygen-gtk2
      numix-gtk-theme
      lxappearance
      gtk-engine-murrine
      xfce.thunar
      dropbox
      skype
      zathura
      spotify

      haskell.compiler.ghc7102
      haskellPackages.cabal-install
    ];
    shellInit = ''
      export GTK_PATH=$GTK_PATH:${pkgs.numix-gtk-theme}/share/themes/Numix/gtk-2.0
      export GTK2_RC_FILES=$GTK2_RC_FILES:${pkgs.numix-gtk-theme}/share/themes/Numix/gtk-2.0/gtkrc
    '';
  };

  hardware.bumblebee.enable = true;

  # List services that you want to enable:
  services = {
    openssh.enable = true;

    xserver = {
      enable = true;
      layout = "se";
      windowManager.xmonad.enable = true;
      windowManager.xmonad.enableContribAndExtras = true;
      desktopManager.xterm.enable = false;
      displayManager.slim.enable = true;
      synaptics.enable = true;
      synaptics.twoFingerScroll = true;
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.chip = {
    uid = 1000;
    home = "/home/chip";
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "15.09";

  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      corefonts          # Microsoft free fonts
      inconsolata        # monospaced
      ubuntu_font_family # Ubuntu fonts
      unifont            # some international languages
    ];
  };
}
