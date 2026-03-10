# -*- mode: sh; eval: (sh-set-shell "zsh") -*-
#
# @name: xcode
# @brief: Add Xcode command-line tools to path.
# @repository: https://github.com/johnstonskj/zsh-xcode-plugin
# @version: 0.1.1
# @license: MIT AND Apache-2.0
#

############################################################################
# @section Lifecycle
# @description Plugin lifecycle functions.
#

xcode_plugin_init() {
    builtin emulate -L zsh

    if [[ "${OSTYPE}" == [Dd]arwin* ]]; then
        local xcode_path="$(xcode-select -p)"
        if [[ $? -eq 0 ]]; then
            @zplugins_add_to_path xcode "${xcode_path}"
        else
            log_error "zsh-xcode: Error calling xcode-select, could not set path"
        fi
    fi
}

