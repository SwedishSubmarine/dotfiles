{ ... }:
{
  programs.fd = {
    enable = true;
    hidden = true;
    ignores = [
      ".git/"
      ".bak"
      ".dotnet"
      ".thunderbird"
      ".mozilla"
      ".cache"
    ];
  };
}
