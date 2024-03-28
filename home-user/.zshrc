## src:
## https://www.altlinux.org/DotFiles/Shells/Zsh/%D0%A1%D0%BE%D0%B2%D0%B5%D1%82%D1%8B#.D0.9D.D0.B0.D1.81.D1.82.D1.80.D0.BE.D0.B9.D0.BA.D0.B0_.D0.BF.D1.80.D0.B8.D0.B3.D0.BB.D0.B0.D1.88.D0.B5.D0.BD.D0.B8.D1.8F
## https://wiki.archlinux.org/title/Zsh_(%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9)
## https://eax.me/zsh/
## https://zsh.sourceforge.io/Doc/Release/Prompt-Expansion.html
## https://www.soberkoder.com/better-zsh-history/
## https://jdhao.github.io/2021/03/24/zsh_history_setup/

# history settings
export HISTFILE=~/.zsh_history
export HISTSIZE=1000000   # the number of items for the internal history list
export SAVEHIST=1000000   # maximum number of items for the history file
setopt HIST_IGNORE_ALL_DUPS  # do not put duplicated command into history list
setopt HIST_SAVE_NO_DUPS  # do not save duplicated command
setopt HIST_REDUCE_BLANKS  # remove unnecessary blanks
setopt INC_APPEND_HISTORY_TIME  # append command to history file immediately after execution
setopt EXTENDED_HISTORY  # record command start time


# add autocomplete function
autoload -U compinit
compinit

# add colors
autoload -U colors
colors

# add color highlight
zmodload zsh/complist
zstyle ':completion:*' menu yes select

# colorful menu items
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}


# coloring commands
if [ -f /usr/bin/grc ]; then
 alias gcc="grc --colour=auto gcc"
 alias irclog="grc --colour=auto irclog"
 alias log="grc --colour=auto log"
 alias netstat="grc --colour=auto netstat"
 alias ping="grc --colour=auto ping"
 alias proftpd="grc --colour=auto proftpd"
 alias traceroute="grc --colour=auto traceroute"
fi


# add process in kill and killall
zstyle ':completion:*:processes' command 'ps -xuf'
zstyle ':completion:*:processes' sort false
zstyle ':completion:*:processes-names' command 'ps xho command'

# prompt format
# PROMPT="%{$fg[red]%}%n%{$reset_color%}@%{$fg[blue]%}%m %{$fg_no_bold[yellow]%}%1~ %{$reset_color%}%#"
# RPROMPT="[%{$fg_no_bold[yellow]%}%?%{$reset_color%}]"
# man zshmisc в главе PROMPT EXPANSION. К примеру, вы можете, для начала, установить (если оно еще не установлено) самое обычное приглашение:
#PROMPT="%n@%m %~ %(!.#.$) "
#PROMPT= "%(!.%{\e[1;31m%}%n@%m%{\e[0m%}.%{\e[1;32m%}%n@%m%{\e[0m%}):%{$fg_no_bold[yellow]%}%1~%{$reset_color%}%(!.#.$) "
#RPROMPT="%(!.%{\e[1;36m%}%*%{\e[0m%}.%{\e[0;36m%}%*%{\e[0m%})"

PROMPT="%{$fg_bold[green]%}%n@%m%{$reset_color%}:%{$fg_no_bold[yellow]%}%0~%{$reset_color%}%(!.#.$) "
RPROMPT="%{$fg_no_bold[cyan]%}%*%{$reset_color%}"

# После этого в правой части командной строки вы будете видеть текущее время. 

## Темы приглашений
autoload -U promptinit
promptinit
## Если вы хотите придумать оригинальное и удобное приглашение, то сначала я рекомендую вам взглянуть на уже существующие. 
## Вдруг там вы найдете подходящую или решите позаимствовать из понравившийся нужный элемент. Выполните следующие команды:
## 
## $ autoload promptinit
## $ promptinit
## $ prompt -l
## 
## В результате вы увидите список из 15 предустановленных тем для приглашения. 
## Попробовать понравившуюся можно командой promptinit название_темы Команда prompt -p выдает примеры всех установленных тем строки приглашения. 

# add extract command
extract () {
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2) tar xvjf $1   ;;
      *.tar.gz)  tar xvzf $1   ;;
      *.tar.xz)  tar xvfJ $1   ;;
      *.bz2)     bunzip2 $1    ;;
      *.rar)     unrar x $1    ;;
      *.gz)      gunzip $1     ;;
      *.tar)     tar xvf $1    ;;
      *.tbz2)    tar xvjf $1   ;;
      *.tgz)     tar xvzf $1   ;;
      *.zip)     unzip $1      ;;
      *.Z)       uncompress $1 ;;
      *.7z)      7z x $1       ;;
      *)         echo "'$1' cannot be extracted via >extract<" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}
# Теперь архивы можно распаковывать командой extract архив без мучительного вспоминания аргументов и тп. 



# вместо cd /path/to/file вам нужно ввести лишь путь! 
# Чтобы уже начать пользоваться этой удобной возможностью, добавьте еще одну строчку в ~/.zshrc:
setopt autocd

# global pseudos
alias -g L='| less'
alias -g G='| grep'
alias -g GI='|grep -i'
alias -g H='| head'
alias -g T='| tail'
alias -g S='| sort'
alias -g SU='|sort -u'
alias -g P='| patch -p1'
alias -g PD='| patch -p1 --dry-run'
alias -g WC='| wc -l'
alias -g IK='| iconv -c -f koi8r -t cp1251'
alias -g IU='| iconv -c -f utf8 -t cp1251'

# enable autocorrect
setopt CORRECT_ALL

# enable magic search in history
autoload -U predict-on
zle -N predict-on
zle -N predict-off
bindkey "^X^Z" predict-on # C-x C-z
bindkey "^Z" predict-off # C-z
# Теперь, если нажать Ctr+X Ctrl+Z, при вводе команды будет автоматически производится поиск в истории по первым буквам команды. 
# Нажатие Ctrl+Z отключит этот режим. 

# ignore same history
setopt HIST_IGNORE_DUPS

# enable tetris
autoload -U tetris
zle -N tetris
bindkey ^T tetris
# Потом жмем Ctrl-T и играем :) Вместо ^T можно использовать любое другое сочетание клавиш. Выход - q. 

# enable calc
autoload -U zcalc

# normal keys behavior
[[ -n "${key[Home]}"     ]]  && bindkey  "${key[Home]}"     beginning-of-line
[[ -n "${key[End]}"      ]]  && bindkey  "${key[End]}"      end-of-line
[[ -n "${key[Insert]}"   ]]  && bindkey  "${key[Insert]}"   overwrite-mode
[[ -n "${key[Delete]}"   ]]  && bindkey  "${key[Delete]}"   delete-char
[[ -n "${key[Up]}"       ]]  && bindkey  "${key[Up]}"       up-line-or-history
[[ -n "${key[Down]}"     ]]  && bindkey  "${key[Down]}"     down-line-or-history
[[ -n "${key[Left]}"     ]]  && bindkey  "${key[Left]}"     backward-char
[[ -n "${key[Right]}"    ]]  && bindkey  "${key[Right]}"    forward-char
# [[ -n "${key[PageUp]}"   ]]  && bindkey  "${key[PageUp]}"   beginning-of-buffer-or-history
# [[ -n "${key[PageDown]}" ]]  && bindkey  "${key[PageDown]}" end-of-buffer-or-history
# search in history
[[ -n "${key[PageUp]}"   ]]  && bindkey  "${key[PageUp]}"    history-beginning-search-backward
[[ -n "${key[PageDown]}" ]]  && bindkey  "${key[PageDown]}"  history-beginning-search-forward

# command alias
alias la="ls -laL --color=auto"
alias lad="ls -laL --color=auto | grep -E '^d'"
alias aptupdate="sudo apt update"
alias aptupgrade="sudo apt update && sudo apt upgrade"
alias -s txt=mcedit
alias -s py=codium
alias -s json=codium
alias -s ini=mcedit
alias -s conf=mcedit
alias trace="traceroute"
alias zshconf="source ~/.zshrc"
alias zshedit="mcedit ~/.zshrc"
alias md="mkdir"
alias rd="rmdir"
alias dir="ls -laL --color=auto"
alias dirs="ls -laL | grep -E '^d'"
alias home="cd ~"
alias ns="nslookup"
alias nsall="nslookup -type=any"


