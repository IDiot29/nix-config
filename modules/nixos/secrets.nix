{
  config,
  inputs,
  ...
}: {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    age.keyFile = "/home/rivaldo/.config/sops/age/keys.txt";

    secrets = {
      fish_secrets = {};
      nushell_secrets = {};
      ssh_config = {};
      winapps_rdp_user = {};
      winapps_rdp_pass = {};
    };

    templates = {
      "fish-secrets" = {
        content = ''
          ${config.sops.placeholder.fish_secrets}
        '';
        owner = "rivaldo";
        group = "users";
        mode = "0400";
        path = "/home/rivaldo/.config/fish/secrets.fish";
      };

      "nushell-secrets" = {
        content = ''
          ${config.sops.placeholder.nushell_secrets}
        '';
        owner = "rivaldo";
        group = "users";
        mode = "0400";
        path = "/home/rivaldo/.config/nushell/secrets.nu";
      };

      "ssh-config" = {
        content = config.sops.placeholder.ssh_config;
        owner = "rivaldo";
        group = "users";
        mode = "0400";
      };

      "winapps.conf" = {
        content = ''
          ##################################
          #   WINAPPS CONFIGURATION FILE   #
          ##################################

          RDP_USER="${config.sops.placeholder.winapps_rdp_user}"
          RDP_PASS="${config.sops.placeholder.winapps_rdp_pass}"
          RDP_DOMAIN=""
          RDP_IP="127.0.0.1"
          VM_NAME="RDPWindows"
          WAFLAVOR="podman"
          RDP_SCALE="100"
          REMOVABLE_MEDIA="/run/media"
          RDP_FLAGS="/cert:tofu /sound /microphone +home-drive"
          RDP_FLAGS_NON_WINDOWS=""
          RDP_FLAGS_WINDOWS=""
          DEBUG="true"
          AUTOPAUSE="off"
          AUTOPAUSE_TIME="300"
          FREERDP_COMMAND=""
          PORT_TIMEOUT="5"
          RDP_TIMEOUT="30"
          APP_SCAN_TIMEOUT="60"
          BOOT_TIMEOUT="120"
          HIDEF="on"
        '';
        owner = "rivaldo";
        group = "users";
        mode = "0600";
        path = "/home/rivaldo/.config/winapps/winapps.conf";
      };
    };
  };
}
