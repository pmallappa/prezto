# freebsd zshfu plugin

if [ "X"`uname` != "Xfreebsd" ]; then
    return 0
fi

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
