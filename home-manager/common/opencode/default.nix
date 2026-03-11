{lib, ...}: let
  mkModel = {
    name,
    context,
    output,
    inputs,
    variants ? null,
  }: {
    inherit name;
    limit = {
      inherit context output;
    };
    modalities = {
      input = inputs;
      output = ["text"];
    };
  } // lib.optionalAttrs (variants != null) {
    inherit variants;
  };

in {
  programs.opencode = {
    enable = lib.mkDefault true;
    package = lib.mkDefault null;
    settings = lib.mkDefault {
      plugin = [
        "opencode-antigravity-auth@latest"
      ];

      skills.paths = [
        "{env:HOME}/.config/opencode/skills"
      ];

      mcp.context7 = {
        type = "remote";
        url = "https://mcp.context7.com/mcp";
        headers.CONTEXT7_API_KEY = "{env:CONTEXT7_API_KEY}";
        enabled = true;
      };

      mcp.exa = {
        type = "remote";
        url = "https://mcp.exa.ai/mcp";
        enabled = true;
      };

      mcp.firecrawl = {
        type = "local";
        command = ["npx" "-y" "firecrawl-mcp"];
        environment.FIRECRAWL_API_KEY = "{env:FIRECRAWL_API_KEY}";
        enabled = true;
      };

      provider = {
        google = {
          name = "Google";
          models = {
            "antigravity-gemini-3-pro" = mkModel {
              name = "Gemini 3 Pro (Antigravity)";
              context = 1048576;
              output = 65535;
              inputs = ["text" "image" "pdf"];
              variants = {
                low.thinkingLevel = "low";
                high.thinkingLevel = "high";
              };
            };

            "antigravity-gemini-3.1-pro" = mkModel {
              name = "Gemini 3.1 Pro (Antigravity)";
              context = 1048576;
              output = 65535;
              inputs = ["text" "image" "pdf"];
              variants = {
                low.thinkingLevel = "low";
                high.thinkingLevel = "high";
              };
            };

            "antigravity-gemini-3-flash" = mkModel {
              name = "Gemini 3 Flash (Antigravity)";
              context = 1048576;
              output = 65536;
              inputs = ["text" "image" "pdf"];
              variants = {
                minimal.thinkingLevel = "minimal";
                low.thinkingLevel = "low";
                medium.thinkingLevel = "medium";
                high.thinkingLevel = "high";
              };
            };

            "antigravity-claude-sonnet-4-6" = mkModel {
              name = "Claude Sonnet 4.6 (Antigravity)";
              context = 200000;
              output = 64000;
              inputs = ["text" "image" "pdf"];
            };

            "antigravity-claude-opus-4-6-thinking" = mkModel {
              name = "Claude Opus 4.6 Thinking (Antigravity)";
              context = 200000;
              output = 64000;
              inputs = ["text" "image" "pdf"];
              variants = {
                low.thinkingConfig.thinkingBudget = 8192;
                max.thinkingConfig.thinkingBudget = 32768;
              };
            };

            "gemini-2.5-flash" = mkModel {
              name = "Gemini 2.5 Flash (Gemini CLI)";
              context = 1048576;
              output = 65536;
              inputs = ["text" "image" "pdf"];
            };

            "gemini-2.5-pro" = mkModel {
              name = "Gemini 2.5 Pro (Gemini CLI)";
              context = 1048576;
              output = 65536;
              inputs = ["text" "image" "pdf"];
            };

            "gemini-3-flash-preview" = mkModel {
              name = "Gemini 3 Flash Preview (Gemini CLI)";
              context = 1048576;
              output = 65536;
              inputs = ["text" "image" "pdf"];
            };

            "gemini-3-pro-preview" = mkModel {
              name = "Gemini 3 Pro Preview (Gemini CLI)";
              context = 1048576;
              output = 65535;
              inputs = ["text" "image" "pdf"];
            };

            "gemini-3.1-pro-preview" = mkModel {
              name = "Gemini 3.1 Pro Preview (Gemini CLI)";
              context = 1048576;
              output = 65535;
              inputs = ["text" "image" "pdf"];
            };

            "gemini-3.1-pro-preview-customtools" = mkModel {
              name = "Gemini 3.1 Pro Preview Custom Tools (Gemini CLI)";
              context = 1048576;
              output = 65535;
              inputs = ["text" "image" "pdf"];
            };
          };
        };

        dekallm = {
          name = "Deka LLM";
          npm = "@ai-sdk/openai-compatible";
          options = {
            baseURL = "https://dekallm.cloudeka.ai/v1";
            apiKey = "{env:DEKA_API_KEY}";
            compatibility = "strict";
          };
          models = {
            "qwen/qwen3-coder" = mkModel {
              name = "Qwen3 Coder (Deka LLM)";
              context = 131072;
              output = 8192;
              inputs = ["text"];
            };

            "qwen/qwen25-vl-7b-instruct" = mkModel {
              name = "Qwen2.5 VL 7B Instruct (Deka LLM)";
              context = 32768;
              output = 8192;
              inputs = ["text" "image"];
            };

            "qwen/qwen25-72b-instruct" = mkModel {
              name = "Qwen2.5 72B Instruct (Deka LLM)";
              context = 131072;
              output = 8192;
              inputs = ["text"];
            };

            "qwen/qwen3-30b-a3b-instruct-2507" = mkModel {
              name = "Qwen3 30B A3B Instruct (Deka LLM)";
              context = 131072;
              output = 8192;
              inputs = ["text"];
            };

            "zai/glm-4.7-fp8" = mkModel {
              name = "GLM 4.7 FP8 (Deka LLM)";
              context = 128000;
              output = 8192;
              inputs = ["text"];
            };
          };
        };
      };
    };
  };
}
