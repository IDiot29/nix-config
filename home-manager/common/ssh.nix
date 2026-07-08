{...}: {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "github.com" = {
        HostName = "github.com";
        User = "git";
        IdentityFile = "~/.ssh/idiot29";
        IdentitiesOnly = true;
      };

      "github-straitpoint" = {
        HostName = "github.com";
        User = "git";
        IdentityFile = "~/.ssh/id_ed25519_straitpoint";
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

      "dgx-us-worker1" = {
        HostName = "100.72.109.71";
        User = "straitpoint";
        Port = 22;
        IdentityFile = "~/.ssh/id_ed25519_straitpoint";
        IdentitiesOnly = true;
      };

      "dgx-us-worker2" = {
        HostName = "100.86.64.113";
        User = "straitpoint";
        Port = 22;
        IdentityFile = "~/.ssh/id_ed25519_straitpoint";
        IdentitiesOnly = true;
      };
    };
  };
}
