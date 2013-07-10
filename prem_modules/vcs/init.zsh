autoload -U add-zsh-hook

#fpath=( $moddir/comp $moddir/functions $fpath )
#autoload -U $moddir/functions/*(:t) $moddir/comp/*(:t)

######
## Heart of vcs_info
######
function {
    local enabled
    local disabled
    zstyle -a ':prems:module:vcs' enabled 'enabled'
    zstyle -a ':prems:module:vcs' disabled 'disabled'

    zstyle ':vcs_info:*' disable $disabled
    zstyle ':vcs_info:*' enable $enabled
}

# Only run vcs_info when necessary to speed up the prompt and make using
# check-for-changes bearable in bigger repositories. This setup was
# inspired by Bart Trojanowski
# (http://jukie.net/~bart/blog/pimping-out-zsh-prompt).
#
# This setup is by no means perfect. It can only detect changes done
# through the VCS's commands run by the current shell. If you use your
# editor to commit changes to the VCS or if you run them in another shell
# this setup won't detect them. To fix this just run "cd ." which causes
# vcs_info to run and update the information. If you use aliases to run
# the VCS commands update the case check below.
zstyle ':vcs_info:*+pre-get-data:*' hooks pre-get-data
+vi-pre-get-data() {
    # Only Git and Mercurial support and need caching.
    [[ "$vcs" != git && "$vcs" != hg ]] && return

    # If the shell just started up or we changed directories (or for other
    # custom reasons) we must run vcs_info.
    if zstyle -t ':prems:module:vcs' run 'yes'; then
	zstyle ':prems:module:vcs' run 'no'
        return
    fi

    # If we got to this point, running vcs_info was not forced, so now we
    # default to not running it and selectively choose when we want to run
    ret=1
    # it (ret=0 means run it, ret=1 means don't).

    # If a git/hg command was run then run vcs_info as the status might
    # need to be updated.
    case "$(fc -ln $(($HISTCMD-1)))" in
        git* | hg*)
            ret=0
            ;;
	*)

	    ;;
    esac

    return ret
}

source $moddir/lib/git
source $moddir/lib/hg

source $moddir/alias.zsh

# Local Variables:
#    mode:shell-script
# End:
