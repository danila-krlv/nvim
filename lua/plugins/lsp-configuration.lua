---@MARK: - LSP

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

require("mason").setup()
-- Ensure the servers above are installed
local mason_lspconfig = require("mason-lspconfig")

local servers = {
}

mason_lspconfig.setup {
   ensure_installed = vim.tbl_keys(servers),
}

require("lspconfig").gleam.setup {}

---@MARK - General configuration

local on_attach = function(_, bufnr)
   vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

   local opts = { buffer = bufnr, silent = true }

   vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
   vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
   vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
   vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
   vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
   vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, opts)
   vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
   vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
   vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
   vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
   vim.keymap.set("n", "<space>f", function()
      if vim.bo.filetype == "lua" then
         vim.cmd("LuaFormat")
      else
         vim.lsp.buf.format { async = true }
      end
   end, opts)
end

mason_lspconfig.setup_handlers {
   function(server_name)
      require("lspconfig")[server_name].setup {
         capabilities = capabilities,
         on_attach = on_attach,
         settings = servers[server_name],
         filetypes = (servers[server_name] or {}).filetypes,
      }
   end,
}

--TODO: Move to servser!
require("lspconfig").sourcekit.setup {
   capabilities = capabilities,
   on_attach = on_attach,
}

-- Completion

local cmp = require("cmp")
local luasnip = require("luasnip")

require("luasnip.loaders.from_vscode").lazy_load()
luasnip.config.setup()

cmp.setup {
   experimental = {
      ghost_text = true,
   },
   snippet = {
      expand = function(args)
         luasnip.lsp_expand(args.body)
      end,
   },
   mapping = cmp.mapping.preset.insert {
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<CR>"] = cmp.mapping.confirm { select = true },
      ["<Tab>"] = cmp.mapping(function(fallback)
         if cmp.visible() then
            cmp.select_next_item()
         elseif luasnip.locally_jumpable(1) then
            luasnip.jump(1)
         else
            fallback()
         end
      end, { "i", "s" }),

      ["<S-Tab>"] = cmp.mapping(function(fallback)
         if cmp.visible() then
            cmp.select_prev_item()
         elseif luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
         else
            fallback()
         end
      end, { "i", "s" }),
   },
   sources = cmp.config.sources {
      { name = "copilot" },
      { name = "luasnip" },
      { name = "nvim_lsp" },
      { name = "buffer" },
      { name = "path" },
   },
}
