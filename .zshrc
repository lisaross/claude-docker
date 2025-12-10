# Claude Code Development Container - zsh configuration

# History settings
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory

# Basic options
setopt autocd
setopt extendedglob
setopt nomatch
setopt notify

# Key bindings - emacs style
bindkey -e

# Prompt
PROMPT='%F{cyan}claude-dev%f %F{blue}%~%f %# '

# Claude Code PATH
export PATH="$HOME/.local/bin:$PATH"

# Node/npm PATH (for npx)
export PATH="$HOME/.npm-global/bin:$PATH"

# Git configuration prompt
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats ' (%b)'
setopt PROMPT_SUBST
RPROMPT='%F{green}${vcs_info_msg_0_}%f'

# Aliases
alias ll='ls -la'
alias la='ls -A'
alias l='ls -CF'
alias cls='clear'

# Claude Code aliases
alias cc='claude --dangerously-skip-permissions'
alias ccc='claude --continue'

# MCP testing helpers
alias mcp-list='claude mcp list'
alias mcp-add='claude mcp add'

# Welcome message
echo "🤖 Claude Code Development Container"
echo "   Run 'claude' to start Claude Code"
echo "   Run 'claude --help' for options"
echo ""
