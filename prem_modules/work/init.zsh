fpath=( $moddir/functions $fpath )
autoload -U $moddir/functions/*(:t)

setopt nofunctionargzero

###
# Function used to boot PCI-e based NIC cards
function nic_boot() {
}
