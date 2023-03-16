local map = function(lhs, rhs)
  vim.keymap.set('', lhs, rhs, { silent = true })
end

local nmap = function(lhs, rhs)
  vim.keymap.set('n', lhs, rhs, { silent = true })
end

local imap = function(lhs, rhs)
  vim.keymap.set('i', lhs, rhs, { silent = true })
end

vim.g.mapleader = ';'

map('.', ';')
map(' ', '.')
imap('jj', '<Esc>')
nmap('<Leader>w', ':w<CR>')
nmap('<Leader>q', ':q<CR>')
nmap('<CR>', 'o<Esc>')
nmap('<S-CR>', 'O<Esc>')
nmap('<M-h>', '<C-w>h')
nmap('<M-j>', '<C-w>j')
nmap('<M-k>', '<C-w>k')
nmap('<M-l>', '<C-w>l')
nmap('<M-H>', '<C-w>H')
nmap('<M-J>', '<C-w>J')
nmap('<M-K>', '<C-w>K')
nmap('<M-L>', '<C-w>L')
map('<Left>', '<Nop>')
map('<Down>', '<Nop>')
map('<Up>', '<Nop>')
map('<Right>', '<Nop>')
map('<PageUp>', '<Nop>')
map('<PageDown>', '<Nop>')

local telescope = require('telescope.builtin')
nmap('<C-K>', telescope.find_files)
nmap('<C-F>', telescope.live_grep)
nmap('<C-P>', ':Telescope project<CR>')
nmap('<C-T>', ':Telescope file_browser<CR>')

map('<C-_>', '<Plug>NERDCommenterToggle')