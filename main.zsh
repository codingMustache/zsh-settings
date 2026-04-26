# Options
if [ -f ~/.config/zsh/src/options.zsh ]; then
    source ~/.config/zsh/src/options.zsh
else
    print "404: Options config Not Found"
fi

# Aliases
if [ -f ~/.config/zsh/src/alias.zsh ]; then
    source ~/.config/zsh/src/alias.zsh
else
    print "404: Alias config Not Found"
fi

# Prompt
if [ -f ~/.config/zsh/src/prompt.zsh ]; then
    source ~/.config/zsh/src/prompt.zsh
else
    print "404: Prompt config Not Found"
fi

# keymap
if [ -f ~/.config/zsh/src/keymap.zsh ]; then
    source ~/.config/zsh/src/keymap.zsh
else
    print "404: Keymap config Not Found"
fi

# Functions
if [ -f ~/.config/zsh/src/functions.zsh ]; then
    source ~/.config/zsh/src/functions.zsh
else
    print "404: Functions config Not Found"
fi
