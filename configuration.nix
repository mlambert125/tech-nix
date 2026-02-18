{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  ########################################################################
  # Nix Configuration
  ########################################################################
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = ["nix-command" "flakes"];
  system.stateVersion = "25.05";

  ########################################################################
  # Hardware
  ########################################################################

  hardware.bluetooth.enable = true;

  ########################################################################
  # System Configuration
  ########################################################################
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  security.rtkit.enable = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 8080 ];

  time.timeZone = "America/New_York";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  virtualisation.docker.enable = true;

  ########################################################################
  # Users
  ########################################################################
  users.users.mikel = {
    isNormalUser = true;
    description = "Michael Lambert";
    extraGroups = ["networkmanager" "wheel" "docker"];
    hashedPassword = "$y$j9T$y0laJB1HMUyXlHZJ/hkjl1$XtsrCV1ChnFVxnQtMhLkTSiaKD9PFuSB5BZiXRfwBdA";
  };

  home-manager = {
    users.mikel = {
      imports = [./home.nix ];
    };
    backupFileExtension = ".nixbak";
  };

  ########################################################################
  # System Services
  ########################################################################
  services.openssh = {
    enable = true;
    ports = [22]; # Default SSH port
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "prohibit-password"; # Recommended for security
    };
  };

  services.mongodb = {
    enable = true;
    package = pkgs.mongodb-ce;
  };

  services.rabbitmq = {
    enable = true;
    plugins = [
      "rabbitmq_management"
    ];
  };
  environment.etc."rabbitmq/definitions.json".text = builtins.toJSON {
    users = [
      {
        name = "guest";
        password_hash = "$2b$12$KIXQJbG6kX8Fh8m5Z4xUOeG7rX6G5jFh8m5Z4xUOeG7rX6G5jFh8m5Z";
        tags = "administrator";
      }
    ];
    vhosts = [
      {
        name = "/";
      }
    ];
    permissions = [
      {
        user = "guest";
        vhost = "/";
        configure = ".*";
        write = ".*";
        read = ".*";
      }
    ];
  };
  services.mysql = {
    enable = true;
    package = pkgs.mysql80;
    dataDir = "/var/lib/mysql";
    ensureUsers = [
      {
        name = "mikel";
      }
    ];
  };

  ########################################################################
  # System Services
  ########################################################################
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.printing.enable = true;
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  services.pipewire.wireplumber.enable = true;
  services.dbus.enable = true;
  services.udisks2.enable = true;
  services.gvfs.enable = true;
  services.flatpak.enable = true;

  ########################################################################
  # System Packages
  ########################################################################
  environment.systemPackages = with pkgs; [
    home-manager
    qemu
    quickemu
  ];
}
