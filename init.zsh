#
# Initializes Prezto.
#
# Authors:
#   Prem Mallappa <prem.mallappa@gmail.com>
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

#
# Version Check
#

# Check for the minimum supported version.
min_zsh_version='4.3.11'
if ! autoload -Uz is-at-least || ! is-at-least "$min_zsh_version"; then
  print "prezto: old shell detected, minimum required: $min_zsh_version" >&2
  return 1
fi
unset min_zsh_version

#export ZDOTDIR=${HOME}

## env_append PATH ~/bin
env_append() { env_remove $1 $2 && export $1="`printenv $1`:$2"; }
env_prepend () { env_remove $1 $2 && export $1="$2:`printenv $1`"; }

## env_remove PATH ~/bin
env_remove ()  {
    [[ "X$1" == "X" ]] && return

    [[ "X$2" == "X" ]] && return

    export $1=`printenv $1 | awk -v RS=: -v ORS=: '$0 != "'$2'"' | sed 's/:$//'`;
}
path_append ()  { env_append PATH $1; }
path_prepend () { env_prepend PATH $1; }
path_remove () { env_remove PATH $1; }

#
# Module Loader
#

# Loads Prezto modules.
function pmodload {
  local -a pmodules
  local pmodule
  local pfunction_glob='^([_.]*|prompt_*_setup|README*)(-.N:t)'
  local zd=${ZDOTDIR:-${HOME}}
  local modulesdir=${ZMODDIR:-${zd}/".zprezto/modules"}


  # $argv is overridden in the anonymous function.
  pmodules=("$argv[@]")

  # Add functions to $fpath.
  fpath=(${pmodules:+${modulesdir}/${^pmodules}/functions(/FN)} $fpath)

  function {
    local pfunction

    # Extended globbing is needed for listing autoloadable function directories.
    setopt LOCAL_OPTIONS EXTENDED_GLOB

    # Load Prezto functions.
    for pfunction in ${modulesdir}/${^pmodules}/functions/$~pfunction_glob; do
      autoload -U "$pfunction"
    done
  }

  # Load Prezto modules.
  for pmodule in "$pmodules[@]"; do
    local moddir="${modulesdir}/$pmodule"
    if zstyle -t ":prezto:module:$pmodule" loaded 'yes' 'no'; then
      continue
    elif [[ ! -d "${modulesdir}/$pmodule" ]]; then
      print "$0: no such module: $pmodule" >&2
      continue
    else
      if [[ -s "${moddir}/init.zsh" ]]; then
        source "${moddir}/init.zsh"
      fi

      if (( $? == 0 )); then
        zstyle ":prezto:module:$pmodule" loaded 'yes'
      else
        # Remove the $fpath entry.
        fpath[(r)${moddir}/functions]=()

        function {
          local pfunction

          # Extended globbing is needed for listing autoloadable function
          # directories.
          setopt LOCAL_OPTIONS EXTENDED_GLOB

          # Unload Prezto functions.
          for pfunction in $moddir/functions/$~pfunction_glob; do
            unfunction "$pfunction"
          done
        }

        zstyle ":prezto:module:$pmodule" loaded 'no'
      fi
    fi
  done
}

#
# Prezto Initialization
#

# Source the Prezto configuration file.
if [[ -s "${ZDOTDIR:-$HOME}/.zpreztorc" ]]; then
  source "${ZDOTDIR:-$HOME}/.zpreztorc"
fi

# Disable color and theme in dumb terminals.
case $TERM in
	'9term' | 'dumb' | 'eterm')
  zstyle ':prezto:*:*' color 'no'
  zstyle ':prezto:module:prompt' theme 'off'
  ;;
  *)
esac

# Load Zsh modules.
zstyle -a ':prezto:load' zmodule 'zmodules'
for zmodule ("$zmodules[@]") zmodload "zsh/${(z)zmodule}"
unset zmodule{s,}

# Autoload Zsh functions.
zstyle -a ':prezto:load' zfunction 'zfunctions'
for zfunction ("$zfunctions[@]") autoload -Uz "$zfunction"
unset zfunction{s,}

# Load Prezto modules.
ZMODDIR="${ZDOTDIR:-$HOME/.zprezto}/modules"
zstyle -a ':prezto:load' pmodule 'pmodules'
pmodload "$pmodules[@]"
unset pmodules

#set -x
# Load Prems modules, override anything that is not needed
ZMODDIR="${ZDOTDIR:-$HOME/.zprezto}/prem_modules"
zstyle -a ':prems:load' pmodule 'pmodules'
pmodload "$pmodules[@]"
unset pmodules

unset ZMODDIR

function {
    fpath=(${ZDOTDIR:-${HOME}/".zprezto"}/functions(/FN) $fpath)
    autoload -U ${fpath[1]}/*(:t)
}
