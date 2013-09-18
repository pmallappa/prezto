#
# My Plan9port environment setup.
#
# Authors:
#   Prem Mallappa <prem.mallappa@gmail.com>
#


local -a p9portpath
p9portpath=('/usr/local/plan9' 
    '/usr/local/plan9port' 
    '$HOME/plan9port' )

case `uname` in
    "[Ll]inux")
	;;
    "[Dd]arwin")
	tmuxpath+="/usr/local/Cellar/"
	;;
    *)
esac


if ! zstyle -t ':prems:module:plan9port' base ; then
    for p in $p9portpath; do
		if [ -e "$p/bin/acme" ]; then
	 		zstyle ':prems:module:plan9port' base "$p"
		 	export "PLAN9=$p"
	 		path_append $PLAN9/bin
			break
		fi
    done
fi

# Return if requirements are not found.
if (( ! $+commands[acme] )); then
  echo "PLAN9PORT not found"  
  return 1
fi

#
# Aliases
#
