{...}: {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        identityFile = "~/.ssh/idiot29";
        identitiesOnly = true;
      };

      "semesta-vpn" = {
        hostname = "103.125.103.148";
        user = "root";
        port = 22222;
        identityFile = "~/.ssh/idiot29";
        identitiesOnly = true;
      };
    };
  };
}
