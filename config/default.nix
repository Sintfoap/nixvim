{pkgs, ...}: let
  ruff = "${pkgs.ruff}/bin/ruff";
  stylua = "${pkgs.stylua}/bin/stylua";
  alejandra = "${pkgs.alejandra}/bin/alejandra";
  isort = "${pkgs.isort}/bin/isort";
  rustfmt = "${pkgs.rustfmt}/bin/rustfmt";
in {
  opts = {
    number = true;
    shiftwidth = 2;
    signcolumn = "yes";
  };

  globals = {
    mapleader = " ";
    maplocalleader = " ";
  };

  performance.combinePlugins = {
    enable = true;
    standalonePlugins = [
      "oil.nvim" "lualine.nvim" "leap.nvim"
    ];
  };

  colorschemes.onedark = {
    enable = true;
    settings = {
      style = "deep";
    };
  };

  plugins = {
    conform-nvim = {
      enable = true;

      formattersByFt = {
        lua = ["stylua"];
        nix = ["alejandra"];
        python = ["isort" "ruff_format"];
        rust = ["rustfmt"];
        "*" = ["trim_whitespace"];
      };
      formatters = {
        ruff_format = {
          command = ruff;
          prepend_args = ["format"];
        };
        stylua.command = stylua;
        alejandra.command = alejandra;
        isort.command = isort;
        rustfmt.command = rustfmt;
      };
    };
    vimtex = {
      enable = true;
      texlivePackage = pkgs.texlive.combined.scheme-full;
      settings = {
        compiler_method = "latexmk";
        view_method = "zathura";
      };
    };

    lsp = {
      enable = true;
      inlayHints = true;
      onAttach = ''vim.keymap.set("n", "<leader>f", function() require("conform").format({ async = true, lsp_fallback = true }) end) '';
      keymaps.diagnostic = {
        "[d" = "goto_next";
        "]d" = "goto_prev";
      };
      keymaps.lspBuf = {
        K = "hover";
        gD = "references";
        gd = "definition";
        gi = "implementation";
        gt = "type_definition";
      };
      servers = {
        pyright.enable = true;
        nil-ls.enable = true;
        jsonls.enable = true;
        html.enable = true;
        lua-ls.enable = true;
        marksman.enable = true;
        rust-analyzer.enable = true;
        rust-analyzer.installRustc = true;
        rust-analyzer.installCargo = true;
        tsserver.enable = true;
        ts-ls.enable = true;
        ltex.enable = true;
        typst_lsp.enable = true;
      };
    };

    lint = {
      enable = true;
      linters.ruff.cmd = ruff;
      lintersByFt.python = ["ruff"];
    };

    treesitter = {
      enable = true;
      settings = {
        auto_install = true;
        highlight.enable = true;
      };
    };

    telescope = {
      enable = true;
      keymaps = {
        "<leader>h" = "find_files";
        "<leader>g" = "live_grep";
        "<leader>df" = "lsp_references";
      };
    };

    harpoon = {
      enable = true;
      keymaps = {
        addFile = "<leader>a";
        toggleQuickMenu = "<leader>s";
        navFile = {
          "1" = "<C-A-j>";
          "2" = "<C-A-k>";
          "3" = "<C-A-l>";
          "4" = "<C-A-;>";
        };
      };
    };

    cmp = {
      enable = true;
      settings = {
        autoEnableSources = true;
        snippet.expand = "luasnip";
        experimental.ghost_text = true;
        preselect = "cmp.PreselectMode.Item";
        formatting.fields = ["kind" "abbr" "menu"];

        sources = [
          {name = "nvim_lsp";}
          {name = "luasnip";}
          {name = "nvim_lua";}
          {name = "calc";}
          {name = "path";}
          {name = "buffer";}
        ];
        mapping = {
          "<CR>" = "cmp.mapping.confirm({ select = true })";
          "<C-p>" = "cmp.mapping(function() if cmp.visible() then cmp.select_prev_item({behavior = 'select'}) else cmp.complete() end end)";
          "<C-n>" = "cmp.mapping(function() if cmp.visible() then cmp.select_next_item({behavior = 'select'}) else cmp.complete() end end)";
        };
        window = {
          completion = {
            border = "rounded";
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None";
          };
          documentation.border = "rounded";
        };
      };
    };

    luasnip = {
      enable = true;
      extraConfig = {
        enable_autosnippets = true;
        store_selection_keys = "<Tab>";
      };
      fromVscode = [
        {
          lazyLoad = true;
          paths = "${pkgs.vimPlugins.friendly-snippets}";
        }
      ];
    };

    floaterm = {
      enable = true;
      autoclose = 0;
      keymaps = {
        hide = "<leader>th";
        kill = "<leader>td";
        first = "<leader>ti";
        last = "<leader>ta";
        new = "<leader>to";
        next = "<leader>tk";
        prev = "<leader>tj";
        show = "<leader>tg";
      };
    };

    gitsigns.enable = true;

    neogit.enable = true;

    oil.enable = true;

    nvim-autopairs.enable = true;

    surround.enable = true;

    comment.enable = true;

    todo-comments.enable = true;

    lualine.enable = true;

    fidget.enable = true;

    cmp-nvim-lsp.enable = true; # lsp

    cmp-calc.enable = true;

    cmp-buffer.enable = true;

    cmp-path.enable = true; # file system paths

    cmp_luasnip.enable = true; # snippets

    cmp-cmdline.enable = true; # autocomplete for cmdlinep

    leap.enable = true;

    markdown-preview = {
      enable = true;
      settings = {
        browser = "firefox";
        theme = "dark";
      };
    };
  };

  extraConfigLua = ''
    require 'typst-preview'.update()
  '';

  extraPlugins = with pkgs.vimPlugins; [
    vim-visual-multi
    (pkgs.vimUtils.buildVimPlugin
    {
      pname = "typst-preview.nvim";
      version = "0.3.3";
      src = pkgs.fetchFromGitHub {
        owner = "chomosuke";
        repo = "typst-preview.nvim";
        rev = "0354cc1a7a5174a2e69cdc21c4db9a3ee18bb20a";
        sha256 = "sha256-n0TfcXJLlRXdS6S9dwYHN688IipVSDLVXEqyYs+ROG8=";
      };
    })
  ];

  keymaps = [
    {
      mode = "n";
      key = "<leader>ig";
      action = "<cmd>Neogit<cr>";
    }
    {
      mode = "n";
      key = "<leader>-";
      action = "<cmd>Oil<cr>";
    }
  ];
}
