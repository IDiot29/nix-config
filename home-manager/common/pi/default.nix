{...}: {
  imports = [ ./subagent ];

  home.file = {
    ".pi/agent/extensions/rtk.ts".source = ./extensions/rtk/rtk.ts;
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
