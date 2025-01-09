{
  config.vim = {
    viAlias = true;
    vimAlias = true;

    enableLuaLoader = true;
    useSystemClipboard = true;
    telescope.enable = true;

    autopairs.nvim-autopairs.enable = true;

    autocomplete.nvim-cmp.enable = true;
    snippets.luasnip.enable = true;

    treesitter.context.enable = true;

    projects.project-nvim.enable = true;

    notify.nvim-notify.enable = true;

    theme = {
      enable = true;
      name = "gruvbox";
      style = "dark";
    };

    visuals = {
      nvim-scrollbar.enable = true;
      nvim-web-devicons.enable = true;
      nvim-cursorline.enable = true;
      cinnamon-nvim.enable = true;
      fidget-nvim.enable = true;

      highlight-undo.enable = true;
      indent-blankline.enable = true;
    };

    tabline = {
      nvimBufferline.enable = true;
    };

    binds = {
      cheatsheet.enable = true;
      whichKey.enable = true;
    };

    keymaps = [
      # Base Keybinds
      {
        key = "<C-s>";
        mode = ["n"];
        action = ":w<CR>";
        silent = true;
        desc = "Save file";
      }
      {
        key = "<PageUp>";
        mode = ["n"];
        action = "<C-u>zz";
        silent = true;
        desc = "Go up half a page";
      }
      {
        key = "<PageDown>";
        mode = ["n"];
        action = "<C-d>zz";
        silent = true;
        desc = "Go down half a page";
      }
      {
        key = "<C-h>";
        mode = ["n"];
        action = ":nohlsearch<CR>";
        silent = true;
        desc = "Clear highlights";
      }
      {
        key = "<leader>e";
        mode = ["n"];
        action = ":Neotree toggle<CR>";
        silent = true;
        desc = "Toggle Neo-tree";
      }
    ];

    lsp = {
      formatOnSave = true;
      lspkind.enable = false;
      lightbulb.enable = true;
      lspsaga.enable = false;
      trouble.enable = true;
      lspSignature.enable = true;
      otter-nvim.enable = true;
      lsplines.enable = true;
      nvim-docs-view.enable = true;
    };

    debugger = {
      nvim-dap = {
        enable = true;
        ui.enable = true;
      };
    };

    languages = {
      enableLSP = true;
      enableFormat = true;
      enableTreesitter = true;
      enableExtraDiagnostics = true;

      nix.enable = true;
      rust.enable = true;
      markdown.enable = true;
      bash.enable = true;
      clang.enable = true;
      css.enable = true;
      html.enable = true;
      sql.enable = true;
      java.enable = true;
      # kotlin.enable = true;
      ts.enable = true;
      go.enable = true;
      lua.enable = true;
      # zig.enable = true;
      python.enable = true;
      typst.enable = true;
    };

    statusline = {
      lualine = {
        enable = true;
        theme = "gruvbox";
      };
    };

    filetree = {
      neo-tree = {
        enable = true;
        setupOpts = {
          setupOpts.enable_cursor_hijack = true;
        };
      };
    };

    terminal = {
      toggleterm = {
        enable = true;
        lazygit.enable = true;
      };
    };

    ui = {
      borders.enable = true;
      noice.enable = true;
      colorizer.enable = true;
      modes-nvim.enable = false; # the theme looks terrible with catppuccin
      illuminate.enable = true;
      breadcrumbs = {
        enable = true;
        navbuddy.enable = true;
      };

      smartcolumn = {
        enable = true;
        setupOpts.custom_colorcolumn = {
          # this is a freeform module, it's `buftype = int;` for configuring column position
          nix = "110";
          ruby = "120";
          java = "130";
          go = ["90" "130"];
        };
      };
      fastaction.enable = true;
    };

    git = {
      enable = true;
      gitsigns.enable = true;
    };

    utility = {
      ccc.enable = false;
      vim-wakatime.enable = false;
      icon-picker.enable = true;
      surround.enable = true;
      diffview-nvim.enable = true;
      motion = {
        hop.enable = true;
        leap.enable = true;
        precognition.enable = true;
      };
    };

    comments = {
      comment-nvim = {
        enable = true;
        mappings = {
          toggleCurrentLine = "<leader>/";
          toggleCurrentBlock = "<leader>\\";
        };
      };
    };
  };
}
