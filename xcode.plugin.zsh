# -*- mode: sh; eval: (sh-set-shell "zsh") -*-
#
# Plugin Name: xcode
# Repository: https://github.com/johnstonskj/zsh-xcode-plugin
#
# Description:
#
#   Zsh plugin to add Xcode command line tools to path.
#
# Public variables:
#
# * `XCODE`; plugin-defined global associative array with the following keys:
#   * `_ALIASES`; a list of all aliases defined by the plugin.
#   * `_FUNCTIONS`; a list of all functions defined by the plugin.
#   * `_PLUGIN_DIR`; the directory the plugin is sourced from.
#   * `XCODE_PATH`; path for Apple Xcode.
#

############################################################################
# Standard Setup Behavior
############################################################################

# See https://wiki.zshell.dev/community/zsh_plugin_standard#zero-handling
0="${ZERO:-${${0:#$ZSH_ARGZERO}:-${(%):-%N}}}"
0="${${(M)0:#/*}:-$PWD/$0}"

# See https://wiki.zshell.dev/community/zsh_plugin_standard#standard-plugins-hash
declare -gA XCODE
XCODE[_PLUGIN_DIR]="${0:h}"
XCODE[_FUNCTIONS]=""

# Set the path for any custom directories here.
if [[ "${OSTYPE}" == [Dd]arwin* ]] ; then
    XCODE[_PATH]="$(xcode-select -p)"
fi

############################################################################
# Internal Support Functions
############################################################################

#
# This function will add to the `XCODE[_FUNCTIONS]` list which is
# used at unload time to `unfunction` plugin-defined functions.
#
# See https://wiki.zshell.dev/community/zsh_plugin_standard#unload-function
# See https://wiki.zshell.dev/community/zsh_plugin_standard#the-proposed-function-name-prefixes
#
.xcode_remember_fn() {
    builtin emulate -L zsh

    local fn_name="${1}"
    if [[ -z "${XCODE[_FUNCTIONS]}" ]]; then
        XCODE[_FUNCTIONS]="${fn_name}"
    elif [[ ",${XCODE[_FUNCTIONS]}," != *",${fn_name},"* ]]; then
        XCODE[_FUNCTIONS]="${XCODE[_FUNCTIONS]},${fn_name}"
    fi
}
.xcode_remember_fn .xcode_remember_fn

#
# This function does the initialization of variables in the global variable
# `XCODE`. It also adds to `path` and `fpath` as necessary.
#
xcode_plugin_init() {
    builtin emulate -L zsh
    builtin setopt extended_glob warn_create_global typeset_silent no_short_loops rc_quotes no_auto_pushd

    # Add _PATH to path.
    path+=( "${XCODE[_PATH]}" )
}
.xcode_remember_fn xcode_plugin_init

############################################################################
# Plugin Unload Function
############################################################################

# See https://wiki.zshell.dev/community/zsh_plugin_standard#unload-function
xcode_plugin_unload() {
    builtin emulate -L zsh

    # Remove all remembered functions.
    local plugin_fns
    IFS=',' read -r -A plugin_fns <<< "${XCODE[_FUNCTIONS]}"
    local fn
    for fn in ${plugin_fns[@]}; do
        whence -w "${fn}" &> /dev/null && unfunction "${fn}"
    done
    
    # Removing _PATH entries.
    path=( "${(@)path:#${XCODE[_PATH]}}" )

    # Remove the global data variable.
    unset XCODE

    # Remove this function.
    unfunction xcode_plugin_unload
}

############################################################################
# Initialize Plugin
############################################################################

xcode_plugin_init

true
