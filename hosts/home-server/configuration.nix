# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{  
  imports =
    [
      ../../modules/network.nix
      ../../modules/display.nix
      ../../modules/system.nix
      (builtins.fetchGit { url = "ssh://git@github.com/transgwender/media-server-config.git"; ref = "main"; rev = "3a249373c411f017a51c80e2c8a892b9511bc516"; }).outPath
      
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.supportedFilesystems = [ "ntfs" ];

  users.groups = {
    "media" = {
      gid = 1000;
    };
  };

  fileSystems."/media" = {
    depends = ["/"];
    device = "/dev/disk/by-label/media";
    options = ["nofail"];
  };

  networking.hostName = "nixos"; # Define your hostname.
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.wireless.networks = {
    "Aperture Labs Platform Silo" = {
      psk = "prometheus-lemons";
    };
  };

  # SSH
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      AllowUsers = null;
      X11Forwarding = false;
      PermitRootLogin = "no";
    };
  };

  # SMART Monitoring
  services.smartd = {
    enable = true;
    devices = [
      {
        device = "/dev/disk/by-id/nvme-WDS500G1X0E-00AFY0_204318806676"; # Main
      }
      {
        device = "/dev/disk/by-id/ata-APPLE_HDD_ST2000DM001_W8E0GEH6"; # Storage
      }
      {
        device = "/dev/disk/by-id/ata-HGST_HTS541010A9E680_JA1000CRJVL6YN"; # Media
      }
      {
        device = "/dev/disk/by-id/ata-TS128GMTS800_C696950001"; # Emb SSD
      }
      {
        device = "/dev/disk/by-id/ata-WDC_WD10EZEX-22MFCA0_WD-WCC6Y1ZRZP11"; # Emb HDD
      }
    ];
  };
  
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
