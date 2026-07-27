{pkgs, ...}: let
  skillSecCheck = pkgs.writeShellApplication {
    name = "skill-sec-check.sh";
    runtimeInputs = with pkgs; [
      coreutils
      findutils
      jq
      trivy
    ];
    text = builtins.readFile ./scripts/skill-sec-check.sh;
  };
  piSsh = pkgs.writeShellScriptBin "pi-ssh" ''
    if [ "$#" -lt 2 ]; then
      echo "usage: pi-ssh <identity-filename> <destination> [remote-command ...]" >&2
      exit 2
    fi

    identity=$1
    destination=$2
    case "$identity" in
      ""|"."|".."|*[!A-Za-z0-9._-]*)
        echo "pi-ssh: identity must be a filename inside ~/.ssh" >&2
        exit 2
        ;;
    esac
    case "$destination" in
      -*)
        echo "pi-ssh: destination must not be an SSH option" >&2
        exit 2
        ;;
    esac
    shift 2

    exec ${pkgs.openssh}/bin/ssh \
      -o BatchMode=yes \
      -o ConnectTimeout=10 \
      -i "$HOME/.ssh/$identity" \
      "$destination" \
      "$@"
  '';
in {
  imports = [ ./subagent ];

  home.packages = [
    skillSecCheck
    piSsh
  ];

  home.file = {
    ".pi/agent/APPEND_SYSTEM.md".text = ''
      To authenticate with any private SSH key, run `pi-ssh <identity-filename> <destination> [remote command]`.
      Pass only the key filename, never its path, and never read SSH private keys with a tool. The wrapper resolves the filename inside `~/.ssh`, which remains denied by the permission gate.
    '';
    ".pi/agent/extensions/footer.ts".source = ./extensions/footer/footer.ts;
    ".pi/agent/extensions/rtk.ts".source = ./extensions/rtk/rtk.ts;
    ".pi/agent/extensions/pi-permission-system/config.json".source =
      ./extensions/pi-permission-system/config.json;
    ".local/bin/pi-package-security-check" = {
      source = ./scripts/pi-package-security-check;
      executable = true;
    };
    ".local/bin/pi-package-update" = {
      source = ./scripts/pi-package-update;
      executable = true;
    };
    ".pi/agent/themes/catppuccin-mocha.json".source = ./themes/catppuccin-mocha.json;
  };

  xdg.configFile."mcp/mcp.json".text = builtins.toJSON {
    mcpServers = {
      context7 = {
        url = "https://mcp.context7.com/mcp";
        headers.CONTEXT7_API_KEY = "\${CONTEXT7_API_KEY}";
      };

      exa = {
        url = "https://mcp.exa.ai/mcp";
        headers."x-api-key" = "\${EXA_API_KEY}";
      };
    };
  };

  programs.pi-coding-agent = {
    enable = true;
    package = null;

    settings = {
      theme = "catppuccin-mocha";
      defaultProvider = "openai-codex";
      defaultModel = "gpt-5.6-sol";
      hideThinkingBlock = true;
      defaultThinkingLevel = "medium";
      packages = [
        "npm:cc-safety-net@1.0.6"
        "npm:pi-lens@3.8.70"
        "npm:pi-mcp-adapter@2.11.0"
        "npm:@plannotator/pi-extension@0.23.1"
        "npm:pi-subagents@0.35.1"
        "npm:@gotgenes/pi-permission-system@20.10.0"
      ];
    };
  };
}
