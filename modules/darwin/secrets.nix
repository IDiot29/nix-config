{
  config,
  inputs,
  ...
}: {
  imports = [
    inputs.sops-nix.darwinModules.sops
  ];

  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    age.keyFile = "/Users/rivaldo/.config/sops/age/keys.txt";

    secrets = {
      fish_secrets = {};
      nushell_secrets = {};
      ssh_config = {};
    };

    templates = {
      "fish-secrets" = {
        content = ''
          ${config.sops.placeholder.fish_secrets}
        '';
        owner = "rivaldo";
        mode = "0400";
      };

      "nushell-secrets" = {
        content = ''
          ${config.sops.placeholder.nushell_secrets}
        '';
        owner = "rivaldo";
        mode = "0400";
      };

      "ssh-config" = {
        content = config.sops.placeholder.ssh_config;
        owner = "rivaldo";
        mode = "0400";
      };
    };
  };
}
