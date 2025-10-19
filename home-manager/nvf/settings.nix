# Declarative NVF settings
{ pkgs, lib }:

{
  vim = {
    package = pkgs.neovim-unwrapped;
    viAlias = false;
    vimAlias = true;

    globals = {
      mapleader = " ";
      maplocalleader = "\\";
    };

    options = {
      number = true;
      relativenumber = true;
      signcolumn = "yes";
      cursorline = true;
      scrolloff = 8;
      clipboard = "unnamedplus";
      undofile = true;
      timeoutlen = 300;
      updatetime = 250;
      splitright = true;
      splitbelow = true;
      ignorecase = true;
      smartcase = true;
      termguicolors = true;

      # Tabs and indentation
      tabstop = 2;
      shiftwidth = 2;
      expandtab = true;
      smartindent = true;
    };

    lineNumberMode = "relNumber";
    searchCase = "smart";
    preventJunkFiles = true;
    hideSearchHighlight = false;

    # Auto-close terminal when lazygit exits
    autocmds = [
      {
        event = ["TermClose"];
        pattern = ["term://*lazygit"];
        command = "bdelete!";
      }
    ];

    extraPackages = with pkgs; [
      # Search and navigation
      ripgrep
      fd

      # Git
      lazygit

      # Nix
      nil
      nixd
      alejandra
      nixfmt-rfc-style
      statix
      deadnix

      # Lua
      stylua
      lua-language-server

      # Shell
      shfmt
      shellcheck

      # Rust
      rust-analyzer

      # Python
      pyright

      # Node/TypeScript
      nodejs_22

      # YAML/Kubernetes
      yaml-language-server
      actionlint
    ];

    withPython3 = true;
    python3Packages = ["pynvim"];
    withNodeJs = true;

    diagnostics = {
      enable = true;
      config = {
        underline = true;
        virtual_text = true;
        signs = true;
        update_in_insert = false;
      };
    };

    lsp = {
      enable = true;
      formatOnSave = true;
      inlayHints.enable = true;
      lspkind.enable = true;
      trouble.enable = true;
    };

    autocomplete = {
      enableSharedCmpSources = true;
      nvim-cmp = {
        enable = true;
        sourcePlugins = with pkgs.vimPlugins; [
          cmp-nvim-lsp
          cmp-buffer
          cmp-path
          cmp_luasnip
          cmp-nvim-lua
        ];
        sources = {
          nvim_lsp = "[LSP]";
          buffer = "[Buffer]";
          path = "[Path]";
          nvim_lua = "[Lua]";
        };
      };
    };

    snippets.luasnip = {
      enable = true;
      providers = with pkgs.vimPlugins; [
        friendly-snippets
      ];
    };

    autopairs.nvim-autopairs.enable = true;

    comments.comment-nvim.enable = true;

    git.gitsigns.enable = true;

    treesitter = {
      enable = true;
      fold = true;
      autotagHtml = true;
    };

    telescope = {
      enable = true;
      setupOpts = {
        defaults = {
          path_display = ["smart"];
          layout_config = {
            width = 0.9;
            height = 0.85;
            horizontal.preview_width = 0.6;
          };
        };
      };
      extensions = [
        {
          name = "fzf";
          packages = [pkgs.vimPlugins.telescope-fzf-native-nvim];
          setup = {
            fzf = {
              fuzzy = true;
              override_generic_sorter = true;
              override_file_sorter = true;
              case_mode = "smart_case";
            };
          };
        }
      ];
    };

    theme = {
      enable = true;
      name = "catppuccin";
      style = "mocha";
      transparent = false;
    };

    statusline.lualine.enable = true;
    tabline.nvimBufferline.enable = true;

    filetree.nvimTree = {
      enable = true;
      openOnSetup = false;
      setupOpts = {
        hijack_cursor = true;
        view = {
          width = 36;
          relativenumber = true;
        };
        renderer = {
          highlight_git = true;
          add_trailing = false;
        };
        actions = {
          open_file = {
            quit_on_open = false;
          };
        };
      };
    };

    binds.whichKey.enable = true;

    maps = {
      normal = {
        # Telescope
        "<leader>ff" = {
          action = "<cmd>Telescope find_files<CR>";
          desc = "Find files";
        };
        "<leader>fg" = {
          action = "<cmd>Telescope live_grep<CR>";
          desc = "Live grep";
        };
        "<leader>fb" = {
          action = "<cmd>Telescope buffers<CR>";
          desc = "Find buffers";
        };
        "<leader>fh" = {
          action = "<cmd>Telescope help_tags<CR>";
          desc = "Help tags";
        };
        "<leader>fo" = {
          action = "<cmd>Telescope oldfiles<CR>";
          desc = "Recent files";
        };

        # File tree
        "<leader>e" = {
          action = "<cmd>NvimTreeToggle<CR>";
          desc = "Toggle file tree (open/close)";
        };

        # Better window navigation
        "<C-h>" = {
          action = "<C-w>h";
          desc = "Move to left window";
        };
        "<C-j>" = {
          action = "<C-w>j";
          desc = "Move to bottom window";
        };
        "<C-k>" = {
          action = "<C-w>k";
          desc = "Move to top window";
        };
        "<C-l>" = {
          action = "<C-w>l";
          desc = "Move to right window";
        };

        # Buffer navigation
        "<S-l>" = {
          action = "<cmd>bnext<CR>";
          desc = "Next buffer";
        };
        "<S-h>" = {
          action = "<cmd>bprevious<CR>";
          desc = "Previous buffer";
        };

        # Tab navigation
        "<leader>tn" = {
          action = "<cmd>tabnext<CR>";
          desc = "Next tab";
        };
        "<leader>tp" = {
          action = "<cmd>tabprevious<CR>";
          desc = "Previous tab";
        };
        "<leader>tc" = {
          action = "<cmd>tabclose<CR>";
          desc = "Close current tab";
        };

        # Clear search highlight
        "<leader>h" = {
          action = "<cmd>nohlsearch<CR>";
          desc = "Clear search highlight";
        };

        # Git
        "<leader>gg" = {
          action = "<cmd>tabnew | terminal lazygit<CR>i";
          desc = "Open LazyGit in new tab";
        };

        # LSP
        "gd" = {
          action = "<cmd>lua vim.lsp.buf.definition()<CR>";
          desc = "Go to definition";
        };
        "gr" = {
          action = "<cmd>lua vim.lsp.buf.references()<CR>";
          desc = "Show references";
        };
        "K" = {
          action = "<cmd>lua vim.lsp.buf.hover()<CR>";
          desc = "Show hover";
        };
        "<leader>rn" = {
          action = "<cmd>lua vim.lsp.buf.rename()<CR>";
          desc = "Rename symbol";
        };
        "<leader>ca" = {
          action = "<cmd>lua vim.lsp.buf.code_action()<CR>";
          desc = "Code action";
        };
      };

      visual = {
        # Better indenting
        "<" = {
          action = "<gv";
          desc = "Indent left";
        };
        ">" = {
          action = ">gv";
          desc = "Indent right";
        };
      };
    };

    ui.borders = {
      enable = true;
      globalStyle = "rounded";
    };

    languages = {
      enableTreesitter = true;
      enableFormat = true;
      enableExtraDiagnostics = true;

      nix = {
        enable = true;
        lsp.server = "nixd";
        format.enable = true;
        extraDiagnostics.enable = true;
      };

      rust = {
        enable = true;
        lsp.enable = true;
        crates.enable = true;
        format.enable = true;
      };

      lua = {
        enable = true;
        lsp = {
          enable = true;
          lazydev.enable = true;
        };
        format.enable = true;
        extraDiagnostics.enable = true;
      };

      bash = {
        enable = true;
        lsp.enable = true;
        format.enable = true;
        extraDiagnostics.enable = true;
      };

      ts = {
        enable = true;
        lsp.enable = true;
        format.enable = true;
        extraDiagnostics.enable = true;
        extensions."ts-error-translator".enable = true;
      };

      markdown = {
        enable = true;
        lsp.enable = true;
        format.enable = true;
        extraDiagnostics.enable = true;
      };

      python = {
        enable = true;
        lsp.enable = true;
        format.enable = true;
      };

      yaml = {
        enable = true;
        lsp.enable = true;
      };
    };
  };
}
