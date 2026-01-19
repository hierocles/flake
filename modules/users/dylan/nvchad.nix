{
  flake.aspects.dylan._.nvchad = {
    homeManager = {
      programs.nvchad = {
        extraConfig = ''
          -- Set up global variable to let Neovim know it's in tmux
          if vim.env.TMUX == nil then
            vim.g.tmux_navigator_disable_when_not_in_tmux = 1
          end

          -- Keybindings for navigation (must match tmux bindings)
          vim.keymap.set('n', '<C-h>', ':TmuxNavigateLeft<CR>', { silent = true })
          vim.keymap.set('n', '<C-j>', ':TmuxNavigateDown<CR>', { silent = true })
          vim.keymap.set('n', '<C-k>', ':TmuxNavigateUp<CR>', { silent = true })
          vim.keymap.set('n', '<C-l>', ':TmuxNavigateRight<CR>', { silent = true })
          vim.keymap.set('n', '<C-\\>', ':TmuxNavigatePrevious<CR>', { silent = true })
        '';
      };
    };
  };
}
