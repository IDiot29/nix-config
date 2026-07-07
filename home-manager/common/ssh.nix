{...}: {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "github.com" = {
        HostName = "github.com";
        IdentityFile = "~/.ssh/idiot29";
        IdentitiesOnly = true;
      };

      "semesta-vpn" = {
        HostName = "103.125.103.148";
        User = "batman";
        Port = 22222;
        IdentityFile = "~/.ssh/idiot29";
        IdentitiesOnly = true;
      };

      "semesta-lb01" = {
        HostName = "10.200.1.93";
        User = "batman";
        Port = 22;
        IdentityFile = "~/.ssh/idiot29";
        IdentitiesOnly = true;
      };

      "semesta-kube01" = {
        HostName = "10.200.0.177";
        User = "batman";
        Port = 22;
        IdentityFile = "~/.ssh/idiot29";
        IdentitiesOnly = true;
      };
      "dgx-local-straitpoint" = {
        HostName = "100.116.9.105";
        User = "straitpoint";
        Port = 22;
        IdentityFile = "~/.ssh/id_ed25519";
        IdentitiesOnly = true;
      };

    };
  };
}
