# freebsd zshfu plugin

case $OSTYPE in
	{FreeBSD,FREEBSD,Freebsd}*);;
	*)return 1;;
esac

fpath=( $moddir/functions $fpath )
autoload -U $moddir/functions/*(:t)

export LSCOLORS=ExfxcxdxbxegedabagAcEx
alias ls='ls -GF'
compctl -K list_sysctls sysctl
compctl -c man
compctl -c info
compctl -c which
# no core dumps
limit core 0

ps() {
    if [ $1 ]; then
        /bin/ps $@
    else
        /bin/ps ux
    fi
}


# Local Variables:
#    mode:shell-script
# End:
