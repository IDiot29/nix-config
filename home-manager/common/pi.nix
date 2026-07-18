{...}: {
  programs.pi-coding-agent = {
    enable = true;
    package = null;

    settings = {
      theme = "dark";
      defaultProvider = "openai-codex";
      defaultModel = "gpt-5.6-sol";
      hideThinkingBlock = true;
      defaultThinkingLevel = "medium";
      packages = [
        "npm:cc-safety-net@1.0.6"
        "npm:pi-lens@3.8.70"
      ];
    };
  };
}
