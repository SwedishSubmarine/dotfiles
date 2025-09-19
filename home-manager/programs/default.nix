{ ... }:
{
  catppuccin = {
    flavor = "macchiato";
    accent = "mauve";
  };

  imports = [
    ./bat.nix
    ./bottom.nix
    ./obs-studio.nix
    ./eza.nix
    ./fastfetch.nix
    ./vscode.nix
    ./zoxide.nix
    ./fzf.nix
    ./yazi.nix
    ./fd.nix
    ./mpv.nix
    ./ssh.nix
    ./wezterm.nix
    ./swaylock.nix
  ];
}
