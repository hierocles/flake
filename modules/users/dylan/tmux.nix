{pkgs, ...}: {
  flake.aspects.dylan._.tmux = {
    homeManager = {
      # Add packages needed by tmux plugins
      home.packages = with pkgs; [
        wl-clipboard # For tmux-thumbs clipboard integration (Wayland)
      ];

      programs.tmux = {
        enable = true;
        shell = "${pkgs.fish}/bin/fish";
        terminal = "tmux-256color";
        historyLimit = 100000;
        keymode = "vi";
        baseIndex = 1;

        plugins = with pkgs.tmuxPlugins; [
          # Sensible defaults (no config needed)
          sensible

          # Better mouse behavior
          better-mouse-mode

          # Session persistence
          {
            plugin = resurrect;
            extraConfig = ''
              set -g @resurrect-save 'S'
              set -g @resurrect-restore 'R'
              set -g @resurrect-capture-pane-contents 'on'
              set -g @resurrect-strategy-nvim 'session'
              set -g @resurrect-processes 'ssh psql mysql'
            '';
          }

          # Hint-based text copying
          {
            plugin = tmux-thumbs;
            extraConfig = ''
              set -g @thumbs-key Space
              set -g @thumbs-command 'echo -n {} | wl-copy || tmux set-buffer -- {}'
              set -g @thumbs-upcase-command 'echo -n {} | wl-copy || tmux set-buffer -- {}'
              set -g @thumbs-bg-color blue
              set -g @thumbs-fg-color green
              set -g @thumbs-hint-bg-color red
              set -g @thumbs-hint-fg-color black
            '';
          }

          # Pattern searching (file paths, URLs, git status, etc.)
          copycat

          # URL extraction and opening
          urlview

          # Neovim integration
          vim-tmux-navigator

          # Catppuccin theme
          {
            plugin = catppuccin;
            extraConfig = ''
              set -g @catppuccin_flavour 'mocha'
              set -g @catppuccin_window_tabs_enabled on
              set -g @catppuccin_date_time "%H:%M"
            '';
          }
        ];
        extraConfig = ''
          # ============================================================================
          # Quick Reference:
          # - Prefix key: Ctrl-a (instead of default Ctrl-b)
          #
          # Window & Pane Management:
          # - Split window vertically: Prefix + |
          # - Split window horizontally: Prefix + -
          # - Navigate panes: Prefix + h/j/k/l (vim-style) or mouse click
          # - New window: Prefix + c
          # - Next/Previous window: Prefix + n/p or Prefix + number
          # - Resize panes: Prefix + H/J/K/L (shift + hjkl)
          # - Zoom/unzoom pane: Prefix + z
          #
          # Copy & Paste:
          # - Enter copy mode: Prefix + [
          # - Start selection: v (in copy mode)
          # - Copy selection: y (in copy mode)
          # - Paste: Prefix + p
          # - Quick copy with hints: Prefix + Space (tmux-thumbs)
          #
          # Session Management:
          # - Save session: Prefix + S (resurrect)
          # - Restore session: Prefix + R (resurrect)
          # - Detach: Prefix + d
          #
          # Search & URLs:
          # - Search file paths: Prefix + Ctrl-f (copycat)
          # - Search URLs: Prefix + Ctrl-u (copycat)
          # - Open URLs: Prefix + u (urlview)
          #
          # Other:
          # - Reload config: Prefix + r
          # - Show all keybindings: Prefix + ?
          # ============================================================================

          # Change prefix from Ctrl-b to Ctrl-a (more ergonomic, like screen)
          unbind C-b
          set -g prefix C-a
          bind C-a send-prefix

          # Enable mouse support for clicking, scrolling, and resizing
          set -g mouse on

          # Start window and pane numbering at 1 (not 0) for easier keyboard access
          set -g base-index 1
          setw -g pane-base-index 1

          # Automatically renumber windows when one is closed
          set -g renumber-windows on

          # Increase scrollback buffer size
          set -g history-limit 100000

          # ============================================================================
          # KEY BINDINGS
          # ============================================================================

          # Split windows with intuitive symbols (and open in current directory)
          bind | split-window -h -c "#{pane_current_path}"
          bind - split-window -v -c "#{pane_current_path}"
          unbind '"'
          unbind %

          # Create new window in current directory
          bind c new-window -c "#{pane_current_path}"

          # Vim-style pane navigation (Prefix + h/j/k/l)
          bind h select-pane -L
          bind j select-pane -D
          bind k select-pane -U
          bind l select-pane -R

          # Resize panes with Shift + vim keys (Prefix + H/J/K/L)
          bind -r H resize-pane -L 5
          bind -r J resize-pane -D 5
          bind -r K resize-pane -U 5
          bind -r L resize-pane -R 5

          # Quick pane switching with Alt + arrow keys (no prefix needed)
          bind -n M-Left select-pane -L
          bind -n M-Right select-pane -R
          bind -n M-Up select-pane -U
          bind -n M-Down select-pane -D

          # Reload configuration file (Prefix + r)
          bind r source-file ~/.config/tmux/tmux.conf \; display "Config reloaded!"

          # ============================================================================
          # VISUAL IMPROVEMENTS
          # ============================================================================

          # Highlight active pane with a colored border
          set -g pane-active-border-style "fg=cyan"
          set -g pane-border-style "fg=brightblack"

          # Display pane numbers longer (when using Prefix + q)
          set -g display-panes-time 2000

          # Show more informative window status
          set -g automatic-rename on
          set -g automatic-rename-format '#{b:pane_current_path}'

          # ============================================================================
          # COPY MODE IMPROVEMENTS (VI-STYLE)
          # ============================================================================

          # Enter copy mode with Prefix + [
          # Start selection with 'v', copy with 'y', paste with Prefix + p

          # Use 'v' to begin selection in copy mode (like vim)
          bind -T copy-mode-vi v send-keys -X begin-selection

          # Use 'y' to copy (yank) selection
          bind -T copy-mode-vi y send-keys -X copy-selection-and-cancel

          # Use 'Ctrl-v' for block/rectangle selection
          bind -T copy-mode-vi C-v send-keys -X rectangle-toggle

          # Paste with Prefix + p
          bind p paste-buffer

          # ============================================================================
          # QUALITY OF LIFE IMPROVEMENTS
          # ============================================================================

          # Reduce escape time for faster command sequences (helps with vim)
          set -sg escape-time 10

          # Enable focus events (useful for vim/neovim)
          set -g focus-events on

          # Increase message display time
          set -g display-time 2000

          # Enable RGB color support
          set -ag terminal-overrides ",xterm-256color:RGB"

          # Allow terminal to set window titles
          set -g set-titles on
          set -g set-titles-string "#T"

          # Monitor activity in other windows
          setw -g monitor-activity on
          set -g visual-activity off

          # ============================================================================
          # PLUGIN USAGE GUIDE
          # ============================================================================
          #
          # resurrect - Session Persistence:
          #   Save current session: Prefix + Shift-s
          #   Restore last session: Prefix + Shift-r
          #   Sessions are saved to ~/.local/share/tmux/resurrect/
          #   Survives system reboots and tmux restarts
          #
          # tmux-thumbs - Quick Text Copying:
          #   Trigger: Prefix + Space
          #   Shows letter hints for paths, URLs, git SHAs, IP addresses
          #   Type the hint letters to copy text to clipboard
          #   Great for copying file paths or URLs without mouse
          #
          # copycat - Pattern Search:
          #   Search file paths: Prefix + Ctrl-f
          #   Search git files: Prefix + Ctrl-g
          #   Search URLs: Prefix + Ctrl-u
          #   Search digits: Prefix + Ctrl-d
          #   Search IP addresses: Prefix + Alt-i
          #   Navigate results: n (next), N (previous)
          #
          # urlview - URL Management:
          #   Extract URLs: Prefix + u
          #   Opens a menu of all URLs in current pane
          #   Select one to open in browser
          #
          # ============================================================================
          # HELPFUL TIPS
          # ============================================================================
          # To see all key bindings: Prefix + ?
          # To detach from session: Prefix + d
          # To list sessions: tmux ls
          # To attach to session: tmux attach -t <name>
          # To kill a pane: Prefix + x (then confirm with 'y')
          # To zoom/unzoom a pane: Prefix + z
          # To show pane numbers: Prefix + q (then type number to switch)
          # ============================================================================
        '';
      };
    };
  };
}
