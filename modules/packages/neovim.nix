_: {
  homeManager.base = {pkgs, ...}: {
    catppuccin.nvim.enable = false;

    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      withRuby = false;
      withPython3 = false;

      extraPackages = with pkgs; [
        # LSP servers
        pyright
        typescript-language-server
        nil
        helm-ls
        yaml-language-server
        ruff
        # Formatters
        prettierd
      ];

      plugins = with pkgs.vimPlugins; [
        {
          plugin = catppuccin-nvim;
          type = "lua";
          config = ''
            require("catppuccin").setup({ flavour = "frappe" })
            vim.cmd.colorscheme("catppuccin")
          '';
        }
        {
          plugin = which-key-nvim;
          type = "lua";
          config = ''require("which-key").setup()'';
        }
        {
          plugin = gitsigns-nvim;
          type = "lua";
          config = ''require("gitsigns").setup()'';
        }
        { plugin = plenary-nvim; type = "lua"; }
        {
          plugin = todo-comments-nvim;
          type = "lua";
          config = ''require("todo-comments").setup()'';
        }
        {
          plugin = telescope-nvim;
          type = "lua";
          config = ''
            local t = require("telescope.builtin")
            vim.keymap.set("n", "<leader>ff", t.find_files)
            vim.keymap.set("n", "<leader>fg", t.live_grep)
            vim.keymap.set("n", "<leader>fb", t.buffers)
          '';
        }
        { plugin = nvim-web-devicons; type = "lua"; }
        { plugin = nui-nvim; type = "lua"; }
        # {
        #   plugin = neo-tree-nvim;
        #   type = "lua";
        #   config = ''
        #     vim.schedule(function()
        #       require("neo-tree").setup()
        #     end)
        #     vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<cr>")
        #   '';
        # }
        # {
        #   plugin = nvim-treesitter.withAllGrammars;
        #   type = "lua";
        #   config = ''
        #     vim.schedule(function()
        #       require("nvim-treesitter.configs").setup({
        #         highlight = { enable = true },
        #         indent = { enable = true },
        #       })
        #     end)
        #   '';
        # }
        { plugin = cmp-nvim-lsp; type = "lua"; }
        {
          plugin = nvim-cmp;
          type = "lua";
          config = ''
            local cmp = require("cmp")
            cmp.setup({
              mapping = cmp.mapping.preset.insert({
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<CR>"] = cmp.mapping.confirm({ select = true }),
                ["<Tab>"] = cmp.mapping.select_next_item(),
                ["<S-Tab>"] = cmp.mapping.select_prev_item(),
              }),
              sources = cmp.config.sources({ { name = "nvim_lsp" } }),
            })
          '';
        }
        {
          plugin = conform-nvim;
          type = "lua";
          config = ''
            require("conform").setup({
              formatters_by_ft = {
                python     = { "ruff_format" },
                javascript = { "prettierd", "prettier", stop_after_first = true },
                typescript = { "prettierd", "prettier", stop_after_first = true },
                svelte     = { "prettierd", "prettier", stop_after_first = true },
                nix        = { "alejandra" },
              },
              format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
            })
          '';
        }
        {
          plugin = nvim-lspconfig;
          type = "lua";
          config = ''
            local caps = require("cmp_nvim_lsp").default_capabilities()

            vim.lsp.config("*", { capabilities = caps })
            vim.lsp.enable({ "pyright", "ts_ls", "nil_ls", "helm_ls", "yamlls", "ruff" })

            vim.keymap.set("n", "gd",          vim.lsp.buf.definition)
            vim.keymap.set("n", "K",            vim.lsp.buf.hover)
            vim.keymap.set("n", "<leader>rn",   vim.lsp.buf.rename)
            vim.keymap.set("n", "<leader>ca",   vim.lsp.buf.code_action)
            vim.keymap.set("n", "<leader>d",    vim.diagnostic.open_float)
          '';
        }
      ];
    };
  };
}
