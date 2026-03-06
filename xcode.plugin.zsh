# -*- mode: sh; eval: (sh-set-shell "zsh") -*-
#
# @name xcode
# @brief Zsh plugin to add Xcode command line tools to path.
# @repository https://github.com/johnstonskj/zsh-xcode-plugin
#

############################################################################
# @section Lifecycle
# @description Plugin lifecycle functions.
#

xcode_plugin_init() {
    builtin emulate -L zsh

    if [[ "${OSTYPE}" == [Dd]arwin* ]]; then
        local xcode_path="$(xcode-select -p)"
        @zplugins_add_to_path xcode "${xcode_path}"
    fi
}

