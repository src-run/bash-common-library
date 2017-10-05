#!/bin/bash

##
## This file is part of the `src-run/bash-core-library` project.
##
## (c) https://github.com/src-run/bash-core-library/graphs/contributors
##
## For the full copyright and license information, please view the LICENSE.md
## file that was distributed with this source code.
##

#
# internal variables
#
readonly _CORE_VERSION="master"
readonly _CORE_SELF_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/"

#
# include dependencies
#
source "${_CORE_SELF_PATH}_core-variables.bash"
source "${_CORE_SELF_PATH}_core-stdio.bash"
source "${_CORE_SELF_PATH}_core-users.bash"
source "${_CORE_SELF_PATH}_core-dependencies.bash"
source "${_CORE_SELF_PATH}_core-construct.bash"
