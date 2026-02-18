{pkgs, ...}: let
  terminal = "konsole";
  username = "mikel";
  email = "mlambert125@live.com";
  fullName = "Michael Lambert";
in {
  ########################################################################
  # Nix/Home Manager Configuration
  ########################################################################
  nixpkgs.config.allowUnfree = true;
  fonts.fontconfig.enable = true;

  home.stateVersion = "25.05";
  home.username = username;
  home.homeDirectory = "/home/${username}";

  ########################################################################
  # Mapped Files and Environment Variables
  ########################################################################
  home.file = {
  };

  home.sessionVariables = {
    TERM = terminal;
    EDITOR = "code";
    VISUAL = "code";
    BROWSER = "google-chrome";
    GIT_EDITOR = "code";
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
  };

  home.sessionPath = [
    "$HOME/bin"
    "$HOME/.local/bin"
  ];

  ########################################################################
  # User Programs
  ########################################################################
  programs.home-manager.enable = true;
  programs.bash = {
    enable = true;
    enableCompletion = true;
    historyControl = ["ignoreboth"];
    historySize = 10000;
    historyFileSize = 20000;
    shellAliases = {
      ls = "eza";
      ll = "eza -l";
      la = "eza -la";
      lla = "eza -lla";
      cat = "bat";
      zz = "z -";
      grep = "grep --color=auto";
    };
    bashrcExtra = ''
      shopt -s checkwinsize
      shopt -s histappend
    '';
  };

  programs.git = {
    ignores = [
      ".envrc"
      ".direnv/"
    ];
    enable = true;
    settings = {
      user = {
        name = fullName;
        email = email;
      };
      pull.rebase = false;
      init.defaultBranch = "main";
      core.editor = "code";
      credential.helper = "store";
      push.autoSetupRemote = true;
    };
  };
  programs.yazi = {
    enable = true;
  };
  programs.helix = {
    enable = true;
    settings = {
      theme = "base16_transparent";

      editor = {
        bufferline = "always";
        mouse = true;
        scrolloff = 10;
        default-yank-register = "+";
        file-picker = {
          hidden = true;
        };
        cursor-shape = {
          normal = "block";
          insert = "bar";
          select = "underline";
        };
      };

      keys = {
        normal = {
          "space" = {
            "e" = [
              ":sh rm -f /tmp/unique-file"
              ":insert-output yazi %{buffer_name} --chooser-file=/tmp/unique-file"
              ":insert-output echo \"\\x1b[?1049h\\x1b[?2004h\" > /dev/tty"
              ":open %sh{cat /tmp/unique-file}"
              ":redraw"
            ];
          };
        };
      };
    };

    themes = {
      autumn_night_transparent = {
        "inherits" = "autumn_night";
        "ui.background" = {};
      };
    };

    languages = {
      language = [
        {
          name = "rust";
          language-servers = [
            "rust-analyzer"
            "gpt"
          ];
        }
      ];
    };
  };
  programs.vscode = {
    enable = true;
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        ms-dotnettools.csharp
      ];
    };
  };
  programs.obs-studio.enable = true;
  programs.bat.enable = true;
  programs.fd.enable = true;
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
  };
  programs.lazygit.enable = true;
  programs.ripgrep.enable = true;
  programs.eza = {
    enable = true;
    enableBashIntegration = true;
    colors = "always";
    icons = "always";
  };
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
  };
  programs.jq.enable = true;
  programs.btop.enable = true;

  programs.starship = {
    enable = true;
    settings = {
      format = "[░▒▓](#a3aed2)$directory[ ](fg:#769ff0 bg:#394260)$git_branch$git_status[](fg:#394260 bg:#212736)$time[](fg:#1d2230)";
      directory = {
        style = "fg:#e3e5e5 bg:#394260";
        format = "[ $path ]($style)";
        truncation_length = 3;
        truncation_symbol = "…/";
      };
      git_branch = {
        symbol = "";
        style = "bg:#394260";
        format = "[[ $symbol $branch ](fg:#769ff0 bg:#394260)]($style)";
      };
      git_status = {
        style = "bg:#394260";
        format = "[[($all_status$ahead_behind )](fg:#769ff0 bg:#394260)]($style)";
      };
      time = {
        disabled = false;
        time_format = "%R";
        style = "bg:#1d2230";
        format = "[[  $time ](fg:#a0a9cb bg:#1d2230)]($style)";
      };
    };
  };

  programs.java.enable = true;
  programs.go.enable = true;
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = fullName;
        email = email;
      };
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    enableJujutsuIntegration = true;
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };

  ########################################################################
  # User Services
  ########################################################################

  ########################################################################
  # User Packages
  ########################################################################
  home.packages = with pkgs; [
    wget
    curl
    openssl
    tree
    zip
    unzip
    wl-clipboard
    libnotify
    neofetch
    icu
    mongosh
    mongodb-tools
    jless
    tokei
    cmatrix
    bluetui
    wiremix
    clock-rs
    openssl
    pkg-config

    gcc
    gnumake
    cmake
    llvm
    lldb
    python3
    nixd
    alejandra
    lua5_1
    luajitPackages.luarocks
    stylua
    lua-language-server
    rustup
    llvm
    ruby
    php
    php84Packages.composer
    nodejs_24
    nodePackages.typescript
    nodePackages.typescript-language-server
    live-server
    julia
    tree-sitter
    sqlite
    dotnet-sdk_9
    netcoredbg
    omnisharp-roslyn

    nerd-fonts.hasklug
    nerd-fonts.fira-code

    google-chrome
    bitwarden-desktop
    remmina
    freerdp
    vscode
    discord
    slack
    gimp3
    bitwarden-desktop
    filezilla
    mongodb-compass
    vlc
    smplayer
    qimgv
    openfortivpn
    shotcut

    postman

    mission-center
    krita
    marp-cli

    blender
    audacity
    sox
    ffmpeg

    imagemagick
  ];
}

