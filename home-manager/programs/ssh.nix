{ ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
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
      chlorophyte = {
        # Temp until domain has been bought :)
        hostname = "192.168.0.140";
        user = "emily";
      };
      "*" = {
        forwardAgent = false;
        addKeysToAgent = "no";
        compression = false;
        serverAliveInterval = 0;
        serverAliveCountMax = 3;
        hashKnownHosts = false;
        userKnownHostsFile = "~/.ssh/known_hosts";
        controlMaster = "no";
        controlPath = "~/.ssh/master-%r@%n:%p";
        controlPersist = "no";
      };
    };
  };
}
