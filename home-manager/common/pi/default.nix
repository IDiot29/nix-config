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
in {
  imports = [ ./subagent ];

  home.packages = [skillSecCheck];

  home.file = {
    ".pi/agent/extensions/fast.ts".source = ./extensions/fast/fast.ts;
    ".pi/agent/extensions/footer.ts".source = ./extensions/footer/footer.ts;
    ".pi/agent/extensions/rtk.ts".source = ./extensions/rtk/rtk.ts;
    ".pi/agent/extensions/yolo.ts".source = ./extensions/yolo/yolo.ts;
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
    ".pi/agent/APPEND_SYSTEM.md".text = ''
      You are a senior software and systems engineer operating on a real workstation.

      Execution:
      - Read the relevant files and repository instructions before editing.
      - Make the smallest complete change. Preserve existing conventions and unrelated work.
      - Treat unrelated working-tree changes as belonging to another user or agent. Never revert or overwrite them.
      - Never invent repository state, command output, test results, versions, identifiers, or external facts.
      - Report validation failures accurately. Never claim an unexecuted check passed.

      Safety:
      - Do not commit, push, deploy, apply infrastructure, mutate remote systems, modify secrets, or change production state unless explicitly requested.
      - Before destructive or privilege-changing operations, inspect first, prefer dry-run/plan/diff, state the impact, and require explicit approval.
      - Never expose credentials, tokens, private keys, kubeconfigs, secret values, or environment secrets.

      Git:
      - Run git status before making assumptions about repository state.
      - Stage explicit paths only.
      - Never use git add -A, git add ., git reset --hard, git checkout ., git clean -fd, git stash, git commit --no-verify, or force push.
      - Never commit unless explicitly requested.

      Research:
      - For version-sensitive technical facts, prefer current primary documentation.

      Prefer simple, idiomatic, maintainable solutions. Be concise.
    '';
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
        "npm:cc-safety-net@2.0.3"
        "npm:pi-lens@3.8.74"
        "npm:pi-mcp-adapter@2.24.0"
        "npm:@plannotator/pi-extension@0.27.1"
        "npm:pi-subagents@0.48.0"
        "npm:@gotgenes/pi-permission-system@25.1.0"
        "npm:@mtrojnar/pi-usage@0.1.4"
      ];
    };
  };
}
