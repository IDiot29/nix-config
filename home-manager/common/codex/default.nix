{pkgs, ...}: let
  tomlFormat = pkgs.formats.toml {};

  codexConfig = {
    mcp_servers = {
      context7 = {
        url = "https://mcp.context7.com/mcp";
        bearer_token_env_var = "CONTEXT7_API_KEY";
      };

      exa = {
        url = "https://mcp.exa.ai/mcp";
      };

      firecrawl = {
        command = "npx";
        args = ["-y" "firecrawl-mcp"];
        env = {
          FIRECRAWL_API_KEY = "\${FIRECRAWL_API_KEY:-}";
        };
      };
    };
  };
in {
  home.file.".codex/config.toml".source = tomlFormat.generate "codex-config.toml" codexConfig;
}
