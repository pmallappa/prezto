### osx / zeesh! plugin

if [ "X"`uname` != "XDarwin" ]; then
    return 0
fi

fpath=( $module_dir/functions $fpath )
autoload -U $module_dir/functions/*(:t)

source $module_dir/lib/env
source $module_dir/lib/aliases

# no core dumps
limit core 0
compctl -K list-sysctls sysctl

## exports
export GEM_HOME=/usr/local
export LSCOLORS=ExfxcxdxbxegedabagAcEx
path+=(	
	/usr/local/share/ruby
	/usr/local/share/python 
	$module_dir/bin	
	/Developer/usr/bin
	/usr/local/homebrew/bin
)

# functions
visor-upgrade() {
    local p='/Applications'
    cp -rf $p/iTerm.app $p/iTermVisor.app
    mv $p/iTermVisor.app/Contents/MacOS/iTerm $p/iTermVisor.app/Contents/MacOS/iTermVisor
    defaults write $p/iTermVisor.app/Contents/Info CFBundleIdentifier com.googlecode.iterm2visor
    defaults write $p/iTermVisor.app/Contents/Info CFBundleExecutable iTermVisor
    defaults write $p/iTermVisor.app/Contents/Info CFBundleName iTermVisor
    defaults write $p/iTermVisor.app/Contents/Info LSUIElement 1
    rm -rf ~$p/iTermVisor.app
    mv $p/iTermVisor.app ~$p
}

lion-hacks() {
    # i like to repeat my self
    defaults write -g ApplePressAndHoldEnabled -bool NO
    # jesus no
    defaults write com.apple.Preview NSQuitAlwaysKeepsWindows -bool NO
    defaults write com.apple.QuickTimePlayerX NSQuitAlwaysKeepsWindows -bool NO
    defaults write com.apple.Safari ApplePersistenceIgnoreState -bool YES
    # animoot
    defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool NO
    defaults write com.apple.Preview NSQuitAlwaysKeepsWindows 0
    # use new list-style, cmd+/- to change icon size
    defaults write com.apple.dock use-new-list-stack -bool YES
    # new dock
    defaults write com.apple.dock no-glass -bool YES
    # speed up sheets slide-in animation
    defaults write -g NSWindowResizeTime -float 0.01
    defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool NO
    killall Dock
}

edit-keymapping() {
    # To modify keyboard mappings navigate to com.apple.keyboard.modifiermapping.* and swap keycodes:
    # None            1
    # Caps Lock       0
    # Shift (Left)    1
    # Control (Left)  2
    # Option (Left)   3
    # Command (Left)  4
    # Keypad 0        5
    # Help            6
    # Shift (Right)   9
    # Control (Right) 10
    # Option (Right)  11
    # Command (Right) 12

    open ~/Library/Preferences/ByHost/.GlobalPreferences.*.plist
}

dynamic-pager-enable() {
    sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.dynamic_pager.plist
    sudo rm -rf /var/vm/*
}

dynamic-pager-disable() {
    sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.dynamic_pager.plist
}

ps() {
    if [ $1 ]; then
        /bin/ps $@
    else
        ps ux -U `whoami`
    fi
}

last-modified(){
    stat -f '%m' $1
}


# Local Variables:
#    mode:shell-script
# End:
