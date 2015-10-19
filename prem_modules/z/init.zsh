typeset -g goroot_paths
goroot_paths=($HOME/'devel/compilers/goroot')

function set_go_paths() {
    if (( $+commands[go] )); then
        go env | while read line; do
                     [[ "$line" =~ "TERM*" ]] && continue
                     eval export $line
		 done
	export PATH=${PATH}:${GOBIN}
    else

	for p in $goroot_paths; do
	    [ -e "$p/bin/go" ] && export GOROOT=$p && break
	done
	
	if [ -z "$GOROOT" ] && echo "GOROOT not set, probably not installed"
    fi
}
#export set_go_paths
