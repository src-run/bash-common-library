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
# write dependency loaded debug text
#
_core_dependency_loaded "${BASH_SOURCE[0]}"

#
# handle auto dependency resolution
#
if [ ${_CORE_DEPENDENCY_AUTO} -eq 1 ]; then
  _dependencies_resolve_paths
fi
