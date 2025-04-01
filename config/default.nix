{pkgs, ...}: let
  ruff = "${pkgs.ruff}/bin/ruff";
  stylua = "${pkgs.stylua}/bin/stylua";
  alejandra = "${pkgs.alejandra}/bin/alejandra";
  isort = "${pkgs.isort}/bin/isort";
  rustfmt = "${pkgs.rustfmt}/bin/rustfmt";
  typstyle = "${pkgs.typstyle}/bin/typstyle";
  google-java-format = "${pkgs.google-java-format}/bin/google-java-format";
in {
  opts = {
    signcolumn = "yes";
    shiftwidth = 2;
    number = true;
    wrap = false;
  };

  globals = {
    maplocalleader = " ";
    mapleader = " ";
  };

  performance.combinePlugins = {
    enable = true;
    standalonePlugins = [
      "oil.nvim"
      "lualine.nvim"
      "leap.nvim"
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
        typst = ["typstyle"];
        java = ["google-java-format"];
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
        typstlye.commad = typstyle;
        google-java-format.command = google-java-format;
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
        jdtls.enable = true;
        pyright.enable = true;
        dartls.enable = true;
        nixd.enable = true;
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
        svelte.enable = true;
        clangd.enable = true;
	clojure_lsp.enable = true;
        tinymist = {
          enable = true;
          extraOptions.offset_encoding = "utf-8";
          settings.exportPdf = "onSave";
        };
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
      fromVscode = [
        {
          lazyLoad = true;
          paths = "${pkgs.vimPlugins.friendly-snippets}";
        }
      ];
    };

    notify = {
      enable = true;
    };

    noice = {
      enable = true;
      settings = {
        notify = {
          enabled = false;
          view = "notify";
        };
        messages = {
          enabled = true;
          view = "mini";
        };
        lsp = {
          message = {
            enabled = false;
          };
          progress = {
            enabled = false;
            view = "mini";
          };
        };
        popupmenu = {
          enabled = true;
          backend = "nui";
        };
      };
    };
    gitsigns.enable = true;

    neogit.enable = true;

    oil.enable = true;

    nvim-autopairs.enable = true;

    nvim-surround.enable = true;

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
    require("typst-preview").setup()
  '';

  extraPlugins = with pkgs.vimPlugins; [
    typst-preview-nvim
    linediff-vim
    tagbar
    (pkgs.vimUtils.buildVimPlugin {
      name = "vim-easy-replace";
      src = pkgs.fetchFromGitHub {
        owner = "kqito";
        repo = "vim-easy-replace";
        rev = "4f86aff2d0a4a930f892d741c3fd7871e269852b";
        sha256 = "sha256-Vw9/PFb45O5FRohGqjMy77ONdRPgJ2GI2trXjkVqfdg=";
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
    {
      mode = "n";
      key = "<leader>\\";
      action = "<cmd>Tagbar<cr>";
    }
    {
      mode = "n";
      key = "<leader>un";
      action = ''
        <cmd>lua require("notify").dismiss({ silent = true, pending = true })<cr>
      '';
      options = {
        desc = "Dismiss All Notifications";
      };
    }
  ];
}
