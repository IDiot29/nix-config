{lib, pkgs, ...}: let
  mcpServers = {
    context7 = {
      type = "http";
      url = "https://mcp.context7.com/mcp";
      headers = {
        Authorization = "Bearer \${CONTEXT7_API_KEY:-}";
      };
    };

    exa = {
      type = "http";
      url = "https://mcp.exa.ai/mcp";
    };

    github = {
      type = "stdio";
      command = "${pkgs.github-mcp-server}/bin/github-mcp-server";
      args = ["stdio"];
      env = {
        GITHUB_PERSONAL_ACCESS_TOKEN = "\${GH_TOKEN:-}";
      };
    };
  };

  mcpJson = pkgs.writeText "claude-mcp-servers.json" (
    builtins.toJSON {inherit mcpServers;}
  );
in {
  home.activation.claudeCodeMcp = lib.hm.dag.entryAfter ["writeBoundary"] ''
    claude_json="$HOME/.claude.json"
    set -euo pipefail
    temp_file="$(${pkgs.coreutils}/bin/mktemp)"
    trap '${pkgs.coreutils}/bin/rm -f "$temp_file"' EXIT

    # Merge managed MCP servers into Claude's state file without dropping unrelated keys.
    if [ -f "$claude_json" ] && ! ${pkgs.jq}/bin/jq empty "$claude_json" >/dev/null 2>&1; then
      echo "warning: skipping ~/.claude.json MCP update because the file is not valid JSON" >&2
    else
      if [ -f "$claude_json" ]; then
        ${pkgs.jq}/bin/jq \
          --slurpfile mcp ${mcpJson} \
          '.mcpServers = (((.mcpServers // {}) | del(.firecrawl)) + $mcp[0].mcpServers)' \
          "$claude_json" > "$temp_file"
      else
        ${pkgs.jq}/bin/jq '.' ${mcpJson} > "$temp_file"
      fi

      mv "$temp_file" "$claude_json"
    fi
  '';
}
