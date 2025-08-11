return {
    "neovim/nvim-lspconfig",
    event = "VimEnter",
    dependencies = {
	"williamboman/mason.nvim",
	"williamboman/mason-lspconfig.nvim",
    },
    opts = {
	inlay_hints = { enabled = true },
    },
    config = function()
	-- Define your icons for diagnostics
	local my_icons = {
	    Error = "",
	    Warn = "",
	    Hint = "󰋗",
	    Info = "",
	}

	-- Set up your diagnostics configuration
	vim.diagnostic.config({
	    underline = true,
	    update_in_insert = false,
	    virtual_text = {
		spacing = 4,
		source = "if_many",
		prefix = "●",
	    },
	    severity_sort = true,
	    signs = {
		text = {
		    [vim.diagnostic.severity.ERROR] = my_icons.Error,
		    [vim.diagnostic.severity.WARN] = my_icons.Warn,
		    [vim.diagnostic.severity.HINT] = my_icons.Hint,
		    [vim.diagnostic.severity.INFO] = my_icons.Info,
		},
	    },
	})

	-- Load the plugins
	local lspconfig = require("lspconfig")
	local mason = require("mason")
	local mason_lspconfig = require("mason-lspconfig")

	mason.setup({
	    ui = {
		icons = {
		    package_installed = "✓",
		    package_pending = "➜",
		    package_uninstalled = "✗"
		}
	    }
	})

	local enable_hover_menu = true

	vim.api.nvim_create_autocmd('LspAttach', {
	    group = vim.api.nvim_create_augroup('lsp-attach', { clear = true}),
	    callback = function(event)

		local map = function(keys, func, desc, mode)
		    mode = mode or 'n'
		    vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
		end

		map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
		map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
		map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
		map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
		map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
		map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
		map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')
		map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')
		map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')
	
		-- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
		---@param client vim.lsp.Client
	        ---@param method vim.lsp.protocol.Method
		---@param bufnr? integer some lsp support methods only in specific files
	        ---@return boolean
		local function client_supports_method(client, method, bufnr)
	    	    if vim.fn.has 'nvim-0.11' == 1 then
			return client:supports_method(method, bufnr)
		    else
			return client.supports_method(method, { bufnr = bufnr })
		    end
		end

		-- The following two autocommands are used to highlight references of the
		-- word under your cursor when your cursor rests there for a little while.
		--    See `:help CursorHold` for information about when this is executed
		--
		-- When you move your cursor, the highlights will be cleared (the second autocommand).
		local client = vim.lsp.get_client_by_id(event.data.client_id)

		if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
		    local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
		    vim.opt.updatetime=1000

		    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
			buffer = event.buf,
			group = highlight_augroup,
			callback = function()
			    vim.lsp.buf.document_highlight()
			    if enable_hover_menu then
				vim.lsp.buf.hover()
			    end
			end,
		    })

		    vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
			buffer = event.buf,
			group = highlight_augroup,
			callback = vim.lsp.buf.clear_references,
		    })

		    vim.api.nvim_create_autocmd('LspDetach', {
			group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
			callback = function(event2)
			    vim.lsp.buf.clear_references()
			    vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = event2.buf }
			end,
		    })
		end

		-- The following code creates a keymap to toggle inlay hints in your
		-- code, if the language server you are using supports them
		--
		-- This may be unwanted, since they displace some of your code
		vim.lsp.inlay_hint.enable(true)
		if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
		    map('<leader>th', function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
		    end, '[T]oggle Inlay [H]ints')
		end

		map('<leader>tm', function()
		    enable_hover_menu = not enable_hover_menu
		end, '[T]oggle [M]enu on Hover')

	    end
	})

	mason_lspconfig.setup({
	    ensure_installed = { "lua_ls", "clangd", "pyright", "rust_analyzer" },
	    handlers = {
		-- This function will be used for every server that has a default setup
		["*"] = function(server_name)
		    lspconfig[server_name].setup({
			on_attach = on_attach,
		    })
		end,
		-- You can add custom configurations for specific servers like this:
		lua_ls = function()
		    lspconfig.lua_ls.setup({
			on_attach = on_attach,
			settings = { Lua = { runtime = { version = 'LuaJIT' } } },
		    })
		end,
	    },
	})
    end
}
