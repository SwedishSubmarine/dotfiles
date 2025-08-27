{ ... }:
{
  programs.ssh = {
    enable = true;
    matchBlocks = {
      zelda = {
        hostname = "zelda.dhack.se";
        user = "dhack";
      };
      link = {
        hostname = "link.dhack.se";
        user = "dhack";
      };
      medli = {
        hostname = "pub.dhack.se"; 
        user = "hacke";
        port = 222;
      };
      uru = {
        hostname = "qwdcraft.60.nu";
        port = 2222;
        user = "emily";
      };
    };
  };
}
