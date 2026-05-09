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
      chlorophyte = {
        hostname = "bozo.life";
        port = 2222;
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
