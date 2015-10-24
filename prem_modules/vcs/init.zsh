autoload -U add-zsh-hook

ZMODDIR="${ZDOTDIR:-$HOME/.zprezto}/modules"
pmodload git

# Need a global associative array we can access from format
typeset -xA my_hook_com

######
## Heart of vcs_info
######
() {
    local enabled
    local disabled
    zstyle -a ':prezto:module:vcs' enabled 'enabled'
    zstyle -a ':prezto:module:vcs' disabled 'disabled'

    zstyle ':vcs_info:*' disable $disabled
    zstyle ':vcs_info:*' enable $enabled

    zstyle ':vcs_info:*' actionformats '{|%s%f%c: %b|%a}'

    # This includes git-svn, hg-svn, hg-git etc
    zstyle ':vcs_info:(hg*|git*):*' get-revision true
    zstyle ':vcs_info:(hg*|git*):*' check-for-changes true


}

# Do not want to dray all values behind, if the user changes
# directories, we may change from one VCS to another
function +vi-clear-hook-array() {
    echo "clearing my_hook_com"
    my_hook_com=()
}

function +vi-show-hook-array() {
    for key in ${(k)my_hook_com}
    do
	print -- "  $key : ${my_hook_com[$key]}"
    done
}

zstyle ':vcs_info:*+pre-get-data:*' hooks myvcs-pre-get-data
+vi-myvcs-pre-get-data() {
    local my_vcs_format my_vcs_formatted
    local -A info_formats
    case $vcs in
    	git*)
    	    zstyle -s ':prezto:module:git:vcs' format 'my_vcs_format'
    	    ;;
    	hg*)
    	    zstyle -s ':prezto:module:hg:vcs' format 'my_vcs_format'
    	    ;;
    	svn*)
    	    zstyle -s ':prezto:module:svn:vcs' format 'my_vcs_format'
    	    ;;
    	*)
    	    echo "RETURNING........."
    	    return
    esac

    zformat -f my_vcs_formatted "$my_vcs_format" "v:$vcs"
    my_hook_com[vcsformatted]="$my_vcs_formatted"
    ############################
    # If the shell just started up or we changed directories (or for other
    # custom reasons) we must run vcs_info.
    if zstyle -t ':prezto:module:vcs' run 'yes'; then
	zstyle ':prezto:module:vcs' run 'no'
    fi
}

source $moddir/lib/git
source $moddir/lib/hg

source $moddir/alias.zsh

# Local Variables:
#    mode:shell-script
# End:
