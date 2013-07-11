local -a tmuxpath
tmuxpath=('/usr/local/bin' 
    '/usr/bin' 
    '/bin' 
    "$HOME/bin" )

case `uname` in
    "[Ll]inux")
	;;
    "[Dd]arwin")
	tmuxpath+="/usr/local/Cellar/bin"
	;;
    *)
esac

if ! zstyle -t ':prems:module:tmux' exe ; then
    for p in $tmuxpath; do
	[ -e "$p/tmux" ] && zstyle ':prems:module:tmux' exe "$p/tmux" && break
    done
fi
