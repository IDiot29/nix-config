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
      shell_secrets = {};
      ssh_config = {};
    };

    templates = {
      "shell-secrets" = {
        content = config.sops.placeholder.shell_secrets;
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
