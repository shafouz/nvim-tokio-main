call plug#begin("~/plugins")
  Plug 'simrat39/rust-tools.nvim'

  Plug 'neovim/nvim-lspconfig'
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/nvim-cmp'
call plug#end()

lua <<EOF
  -- Set up nvim-cmp.
  local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
  end

  local cmp = require'cmp'

  cmp.setup({
    mapping = {
          ["<Tab>"] = cmp.mapping(function(fallback)
      if not cmp.select_next_item() then
        if vim.bo.buftype ~= 'prompt' and has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end
    end, { "i", "s", "c" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if not cmp.select_prev_item() then
        if vim.bo.buftype ~= 'prompt' and has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end
    end, { "i", "s", "c" }),
    ['<CR>'] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Insert }),
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' }
    })
  })

  local rt = require("rust-tools")

  rt.setup({
  })
EOF
