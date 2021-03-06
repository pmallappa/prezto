### linux / zeesh! plugin

case $OSTYPE in
	{Cygwin,CYGWIN}*);;
	*) return 1;;
esac

fpath=( $moddir/functions $fpath )
autoload -U $moddir/functions/*(:t)

setopt extended_glob
#export LS_COLORS='di=1;34:ln=35:so=32:pi=33;40:ex=31:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43:'

# no core dumps
ulimit -S -c 0 > /dev/null 2>&1

ps() {
    if [ $1 ]; then
        /bin/ps $@
    else
        /bin/ps ux
    fi
}

last-modified(){
    stat -c '%Y' $1
}

eval `dircolors ${HOME}/.dircolors/256-dark`

###
# PATHs
###
path+=(				
/tools/bin
${HOME}/devel/compilers/goroot/bin
/usr/local/llvm/bin 
$plugin_dir/bin/`uname -m`
${HOME}/bin
)

EMACS=`which emacs`
EMACSCLIENT=`which emacsclient`

case `hostname` in
	*vm)
		alias e='emacsclient -f ~/.emacs.d/server/server -n'
		;;
	*)
		;;
esac

source $moddir/lib/alias
source $moddir/lib/env

# Local Variables:
#    mode:shell-script
# End:
