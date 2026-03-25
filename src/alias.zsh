# Aliases
#
alias sr="source ~/.zshrc"
alias ll="ls -alF"
alias la="ls -A"
alias l="ls -CF"
alias repos='cd ~/Documents/Repos'
alias gitlog='git log --decorate --oneline --graph'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# SSH
alias router='ssh root@router.lan'
alias server='ssh jorge@server.lan'

# Media Aliases
alias pushMovies='rsync -rlvz \
--progress \
--no-owner --no-group --no-perms \
--exclude=".DS_Store" \
--exclude=".deletedByTmm" \
--remove-source-files \
--checksum \
 ~/Downloads/transfer/Movies/* \
jorge@server.lan:/hdd2/media/movies/'

alias pushMusic='rsync -rlvz \
--progress \
--no-owner --no-group --no-perms \
--exclude=".DS_Store" \
--exclude=".deletedByTmm" \
--remove-source-files \
--checksum \
~/Downloads/transfer/Music/* \
jorge@server.lan:/hdd2/media/music/'

alias pushTV='rsync -rlvz \
--progress \
--no-owner --no-group --no-perms \
--remove-source-files \
--exclude=".DS_Store" \
--exclude=".deletedByTmm" \
--checksum \
~/Downloads/transfer/TV/* \
jorge@server.lan:/hdd2/media/tv/'

alias pushAudioBooks='rsync -rlvz \
--progress \
--remove-source-files \
--no-owner --no-group --no-perms \
--exclude=".DS_Store" \
--exclude=".deletedByTmm" \
--checksum \
~/Downloads/transfer/AudioBooks/* \
jorge@server.lan:/hdd2/media/audiobooks/'


# program aliases
alias cat=bat
