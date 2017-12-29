# 共通の環境変数を設定する
export LANG=ja_JP.UTF-8
export PATH=$HOME/bin:$HOME/.rbenv/bin:/usr/local/bin:/usr/local/sbin:/bin:/usr/bin:$PATH
eval "$(rbenv init - zsh)"
export EDITOR='emacs'

# Mac用の環境変数を設定する
export HOMEBREW_CASK_OPTS='--appdir=/Applications'
export JAVA_HOME="/usr/libexec/java_home -v 1.6"
export ANDROID_HOME=/usr/local/opt/android-sdk

# エイリアスを設定する
alias sh='zsh'
alias ls='ls -aGF'
alias ll='ls -la'
alias sed='gsed'
function s() {
    ssh $1 -t /bin/zsh
}

# ssh-agentを有効にする
ssh-add ~/.ssh/id_rsa

# 補完機能を有効にする
autoload -Uz compinit
compinit -u -d ~/.zsh.d/.zcompdump
setopt complete_aliases

# キーバインドをEmacs風にする
bindkey -e
bindkey "^/" undo
bindkey "^[[/" redo

# 補完時に大文字と小文字を区別しない
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# コマンド履歴を設定する
HISTFILE=~/.zsh.d/.zsh_history.`hostname -s`
HISTSIZE=10000
SAVEHIST=10000
setopt hist_ignore_dups
setopt share_history

# コマンド履歴検索を設定する
function select-history() {
    local tac
    if which tac > /dev/null; then
    tac="tac"
    else
        tac="tail -r"
    fi
    BUFFER=`history -n 1 | eval $tac | awk '!a[$0]++' | peco`
    CURSOR=$#BUFFER
    zle reset-prompt
}
zle -N select-history
bindkey '^r' select-history

# 移動したディレクトリを保持する
setopt auto_pushd

# 補完候補を詰めて表示する
setopt list_packed

# ビープ音を無効にする
setopt nolistbeep

# プロンプトを設定する
PROMPT="%{[33m%}%/%%%{[m%} "
PROMPT2="%{[33m%}%_%%%{[m%} "
SPROMPT="%{[33m%}%r is correct? [n/y/a/e]:%{[m%} "
[ -n "${REMOTEHOST}${SSH_CONNECTION}" ] &&
    PROMPT="%{[37m%}${HOST%%.*} %{[36m%}%/%%%{[m%} "

# タイトルを設定する
case "${TERM}" in
kterm*|xterm)
    precmd() {
        echo -ne "\033]0;${USER}@${HOST%%.*}:${PWD}\007"
    }
    ;;
esac

# 色を設定する
export LSCOLORS=ExFxCxdxBxegedabagacad
export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
zstyle ':completion:*' list-colors 'di=;34;1' 'ln=;35;1' 'so=;32;1' 'ex=31;1' 'bd=46;34' 'cd=43;34'

# VCS情報を設定する
autoload -Uz vcs_info
zstyle ':vcs_info:*' formats '[%b]'
zstyle ':vcs_info:*' actionformats '[%b|%a]'
precmd () {
    psvar=()
    LANG=en_US.UTF-8 vcs_info
    [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}
RPROMPT="%1(v|%F{green}%1v%f|)"
