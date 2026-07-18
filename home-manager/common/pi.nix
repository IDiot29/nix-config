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
    };
  };
}
