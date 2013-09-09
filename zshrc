# ----------------------------------------------------------------------------
#   Zshrc
#   Author 	: Grubly
#   Patched by 	: Milipili, f00ty
# ----------------------------------------------------------------------------

# --------------------------------------------------------------- Settings ---
USER=`whoami`
OS=`uname -s`
MYEDITOR="emacs"

# ------------------------------------------------------ ZSH Configuration ---

if [ -f /etc/profile ]; then
	source /etc/profile 2>/dev/null >/dev/null
fi

## Am I a special user ??
if (( EUID == 0 )); then
	superUser="yes";
else
	groups | egrep "wheel|adm|staff|sys|es" > /dev/null
	if [ "$?" -eq 0 ]; then 
		superUser="yes";
	else
		superUser="no";
	fi;
fi;

## Eterm is not recognised by most OSes
if [[ $TERM = "Eterm" ]] ; then
	case $OS in
      	    Linux)
		export TERM=Eterm 
		;;
	    NetBSD)
		export TERM=xterm
		;;
	    Darwin)
		export TERM=xterm
		;;
	    *)
		export TERM=xterm-color
        	;;
	esac
fi

## xterm is not recognized by NetBSD (1.6)
if  [[ $TERM = "xterm-color" ]] ; then
    case $OS in 
	NetBSD)
	    export TERM=xterm
	    ;;
	Darwin)
	    export TERM=xterm
	    ;;
	esac
fi	

# Default umask
umask 022

if [ "$OS" = 'FreeBSD' ]; then
	export EDITOR="/usr/local/bin/$MYEDITOR"
else
	export EDITOR="/usr/bin/$MYEDITOR"
fi

addExportPath()
{
	if [ -d "$1" ] ; then
		export PATH="$PATH:$1"
		if [ ! "$2" = "" -a "$superUser" = '1' -a -d "$2" ]; then
			export PATH="$PATH:$2"
		fi
	fi
}

addExportPath '/opt/local/bin'  '/opt/local/sbin'
addExportPath '/usr/local/bin'  '/usr/local/sbin'


# Misc options
setopt correct
setopt correct_all
setopt auto_cd
setopt hist_ignore_dups
setopt auto_list
setopt append_history
setopt auto_param_keys
setopt auto_param_slash
setopt bg_nice
setopt complete_aliases
setopt equals
setopt extended_glob
setopt hash_cmds
setopt hash_dirs
setopt mail_warning
setopt magic_equal_subst
setopt numericglobsort
setopt pushd_ignore_dups
setopt printeightbit
unsetopt beep

# Filename suffixes to ignore during completion
#fignore=(.o .c~ .pro)

## Prevent CVS/SVN files/directories from being completed
#zstyle ':completion:*:(all-|)files' ignored-patterns '(|*/)CVS'
#zstyle ':completion:*:cd:*' ignored-patterns '(*/)#CVS'
#zstyle ':completion:*:(all-|)files' ignored-patterns '(|*/)svn'
#zstyle ':completion:*:cd:*' ignored-patterns '(*/)#svn'

# ignore patterns you don't have
zstyle ':completion:*:functions' ignored-patterns '_*'
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete
zstyle ':completion:*' format '-- Completing %d --'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors $LS_COLORS
# depends des gouts
zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
zstyle ':completion:*' matcher-list '' 'l:|=* r:|=*' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' max-errors 3
zstyle ':completion:*' menu select=1
zstyle ':completion:*' prompt '[%e]'
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle ':completion:*' verbose true
zstyle ':completion:*' users $myusers
zstyle ':completion:*' hosts $myhosts
zstyle ':completion:*:processes' command 'ps -au$USER'
zstyle ':completion:*:*:tar:*' file-patterns '*.tgz:archive:archives *.tar*:archive:archives *.tbz:archive:archives *(-/):repertoires:repertoires'

## set colors for GNU ls ; set this to right file
if [ "$SHELL" = '' ]; then # fixing
        export SHELL=`which zsh`
fi
my_ls=ls
which gls > /dev/null
if [ $? -eq 0 ]; then
	my_ls=gls
fi

which dircolors > /dev/null
if [ $? -eq 0 ]; then
	eval `dircolors`
	export LS_COLORS="no=00:fi=00:di=01;36:ln=00;32:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.png=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:"
	ls=$my_ls' -F --color=always'
else
	## dircolors not availaible, try gdircolors
	which gdircolors > /dev/null
	if [ $? -eq 0 ]; then
		eval `gdircolors -b`
		ls=$my_ls' --color=auto'
		alias df='gdf'
	else	
		## GNU ls not available, using other one.
		 export LS_COLORS="no=00:fi=00:di=01;36:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.png=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:"
		case $OS in
        	FreeBSD)
				export BLOCKSIZE=K
				export CLICOLOR=enable
  				autoload -U is-at-least
        			export LS_COLORS="gxfxBxcxbxegedabagacad"
				ls='ls -F'
        	;;
        	OpenBSD|NetBSD|Darwin|SunOS)
        		ls='ls -F -G'
        	;;
		esac
	fi
fi

source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Aliases
alias l='ls -lh'
alias ll='ls -l'
alias la='ls -A'

# Good prompts
autoload -U colors
colors

path_color="yellow"
sym_color="cyan"
time_color="white"
err_color="red"
num_color="blue"
computer_color="cyan"
if [ "$USER" = "root" ]; then
	login_color="red"
else
	login_color="green"
fi
cpath="%B%{$fg[$path_color]%}%30<...<%~%b"
psym="%{$fg[$sym_color]%}%%"
plogin="%{$fg[$login_color]%}[$USER]"
time="%{$fg[$time_color]%}%T"
error="%B%{$fg[$err_color]%}Err %?%b"
reset="%{$reset_color%}"
num="%{$fg[$num_color]%}#%h"
computer="%b%{$fg[$computer_color]%}QC-`hostname | cut -d"." -f1`%B"
PS1="$computer $plogin $cpath $psym $reset"
RPS1="%(?,$time,$error) $num$reset"

# Completion options
autoload mere zed zfinit
autoload incremental-complete-word
zle -N incremental-complete-word

# Always use emacs-mode
bindkey -e 


# Bindkeys, easier life.
bindkey i incremental-complete-word 
bindkey  history-incremental-search-backward
bindkey \[1~ beginning-of-line
bindkey \[4~ end-of-line
bindkey  beginning-of-line
bindkey  end-of-line
bindkey  kill-line
bindkey  kill-whole-line
bindkey  yank
bindkey  vi-forward-word
bindkey  vi-backward-word
	

autoload insert-files
autoload nslookup
autoload predict-on
autoload compinit
autoload complist
compinit

zstyle ':completion:*' format '%{[32m%}--- %{[01m%}%d%{[0m%}'
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _complete _correct _approximate
zstyle ':completion:*' group-name ''
zstyle ':completion:*' insert-unambiguous true
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'l:|=* r:|=*' 'r:|[
._-]=* r:|=*'

zstyle ':completion:*' max-errors 2
zstyle ':completion:*' menu select=5
zstyle ':completion:*' original true
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' verbose true
zstyle ':completion:*:processes' list-colors '=(#b)(?????)(#B)?????????????????????????????????([^ ]#/)#(#b)([^ /]#)*=00=01;31=01;33'
zstyle ':completion:*:processes' command 'ps -au$USER'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' force-list always
zstyle ':completion:*' users milipili root admin footy

zstyle ':completion:*:rm:*' ignore-line yes
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

zstyle ':completion:*:*:xdvi:*' menu yes select
zstyle ':completion:*:*:xdvi:*' file-sort time

zstyle '*:hosts' hosts localhost shikami.org nyu.be ssh.epita.fr 

export EDITOR=$MYEDITOR



# LS
case $OS in
      	FreeBSD) alias ls="$ls -w";;
      	Darwin|Linux) alias ls="$ls -v";;
        OpenBSD|NetBSD|SunOS) alias ls="$ls" ;;
esac


# Aliases
alias l='ls -lh'
alias ll='ls -l'
alias la='ls -A'



if [ "$OS" = 'Darwin' ]; then  # Hack pour Terminal
export TERM='xterm' 
fi
if [ "$OS" = 'Linux' ]; then 
	if [ ! "`which htop`" = '' ]; then
		alias top="htop"
	fi
	alias grep="grep --color"
fi


if [ "$OS" = 'Darwin' ]; then
	alias log="tail -n 20 /var/log/system.log"
else
	alias log="tail -n 20 /var/log/messages"
fi

echo
echo "     Quanta Computing - Welcome "$USER" on `hostname` !"
echo

# Faire fonctioner backspace dans tous les cas
case $TERM in
    *xterm*|rxvt|(dt|k|E)term)
    	bindkey '^?' backward-delete-char 
		bindkey "^[[3~"	delete-char
		;;
		esac

# Good for you :)
if [ "$TERM" '!=' 'linux' ]; then
  precmd() {print -Pn "\e]0;%n@%m: %~\a"}
fi
